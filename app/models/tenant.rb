class Tenant < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :user_id

  validates_uniqueness_of :name
  validates_format_of :name, :with => /^[0-9_a-z]+$/

  after_create :create_project

  def create_project
    Dir.chdir('/var/www-data') do
      system "git clone blog #{name}"
      Dir.chdir("/var/www-data/#{name}") do
        File.open("/var/www-data/#{name}/config/database.yml", "w") do |file| # w -> overwrite
          file.write database_config name
        end
      end
    end
    File.symlink("/var/www-data/#{name}/public", "/var/www-data/projo/public/#{name}")
    set_nginx_config
    system "/var/www-data/projo/lib/deploy.sh #{name}"
  end

  private

  def set_nginx_config
    file = File.open('/opt/nginx/conf/nginx.conf', 'r+') # r+ -> read/write from begginin of a file
    file.seek(-2, IO::SEEK_END)
    file.write tenant_config
    file.close
  end

  def tenant_config
    ["",
     "\tserver {",
     "\t\tlisten 8080;",
     "\t\tserver_name #{name}.dobri.robopartans.com;",
     "\t\tpassenger_enabled on;",
     "\t\troot /var/www-data/#{name}/public;",
     "\t}",
     "}"].join "\n"
  end

  def database_config database
    ["production:",
     "  adapter: mysql2",
     "  username: root",
     "  password: robopart",
     "  database: #{database}",
     "  pool: 5",
     "  timeout: 5000"].join "\n"
  end

  def create_db
    system "RAILS_ENV=production rake db:create"
    system "RAILS_ENV=production rake db:migrate"
  end
end
