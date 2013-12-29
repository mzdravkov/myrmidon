require './lib/nginx.rb'
require 'fileutils'
require 'yaml'

CONF = YAML.load_file('./config/application.yml') unless defined? CONF

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

    def self.docker_run_options name, port
      docker_run_options = [
        "-d",
        "-name #{name}",
        "-p #{port}:#{CONF['tenants_port']}",
        "-v #{CONF['tenants_configs_dir']}:#{CONF['tenants_config_path']}:ro",
        "-v #{File.join(CONF['tenants_plugins_dir'], name)}:#{CONF['tenants_plugins_path']}:ro"
      ]
      docker_run_options += CONF['docker_options'] unless CONF['docker_options'].nil?
      docker_run_options
    end

    def self.docker_run_arguments
      docker_run_arguments = [CONF['docker_image']]
      docker_run_arguments += CONF['container_entry_command'] unless CONF['container_entry_command'].nil?
      docker_run_arguments
    end

    def self.location_options port
      {
        'proxy_pass' => "http://#{CONF['server_ip']}:#{port}/$1",
        'resolver' => "#{CONF['nginx_location_resolver']}"
      }
    end

    def self.make_tenant_config name
      FileUtils.cp CONF['tenants_default_config'], File.join(CONF['tenants_configs_dir'], name + '.yml')
    end

    def self.make_plugins_dir name
      Dir.mkdir File.join(CONF['tenants_plugins_dir'], name)
    end

    def self.deploy name
      port = find_free_port
      opts = docker_run_options(name, port)
      args = docker_run_arguments
      make_tenant_config name
      make_plugins_dir name
      Kernel.system "docker run #{opts.join(' ')} #{args.join(' ')}"
      location_options = location_options(port)
      Nginx::Config.add_location name, location_options
      Kernel.system "sudo #{CONF['nginx_bin']} -s reload"
    end
  end

  #currently not working
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
end
