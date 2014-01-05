class AddAttachmentArchiveToPlugins < ActiveRecord::Migration
  def self.up
    remove_column :users, :archive_file_name
    remove_column :users, :archive_content_type
    remove_column :users, :archive_file_size
    remove_column :users, :archive_updated_at
    change_table :plugins do |t|
      t.attachment :archive
    end
  end

  def self.down
    drop_attached_file :plugins, :archive
  end
end
