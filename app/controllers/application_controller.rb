class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :authenticate_user!

  allow_browser versions: :modern

  private

  def current_account
    @current_account ||= current_user.account
  end

  def current_date_rage
    @current_date_rage ||= Date.current.beginning_of_month.. Date.current.end_of_month
  end
end
