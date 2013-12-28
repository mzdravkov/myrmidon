require './lib/nginx.rb'
require 'yaml'

CONF = YAML.load(File.read('./config/application.yml'))

module DeployStrategies
  module Docker
    def self.port_free? port
      return true if `netstat -na | grep tcp | grep #{CONF['server_ip']}:#{port}`.empty?
      false
    end

    def self.find_free_port
      port = rand(1025..64000)
      port = rand(1025..64000) until port_free?(port)
      port
    end

    def self.deploy name
      `docker run -d -name #{name} -p #{port = find_free_port}:3000 #{CONF['docker_image']}`
      location_options = {
        'resolver'   => '8.8.8.8',
        'proxy_pass' => "http://#{CONF['server_ip']}:#{port}/$1"
      }
      Nginx::Config.add_location name, location_options
      `sudo #{CONF['nginx_bin']} -s reload`
    end
  end

  module FreeBSD_jails
    def self.deploy name
      `ezjail-admin create #{name} #{CONF['server_ip']}`
      location_options = {
        'passenger_base_uri' => '/' + name,
        'alias'              => File.join(CONF['jails_dir'], "#{name}/app/public$1"),
        'passenger_app_root' => File.join(CONF['jails_dir'], "#{name}/app"),
        'passenger_enabled'  => 'on'
      }
      Nginx::Config.add_location name, location_options
      `#{CONF['nginx_bin']} -s reload`
    end
  end

  module Ruby
    def self.deploy name
      config = {
        'passenger_base_uri' => '/' + name,
        'alias'              => File.join(CONF['tenants_dir'], "#{name}/public$1"),
        'passenger_app_root' => File.join(CONF['tenants_dir'], "#{name}"),
        'passenger_enabled'  => 'on'
      }
      Dir.chdir(CONF['tenants_dir']) do
        `git clone #{CONF['app_repo']} #{name}`
      end
      Nginx::Config.add_location(name, config)
      `#{CONF['nginx_bin']} -s reload`
    end
  end
end
