require "./core/agent"

AppName = "app"
Platform = "host"

agent = HostAgent.new(
  app_name: AppName,
  platform: Platform,
  debug: false
)

namespace :mruby do
  desc "init mruby"
  task :init do
    agent.clean_all
    agent.mruby_download
    agent.copy_config
    agent.mruby_build
  end

  desc "download mruby"
  task :download do
    agent.mruby_download
  end

  desc "copy custom build_config to mruby"
  task :copy_config do
    agent.copy_config
  end

  desc "build mruby"
  task :build => [:copy_config] do
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
