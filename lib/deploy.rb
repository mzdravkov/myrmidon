require './lib/nginx.rb'
NAME = ARGV[0]
`ezjail-admin create #{NAME} #{ENV['server_ip']}`
location_options = {
  'passenger_base_uri' => '/' + NAME,
  'alias'              => File.join(ENV['jails_dir'], "#{NAME}/app/public$1"),
  'passenger_app_root' => File.join(ENV['jails_dir'], "#{NAME}/app"),
  'passenger_enabled'  => 'on'
}
Nginx::Config.add_location NAME, location_options
`#{ENV['nginx_bin']} -s reload`
