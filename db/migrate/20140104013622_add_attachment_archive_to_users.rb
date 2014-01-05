class AddAttachmentArchiveToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :archive
    end
  end

  def self.down
    drop_attached_file :users, :archive
  end
end
