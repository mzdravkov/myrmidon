class Plugin < ActiveRecord::Base
  belongs_to :tenant

  validates :name, presence: true, format: {with: /^[a-z_A-Z]+$/, message: 'Only letters, underscore and numbers allowed.'}
  validates :description, presence: true
  validates_attachment :archive, :presence => true,
  :content_type => { :content_type => "application/x-gzip" },
  :size => { :in => 0..10.megabytes }

  attr_accessible :description, :name, :public, :archive
  has_attached_file :archive, path: File.join(ENV['tenants_plugins_dir'], ':plugin_tenant_name', ':filename')

  after_create :extract

  def extract
    p archive_file_name
    Dir.chdir File.join(ENV['tenants_plugins_dir'], tenant.name) do
      `tar xvzf #{archive_file_name}`
    end
  end

  private

  Paperclip.interpolates :plugin_tenant_name do |attachment,  style|
    attachment.instance.tenant.name
  end
end
