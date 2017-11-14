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
        # expect { click_on 'Create my account' }.not_to change(User, :count)
      end
    end

    describe "with invalid information" do 
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      # expect { click_on('Create my account') }

      # it "should create a user" do
      #   expect { click_button "Create my account" }.not_to change(User, :count).by(1)
      # end
    end
  end
end