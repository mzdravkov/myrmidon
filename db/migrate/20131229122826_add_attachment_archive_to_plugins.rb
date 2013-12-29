class AddAttachmentArchiveToPlugins < ActiveRecord::Migration
  def self.up
    change_table :plugins do |t|
      t.attachment :archive
    end
  end

  def self.down
    drop_attached_file :plugins, :archive
  end
end
