class PluginsController < ApplicationController
  def new
    @plugin = Plugin.new
  end

  def create
    tenant_name = params[:plugin].delete :tenant
    @plugin = Plugin.new(params[:plugin])
    @plugin.tenant = Tenant.find_by_name(tenant_name)
    if @plugin.save
      redirect_to root_url, notice: 'You have successfully uploaded a new plugin!'
    else
      errors = @plugin.errors.messages.map { |k, v| k.to_s+' ' + v.join(' and ')+' ' }
      redirect_to root_url, alert: 'There was an error while trying to create your plugin. ' + errors.join(' ')
    end
  end
end
