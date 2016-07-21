class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user_or_admin!

  def current_ability
    @current_ability ||= Ability.new(
      if admin_signed_in?
        current_admin
      elsif user_signed_in?
        current_user
      end)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:danger] = t "not_authorized"
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up){|u| u.permit(:name,
      :chatwork_name, :chatwork_api_key, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:name,
      :chatwork_name, :chatwork_api_key, :email, :password, :password_confirmation,
      :current_password)}
  end

  def layout_by_resource
    if (devise_controller? && resource_name == :admin) || admin_signed_in?
      "admin_application"
    elsif (devise_controller? && resource_name == :user) || user_signed_in?
      "user_application"
    else
      "application"
    end
  end

  def authenticate_user_or_admin!
    namespace = controller_path.split("/").first
    if namespace == "users"
      authenticate_user!
    elsif namespace == "admins"
      authenticate_admin!
    end
  end
end
