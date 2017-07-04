require "bundler/setup"
Bundler.require( :default, :development, :test )

# Автоматический запуск тестов
require "minitest/autorun"
require "minitest/stub_const"
require "mocha/mini_test"
require "wrong/adapters/minitest"

FactoryGirl.reload
FactoryGirlSequences.reload

class Minitest::Spec
  include Wrong::Assert
  include Wrong::Helpers
  include FactoryGirl::Syntax::Methods
end

Dir.glob( File.expand_path( "./support/**/*.rb", __dir__ )).each { |file| require file }
[:master, :worker].each do |daemon|
  $LOAD_PATH.push(File.join(__FILE__, "../../daemons/#{daemon}"))
end
