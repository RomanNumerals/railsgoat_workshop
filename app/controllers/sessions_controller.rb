# frozen_string_literal: true
class SessionsController < ApplicationController
  skip_before_action :has_info
  skip_before_action :authenticated, only: [:new, :create]

  def new
    @url = params[:url]
    redirect_to home_dashboard_index_path if current_user
  end

  def create
    path = params[:url].present? ? params[:url] : home_dashboard_index_path
    begin
      # Normalize the email address, why not
      user = User.authenticate(params[:email].to_s.downcase, params[:password])
    rescue Exception => e
      # don't do ANYTHING
    end

    if user
      session[:user_id] = user.id if User.where(:id => user.id).exists?
      redirect_to home_dashboard_index_path
      else
        flash[:error] = "Either your username and passord is incorrect"
        render "new"
      end
  end

  def destroy
    cookies.delete(:auth_token)
    reset_session
    redirect_to root_path
  end
end
