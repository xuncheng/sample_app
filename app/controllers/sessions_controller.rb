class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:sessions][:email].downcase)
    if user && user.authenticate(params[:sessions][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
