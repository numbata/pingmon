namespace :test do
  APP_ROOT = File.expand_path( "../..", __dir__ )
  TESTS_DIR = File.join( APP_ROOT, "test" )

  def run_tests( *paths )
    require "shellwords"

    paths = paths.map { |path| File.join( TESTS_DIR, path, "**", "*_{spec,test}.rb" ) }
    test_files = FileList.new( paths ).to_a

    return unless test_files.any?

    cmd = [
      "-I", Shellwords.escape( TESTS_DIR ),
      "-e", "'ARGV.select { |arg| arg =~ /\\// }.each { |file| require file }'"
    ]

    if i = ARGV.index { |arg| arg.start_with? "-" }
      cmd.push "--", *ARGV[ i .. -1 ].map { |arg| Shellwords.escape arg }
    end

    ruby "#{cmd.join( " " )} #{test_files.map { |path| Shellwords.escape path }.join( " " )}"
  end

  [ :master, :worker ].each do |daemon_name|
    desc "Run tests for #{daemon_name} daemon"
    task daemon_name do
      run_tests "daemons/#{daemon_name}"
    end
  end

  desc "Run tests from lib"
  task :lib do
    run_tests "lib"
  end

  task :all do
    run_tests "."
  end
end

desc "Run all tests"
task :test => "test:all"
