require 'pry'

class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    binding.pry
    user = user_email.present? && User.find_by(email: user_email)

    if user.present? and user.valid_password? user_password
      binding.pry
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

end