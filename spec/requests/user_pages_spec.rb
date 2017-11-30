require 'spec_helper'

describe "User pages" do

  subject { page }

  # Index tests

  describe "index" do 
    let(:user) { FactoryBot.create(:user) }

    before(:each) do 
      sign_in user
    end

    # Solved issue with drop this tests ?

    before do 
      visit users_path 
      it { should have_title('All users') }
      it { should have_content('All users') }
    
      describe "pagination" do 
        before(:all)  { 30.times { FactoryBot.create(:user) } }
        after(:all)   { User.delete_all }

        it { should have_selector('div.pagination') }
        it "should list each user" do 
          User.all.each do |user|
            expect(page).to have_selector('li', text: user.name)
          end
        end # End should list each user
      end   # End describe pagination
    end

    describe "delete links" do 
      before do 
        visit users_path 
        it { should_not have_link('delete') }
      end
      
      describe "as an admin user" do 
        let(:admin) { FactoryBot.create(:admin) }
        before do 
          sign_in admin
        end

        before do 
          visit users_path
          it { should have_link('delete', href: user_path(User.first)) }
          it "should be able to delete another user" do 
            expect do 
              click_link('delete', match: :first)
            end.to change(User, :count).by(-1)
          end
          it { should_not have_link('delete', href: user_path(admin)) }
        end
      end
    end
  end
    # !!!!!!! END !!!!!!!
    # End index tests

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
        visit signup_path
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
        click_button( submit )
      end

      describe "after saving the user" do
        
        let(:user) { User.find_by_email("user@example.com") }

        it { should has_selector?('title') }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end

      # it "should create a user" do
      #   expect { find_button( submit ).click }.not_to change(User, :count).by(1)
      # end
    end
  end

  describe "edit" do
    let(:user) { FactoryBot.create(:user) }
    before do 
      sign_in user
      visit edit_user_path(user)
    end
    before { visit edit_user_path(user) }

    describe "page" do
      before { visit edit_user_path(user) }

      it { should have_content("Update") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",             with: new_name  
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save change"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to   eq new_name }
      specify { expect(user.reload.email).to  eq new_email }
    end

    describe "forbidden attributes" do 
      let(:params) do 
        { user: { admin: true, password: user.password, password_confirmation: user.password }} 
      end
      before do 
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end
end