require "bundler/setup"
Bundler.require( :default, :development, :test )

$LOAD_PATH.push(File.join(__dir__, '../lib'))
$LOAD_PATH.push(File.join(__dir__, '../models'))

# Автоматический запуск тестов
require "minitest/autorun"
require "minitest/stub_const"
require "mocha/mini_test"
require "wrong/adapters/minitest"
require 'database'

Dir.glob( File.expand_path( "../models/**/*.rb", __dir__ )).each { |file| require file }

FactoryGirl.reload
FactoryGirlSequences.reload
FactoryGirl.define do
  to_create { |instance| instance.save }
end

class Minitest::Spec
  include Wrong::Assert
  include Wrong::Helpers
  include FactoryGirl::Syntax::Methods
end

Dir.glob( File.expand_path( "./support/**/*.rb", __dir__ )).each { |file| require file }
[:master, :worker].each do |daemon|
  $LOAD_PATH.push(File.join(__FILE__, "../../daemons/#{daemon}"))
end
