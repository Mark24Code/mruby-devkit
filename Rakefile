require_relative "./config"
require_relative "./task/agent/#{Devkit::Platform}"

platform = Devkit::Platform

agent_klass = Object.const_get("#{platform.capitalize}Agent")
agent = agent_klass.new(
  platform: Devkit::Platform,
  app_name: Devkit::AppName,
  debug: Devkit::Debug
)

namespace :mruby do
  # desc "init mruby"
  task :init do
    if !agent.mruby_dir.exist?
      agent.clean_all
      agent.mruby_download
    end
    agent.mruby_config
    if !agent.mruby_build_dir.exist?
      agent.mruby_build
    end
  end

  # desc "download mruby"
  task :download do
    agent.mruby_download
  end
end

desc "run program"
task :run => [:"mruby:init"] do
  agent.run
end

desc "build program"
task :build => [:"mruby:init"] do
  agent.build
end
