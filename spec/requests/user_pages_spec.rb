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
    
    # describe "with invalid information" do 
    #   it "should not create user" do 
    #     expect { click_on 'Create my account' }.not_to change(User, :count)
    #   end
    # end

    describe "with valid information" do 
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      describe "after submission" do
        before { click_button( :button, submit) }  

        it { should have_title('Sign up') }
        it { should have_content('error') }
      end

      describe "after saving the user"
        before { click_button( submit ) }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name)}
        it { should has_content?('div.alert.alert-success') }

      end
      # expect { click_on('Create my account') }

      # it "should create a user" do
      #   expect { click_button "Create my account" }.not_to change(User, :count).by(1)
      # end
    end
  end