require "sinatra"
Dir.glob("lib/tasks/*.rake").each { |r| load r }

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)
