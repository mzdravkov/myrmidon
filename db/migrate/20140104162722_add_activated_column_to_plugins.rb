class AddActivatedColumnToPlugins < ActiveRecord::Migration
  def change
    add_column :plugins, :activated, :boolean
  end
end
