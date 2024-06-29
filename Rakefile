require_relative "./config"
require_relative "./task/agent/#{Devkit::Platform}"

platform = Devkit::Platform
agent_klass = Object.const_get("#{platform.capitalize}Agent")
agent = agent_klass.new(
  app_name: Devkit::AppName,
  debug: Devkit::Debug
)

namespace :mruby do
  desc "init mruby"
  task :init do
    agent.clean_all
    agent.mruby_download
    agent.mruby_config
    agent.mruby_build
  end

  # desc "download mruby"
  task :download do
    agent.mruby_download
  end

  # desc "copy custom build_config to mruby"
  task :mruby_config do
    agent.mruby_config
  end

  # desc "build mruby"
  task :build => [:mruby_config] do
    agent.mruby_build
  end
end

desc "run program"
task :run do
  agent.run
end

desc "build program"
task :build do
  agent.build
end
