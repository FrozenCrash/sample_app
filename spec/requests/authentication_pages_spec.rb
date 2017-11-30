# require 'rails_helper'
require 'spec_helper'
# RSpec.describe "AuthenticationPages", type: :request do
#   describe "GET /authentication_pages" do
#     it "works! (now write some real specs)" do
#       get authentication_pages_index_path
#       expect(response).to have_http_status(200)
#     end
#   end
# end

describe "Authentication", type: :request do
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do 
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error') }

      describe "afet visiting another page" do
        before { click_link "Home" }
        it { should_not has_selector?('div.alert.alert-error')}
      end
    end

    describe "with valid information" do
      let(:user) { FactoryBot.create(:user) }
      before do 
        visit signin_path
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { should have_title(user.name) }
      it { should have_link('Users',        href: users_path) }
      it { should have_link('Profile',      href: user_path(user)) }
      it { should have_link('Settings',     href: edit_user_path(user)) }
      it { should have_link('Sign out',     href: signout_path) }
      it { should_not have_link('Sign in',  href: signin_path) }

      describe "followed by signout" do 
        before { click_link "Sign out" }
        it { should have_link "Sign in" }
      end
    end
  end

  describe "authorization" do 
    describe "for non-sign-in user" do 
      let(:user) { FactoryBot.create(:user) }

      describe "when attempting to visit a protecte page" do 
        before do 
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do 
          before { visit edit_user_path(user) }
          
          it "should render the desired protected page" do 
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do 
            before do 
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
              it { expect(page).to have_title(user.name) }
            end
          end
        end
      end

      describe "in the User controller" do 
        
        describe "visiting the edit page" do 
          before { visit edit_user_path(user) }
          it { should have_title("Sign in") }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do 
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user" do 
      let(:user) { FactoryBot.create(:user) }
      let(:wrong_user) { FactoryBot.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the User#edit action" do 
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit action')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe "submitting a PATCH request to the User#update action" do 
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do 
      let(:user) { FactoryBot.create(:user) }
      let(:non_admin) { FactoryBot.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the User#destroy action" do 
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end
  end
end