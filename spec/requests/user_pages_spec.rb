require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile name" do
    let(:user) { FactoryBot.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) } 
  end

  describe "signup page" do
    before { visit signup_path }

    let(:submit) { "Create my account" }
    
    describe "with invalid information" do 
      it "should not create user" do 
        expect { find_button( submit ).click }.not_to change(User, :count)
      end
    end
    
    describe "with valid information" do 
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      describe "after submission" do
        before { visit signup_path }
        before { click_button( submit ) }  

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

      describe "after saving the user"
        before { click_button( submit ) }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(User.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome' ) }
      end

      # it "should create a user" do
      #   expect { find_button( submit ).click }.not_to change(User, :count).by(1)
      # end
    end
  end

  describe "edit" do
    let(:user) { FactoryBot.create(:user) }
    before do 
      visit signin_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "123456"
      click_button("Sign in")
    end
    before { visit edit_user_path(user) }

    describe "page" do
      before do
        visit edit_user_path(user)
        save_and_open_page
      end

      it { should have_content("Update") }
      # it { should have_title("Edit user") }
      # it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      # it { should have_content('error') }
    end
  end
