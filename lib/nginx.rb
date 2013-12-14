module Nginx
  module Config
    extend Config # so that methods that use private methods can be called without including the module
    def add_server_block options
      match = File.read(ENV['nginx_config_file']).match(/http\s*{/)
      import_to_conf match, server_block(options)
    end

    def add_location path, options # path without /
      match = File.read(ENV['nginx_config_file']).match(/server\s*{/)
      import_to_conf match, location_block(path, options)
    end

    private

    def import_to_conf match, string
      config = match.pre_match + match.to_s + string + match.post_match

      File.open ENV['nginx_config_file'], 'w' do |new_conf|
        new_conf.print config
      end
    end

    def server_block options
      "\n\tserver {\n\t\t" +
        options.map { |opt, value| opt.to_s + ': ' + value.to_s + ';' }.join("\n\t\t") +
      "\n\t}\n"
    end

    def location_block path, options
      "\n\t\tlocation ~ ^/#{path}(/.*|$) {\n\t\t\t" +
        options.map { |opt, value| opt.to_s + ': ' + value.to_s + ';' }.join("\n\t\t\t") +
      "\n\t\t}\n"
    end
  end
end
