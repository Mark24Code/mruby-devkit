MRUBY_NAME = "3.3.0"

COMPILER_DIR = "./mruby"

MRUBY_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_NAME}.zip"
MRUBY_DIR = "#{COMPILER_DIR}/#{MRUBY_NAME}"
MRUBY = "#{MRUBY_DIR}/build/host/bin/mruby"
MRBC = "#{MRUBY_DIR}/build/host/bin/mrbc"
MRUBY_BUILD_CONFIG = "./mruby.conf.rb"
MGEM_SPEC = "./conf.rb"

BUILD_DIR = "./build"

APP_NAME = "app"

def osname
  case RUBY_PLATFORM.downcase
  when /darwin/
   "darwin"
  when /linux/
   "linux"
  when /mswin|win32|mingw|cygwin/
   "win"
  else
    nil
  end
end


namespace :mruby do
  desc "download mruby"
  task :download do
    sh "rm -rf .tmp ; rm -rf #{MRUBY_DIR}"
    sh "mkdir .tmp; mkdir -p #{COMPILER_DIR}"
    sh "wget -O .tmp/#{MRUBY_NAME}.zip #{MRUBY_URL}"
    sh "unzip -x ./.tmp/#{MRUBY_NAME}.zip -d ./.tmp"
    sh "mv ./.tmp/mruby-#{MRUBY_NAME} #{MRUBY_DIR}"
    sh "rm -rf .tmp "
  end

  desc "build mruby"
  task :build do
    sh "cd #{MRUBY_DIR} && rake MRUBY_CONFIG=#{APP_NAME}_config"
  end

  desc "replace mruby build config"
  task :build_config do
    sh "cp #{MRUBY_BUILD_CONFIG} #{MRUBY_DIR}/build_config/#{APP_NAME}_config.rb"
  end

  desc "init"
  task :init => [:"mruby:download", :"mruby:build_config"  ] do
    puts "init mruby #{MRUBY_NAME}"
  end

end


desc "merge program"
task :init_build do
  sh "rm -rf #{BUILD_DIR}; mkdir #{BUILD_DIR}"
end


desc "merge program"
task :merge => [:init_build] do
  rbfiles = Dir.glob("src/lib/*.rb")
  sh "cat #{rbfiles.join(" ")} src/main.rb > build/main.rb"
end
