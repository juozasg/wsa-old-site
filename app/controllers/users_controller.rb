class UsersController < ApplicationController
  def show
    @user = Refinery::User.find(params[:id])
  end
end
