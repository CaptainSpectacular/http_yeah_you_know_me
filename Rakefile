require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |test|
  test_pattern = "./test/*_test.rb"
end

desc 'game'
task :game do
  ruby './test/game_test.rb'
end

desc 'requestor'
task :requestor do
  ruby './test/requestor_test.rb'
end

desc 'responder'
task :responder do
  ruby './test/responder_test.rb'
end

desc 'parser'
task :parser do
  ruby './test/parser_test.rb'
end

desc 'headers'
task :headers do
  ruby './test/headers_test.rb'
end

desc 'server'
task :server do
  ruby './test/server_test.rb'
end
