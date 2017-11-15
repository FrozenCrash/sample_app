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
        before { find_button( submit ).click }  

        it { should has_title?('Sign up') }
        it { should has_content?('error') }
      end

      describe "after saving the user"
        # before { find_button( submit ).click }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should has_title?(User.name)}
        it { should has_content?('div.alert.alert-success') }

      end

      # it "should create a user" do
      #   expect { find_button( submit ).click }.not_to change(User, :count).by(1)
      # end
    end
  end