require 'bundler'

$LOAD_PATH.push(File.join(__dir__, 'lib'))
Bundler.require(:default)

Dir.glob(File.expand_path('./lib/tasks/**/*.rake', __dir__)).each do |rakefile|
  Rake.load_rakefile rakefile
end
