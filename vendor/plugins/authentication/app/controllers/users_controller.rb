class UsersController < ApplicationController

  # Protect these actions behind an admin login
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  filter_parameter_logging 'password', 'password_confirmation'

  layout 'admin'

  def new
    render :text => "User signup is disabled", :layout => true unless can_create_public_user
  end

  def create
    unless can_create_public_user
      render :text => "User signup is disabled", :layout => true
    else
      begin
        cookies.delete :auth_token
        # protects against session fixation attacks, wreaks havoc with
        # request forgery protection.
        # uncomment at your own risk
        # reset_session
        @user = User.new(params[:user])
        @selected_plugin_titles = params[:user][:plugins] || []

        @user.register! if @user.valid?
        if @user.errors.empty?
          @user.plugins = @selected_plugin_titles
          self.current_user = @user
          current_user.activate!
          current_user.update_attribute(:superuser, true) if User.count == 1 # this is the superuser if this user is the only user.
          redirect_back_or_default(admin_root_url)
          flash[:notice] = "Welcome to Refinery, #{current_user.login}."

          if User.count == 1 or RefinerySetting[:site_name] == "Company Name"
            refinery_setting = RefinerySetting.find_by_name("site_name")
            flash[:notice] << "<br/>First let's give the site a name. <a href='#{edit_admin_refinery_setting_url(refinery_setting)}'>Go here</a> to edit your website's name"
          end
        else
          render :action => 'new'
        end
      end
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])

    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end

    redirect_back_or_default(root_url)
  end

  def forgot
    if request.post?
      user = User.find_by_email(params[:user][:email])

      if user
        user.create_reset_code

        begin
          flash[:notice] = "An email has been sent to #{user.email} with a link to reset your password."
          UserMailer.deliver_reset_notification(user, request)
        rescue
          info.logger "error: email could not be sent for user password reset"
        end
      else
        flash[:notice] = "Sorry, #{params[:user][:email]} isn't associated with any acounts. Are you sure you typed the correct email address?"
      end

      redirect_back_or_default(forgot_url)
    end
  end

  def reset
    @user = User.find_by_reset_code(params[:reset_code]) unless params[:reset_code].nil?

    if request.post?
      if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
        self.current_user = @user
        @user.delete_reset_code

        flash[:notice] = "Password reset successfully for #{@user.email}"
        redirect_back_or_default(admin_root_url)
      else
        render :action => :reset
      end
    end
  end

protected

  def take_down_for_maintenance?;end

  def can_create_public_user
    User.count == 0
  end

end
