class WelcomeController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    @billings         = current_user.billings.where(status: "0") if current_user
    @personalcharges  = current_user.personalcharges.last(20) if current_user
  end
end