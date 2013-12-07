module Nginx
  module Config
    def add_server_block options
      match = File.read(ENV['nginx_config_file']).match(/http\s*{/)
      config = match.pre_match + match.to_s + server_block(options) + match.post_match

      File.open ENV['nginx_config_file'], 'w' do |new_conf|
        new_conf.print config
      end
    end

    private

    def server_block options
      "\n\tserver {\n\t\t" +
        options.map { |opt, value| opt.to_s + ': ' + value.to_s + ';' }.join("\n\t\t") +
      "\n\t}\n"
    end
  end
end
