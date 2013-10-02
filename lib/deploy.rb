#! /home/dobri/.rvm/rubies/ruby-1.9.3-p448/bin/ruby

def set_nginx_config name
  file = File.open('/opt/nginx/conf/nginx.conf', 'r+') # r+ -> read/write from begginin of a file
  file.seek(-2, IO::SEEK_END)
  file.write tenant_config(name)
  file.close
end

def tenant_config name
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
  `RAILS_ENV=production rake db:create > /var/www-data/db.log`
  `RAILS_ENV=production rake db:migrate >> /var/www-data/db.log`
end

name = ARGV[0]

Dir.chdir('/var/www-data') do
  `which ruby > ruby.log`
  `git clone blog #{name}`
  Dir.chdir("/var/www-data/#{name}") do
    File.open("/var/www-data/#{name}/config/database.yml", "w") do |file| # w -> overwrite
      file.write database_config(name)
    end
    `bundle > /var/www-data/bundle.log`
    create_db
    `RAILS_ENV=production bundle exec rake assets:precompile > precompile.log`
  end
end
File.symlink("/var/www-data/#{name}/public", "/var/www-data/projo/public/#{name}")
set_nginx_config(name)
`/opt/nginx/sbin/nginx -s reload`

