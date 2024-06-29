require_relative "./config"
require_relative "./task/agent/host"
require_relative "./task/agent/wasm"

host_agent = HostAgent.new(
  app_name: Devkit::AppName,
  debug: Devkit::Debug
)

wasm_agent = WasmAgent.new(
  app_name: Devkit::AppName,
  debug: Devkit::Debug
)

namespace :mruby do
  # desc "init mruby"
  task :init do
    if !host_agent.mruby_dir.exist?
      host_agent.clean_all
      host_agent.mruby_download
    end

    config_changed = host_agent.config_changed
    if config_changed
      host_agent.mruby_config
    end

    if !host_agent.mruby_build_dir.exist? || config_changed
      host_agent.mruby_build
    end
  end

  task :init_wasm => [:"mruby:init"] do

    config_changed = wasm_agent.config_changed
    if config_changed
      wasm_agent.mruby_config
    end

    if !wasm_agent.mruby_build_dir.exist? || config_changed
      wasm_agent.mruby_build
    end
  end

  # desc "download mruby"
  task :download do
    host_agent.mruby_download
  end
end

desc "run program"
task :run => [:"mruby:init"] do
  host_agent.run
end

desc "build program"
task :build => [:"mruby:init"] do
  host_agent.build
end

desc "run wasm program"
task :"run:wasm" => [:"mruby:init_wasm"] do
  wasm_agent.run
end

desc "build wasm program"
task :"build:wasm" => [:"mruby:init_wasm"] do
  wasm_agent.build
end

desc "release package"
task :release => [:"build"] do
  host_agent.release
end

task :default do
  system("rake -T")
end
