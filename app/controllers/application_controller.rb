class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  helper_method :current_account
  def current_account
    @current_account ||= current_user.account
  end

  def current_date_rage
    @current_date_rage ||= Date.current.beginning_of_month.. Date.current.end_of_month
  end
end
