require 'erb'
require 'yaml'

module Config
  def self.config
    @config ||= begin
      config_path = ENV['CONFIG'] || '../config/config.yml'
      config_path = File.expand_path(config_path, File.dirname(__FILE__))
      config_yaml = ERB.new(File.read(config_path)).result
      config = YAML.load config_yaml
      app_env = ENV['APP_ENV'] || 'development'

      OpenStruct.new(config[app_env])
    end
  end

  def self.[](key)
    config[key]
  end
end
