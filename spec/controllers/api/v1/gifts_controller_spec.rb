require 'spec_helper'

RSpec.describe Api::V1::GiftsController, type: :controller do
  describe "GET #index" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      @gift = FactoryGirl.create :gift
      @gift.user_id = @user.id
      @gift.save
      get :index
      gifts_response = json_response
      expect(gifts_response).to have_key(:gifts)
    end
    it { should respond_with 200 }
  end

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
      @gift = FactoryGirl.create :gift
    end

    context "when category belongs to user and exists" do
      before(:each) do
        @gift.user_id = @user.id
        @gift.save
        get :show, id: @gift.id
        gift_response = json_response
        expect(gift_response[:gift]).to have_key(:book)
      end
      it { should respond_with 200 }
    end

    context "when category doesn't belong to user or exists" do
      before(:each) do
        get :show, id: @gift.id
      end

      it { should respond_with 404 }

    end

  end

  describe "POST #create" do
    before(:each) do
      @user = FactoryGirl.create :user
      api_authorization_header @user.auth_token
    end

    context "when is successfully created" do
      before(:each) do
        @gift_attributes = {title: "Lśnienie", author: "Stephen King", isbn: ""}
        post :create, {gift: @gift_attributes}
      end

      it "renders the json representation for the user record just created" do
        gift_response = json_response
        expect(gift_response).to have_key(:gift)
      end

      it { should respond_with 201 }
    end

    context "when is successfully created with isbn" do
      before(:each) do
        @book = FactoryGirl.create :book
        @gift_attributes = {title: @book.title, author: @book.author, isbn: @book.isbn}
        post :create, {gift: @gift_attributes}
      end

      it "renders the json representation for the user record just created" do
        gift_response = json_response
        expect(gift_response).to have_key(:gift)
        expect(gift_response[:gift][:book][:title]).to eql @book.title
        expect(gift_response[:gift][:book][:id]).to eql @book.id
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        @invalid_gift_attributes = {title: "", author: "Stephen King", isbn: ""} #notice I'm not including the email
        post :create, {category: @invalid_gift_attributes}
      end

      it "renders an errors json" do
        gift_response = json_response
        expect(gift_response).to have_key(:errors)
      end

      it { should respond_with 422 }
    end
  end
  #
  # describe "PUT/PATCH #update" do
  #   before(:each) do
  #     @user = FactoryGirl.create :user
  #     api_authorization_header @user.auth_token
  #     @category = FactoryGirl.create :category
  #     @category.user_id = @user.id
  #     @category.save
  #   end
  #
  #   context "when is successfully updated" do
  #     before(:each) do
  #       patch :update, {id: @category.id, category: {name: "GoodOne", color: "#b80000", font_color: "#b80000"}}
  #     end
  #
  #     it "renders the json representation for the updated user" do
  #       category_response = json_response
  #       expect(category_response[:name]).to eql "GoodOne"
  #       expect(category_response[:color]).to eq "#b80000"
  #       expect(category_response[:font_color]).to eq "#b80000"
  #     end
  #
  #     it { should respond_with 200 }
  #   end
  #
  #   context "when is not updated" do
  #     before(:each) do
  #       patch :update, {id: @category.id, category: {name: "", color: "b80000", font_color: "b80000"}}
  #     end
  #
  #     it "renders an errors json" do
  #       category_response = json_response
  #       expect(category_response).to have_key(:errors)
  #     end
  #
  #     it "renders the json errors on whye the user could not be updated" do
  #       category_response = json_response
  #       expect(category_response[:errors][:name]).to include "can't be blank"
  #       expect(category_response[:errors][:color]).to include "is invalid"
  #       expect(category_response[:errors][:font_color]).to include "is invalid"
  #     end
  #
  #     it { should respond_with 422 }
  #   end
  #
  #   context "when update is impossible - category doesn't exist" do
  #     before(:each) do
  #       @category.user_id = @category.user_id + 1
  #       @category.save
  #       patch :update, {id: @category.id, category: {name: "GoodOne", color: "#b80000", font_color: "#b80000"}}
  #     end
  #
  #     it { should respond_with 422 }
  #   end
  # end
  #
  # describe "DELETE #destroy" do
  #   before(:each) do
  #     @user = FactoryGirl.create :user
  #     api_authorization_header @user.auth_token
  #     @category = FactoryGirl.create :category
  #     @category.user_id = @user.id
  #     @category.save
  #   end
  #
  #   context "when delete success" do
  #     before(:each) do
  #       delete :destroy, {id: @category.id}
  #     end
  #
  #     it { should respond_with 204 }
  #   end
  #
  #   context "when cannot delete - category doesn't exists" do
  #     before(:each) do
  #       @category.user_id = @category.user_id + 1
  #       @category.save
  #       delete :destroy, {id: @category.id}
  #     end
  #
  #     it { should respond_with 422 }
  #   end
  # end
end
