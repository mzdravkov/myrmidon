class Dodo < Plugman::PluginBase
  def on_deploy tenant
    p tenant.user
  end
end
