class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.integer :tenant_id
      t.string :name
      t.text :description
      t.boolean :public

      t.timestamps
    end
  end
end
