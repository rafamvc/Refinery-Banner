class Refinery::AdminBaseController < ApplicationController

  layout proc { |controller| "admin#{"_dialog" if controller.from_dialog?}" }

  before_filter :correct_accept_header, :login_required, :restrict_plugins, :restrict_controller

  helper_method :searching?

  def admin?
    true # we're in the admin base controller, so always true.
  end

  def searching?
    not params[:search].blank?
  end

protected

  # never take the backend down for maintenance.
  def take_down_for_maintenance?;end

  def error_404
    @page = Page.find_by_menu_match("^/404$", :include => [:parts, :slugs])
    @page[:body] = @page[:body].gsub(/href=(\'|\")\/(\'|\")/, "href='/admin'").gsub("home page", "Dashboard")
    render :template => "/pages/show", :status => 404
  end

  def restrict_plugins
    Refinery::Plugins.set_active( current_user.authorized_plugins ) if current_user.respond_to? :plugins
  end

  def restrict_controller
    if Refinery::Plugins.active.reject {|plugin| params[:controller] !~ Regexp.new(plugin.menu_match) }.empty?
      flash.now[:error] = "You do not have permission to access the #{params[:controller]} controller on this plugin."
      logger.warn "'#{current_user.login}' tried to access '#{params[:controller]}'"
    end
  end

  # Override method from application_controller. Not needed in this controller.
  def find_pages_for_menu; end

private
  # This fixes the issue where Internet Explorer browsers are presented with a basic auth dialogue
  # rather than the xhtml one that they *can* accept but don't think they can.
  def correct_accept_header
    if request.user_agent =~ /MSIE (6|7|8)/
      if request.accept == "*/*"
        request.env["HTTP_ACCEPT"] = request.cookies[:http_accept] ||= "application/xml"
      else
        request.cookies[:http_accept] = (request.env["HTTP_ACCEPT"] = (["text/html"] | request.accept.split(', ')).join(', '))
      end
    end
  end

end
