require "bundler"
Bundler.require(:default)
require 'eventmachine'

# Autoload lib
$LOAD_PATH.push(File.expand_path('../lib', __dir__))

# Require models
require 'database'
Dir.glob( File.expand_path( "../models/**/*.rb", __dir__ )).each { |file| require file }

