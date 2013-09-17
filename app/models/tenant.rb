class Tenant < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :user_id

  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[0-9_a-z]+$/

  after_create :create_project

  def create_project
    Dir.chdir('/www') do
      system "rails new #{name} -T"
      system "ln -s /www/#{name}/public /www/projo/public/#{name}"
    end
    set_nginx_config
    system "sudo service nginx reload"
  end

  private

  def set_nginx_config
    file = File.open('/opt/nginx/conf/nginx.conf', 'r+') # r+ -> read/write from begginin of a file
    file.seek(-4, IO::SEEK_END)
    file.write tenant_config
    file.close
  end

  def tenant_config
    ["",
     "\t\tpassenger_base_uri /#{name};",
     "\t}",
     "}"].join "\n"
  end
end
