class TenantsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @tenant = Tenant.new
  end

  def create
    if tenant = Tenant.new(params[:tenant])
      tenant.save
      redirect_to root_url, notice: "You have successfully created #{tenant.name}"
    else
      redirect_to root_url, alert: "There was an error while trying to create #{tenant.name}"
    end
  end
end
