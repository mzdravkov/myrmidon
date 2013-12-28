require 'yaml'

CONF = YAML.load_file('./config/application.yml') unless defined? CONF

module Nginx
  module Config
    extend Config # so that methods that use private methods can be called without including the module
    def add_server_block options
      match = File.read(CONF['nginx_config_file']).match(/http\s*{/)
      import_to_conf match, server_block(options)
    end

	# path without /
    def add_location path, options
      match = File.read(CONF['nginx_config_file']).match(/server\s*{/)
      import_to_conf match, location_block(path, options)
    end

    private

    #pass string after the opening curly and you will receive the index of the closing or nil
    def find_matching_curly string
      balance = 1
      for i in 0...string.length do
        balance += 1 if string[i] == '{'
        balance -= 1 if string[i] == '}'
        return i if balance == 0
      end
      nil
    end

    def import_to_conf match, string
      #config = match.pre_match + match.to_s + string + match.post_match
      closing_curly_index = find_matching_curly(match.post_match)
      config = match.pre_match + match.to_s + match.post_match[0...closing_curly_index] + string + match.post_match[closing_curly_index...match.post_match.length]

      File.open CONF['nginx_config_file'], 'w' do |new_conf|
        new_conf.print config
      end
    end

    def server_block options
      "\n\tserver {\n\t\t" +
        options.map { |opt, value| opt.to_s + ' ' + value.to_s + ';' }.join("\n\t\t") +
      "\n\t}\n"
    end

    def location_block path, options
      "\n\t\tlocation ~ ^/#{path}(/.*|$) {\n\t\t\t" +
        options.map { |opt, value| opt.to_s + ' ' + value.to_s + ';' }.join("\n\t\t\t") +
      "\n\t\t}\n"
    end
  end
end
