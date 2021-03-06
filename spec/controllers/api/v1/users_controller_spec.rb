require 'spec_helper'

describe Api::V1::UsersController do
  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id
    end

    it "returns the information about a reporter on a hash" do
      user_response = json_response
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        @user_setting_attributes = FactoryGirl.attributes_for :user_setting
        post :create, {user: @user_attributes, user_setting: @user_setting_attributes}
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:email]).to eql @user_attributes[:email]
        expect(user_response[:user_setting][:show_full_name]).to eql @user_setting_attributes[:show_full_name]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = {password: "12345678", password_confirmation: "12345678"} #notice I'm not including the email
        @user_setting_attributes = FactoryGirl.attributes_for :user_setting
        post :create, {user: @invalid_user_attributes, user_setting: @user_setting_attributes}
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 409 }
    end
  end

  describe "PUT/PATCH #update" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
    end

    context "when is successfully updated" do
      before(:each) do
        patch :update, {id: @user.id, user: {email: "newmail@example.com"}, user_setting: {show_activities: true}}
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql "newmail@example.com"
        expect(user_response[:user_setting][:show_activities]).to eql true
        expect(user_response[:user_setting][:show_gifts_boolean]).to eql false
      end

      it { should respond_with 200 }
    end

    context "when is not created" do
      before(:each) do
        patch :update, {id: @user.id, user: {email: "bademail.com"}, user_setting: {show_activities: true}}
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on whye the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      delete :destroy, id: @user.auth_token
    end

    it { should respond_with 204 }

  end

end