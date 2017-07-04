require "bundler"
Bundler.require(:default)

# Autoload lib
$LOAD_PATH.push(File.join(__FILE__, '../..'))

# Require models
require 'database'
Dir.glob( File.expand_path( "../../models/**/*.rb", __dir__ )).each { |file| require file }
