MRUBY_NAME = "3.3.0"

COMPILER_DIR = "./mruby"

MRUBY_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_NAME}.zip"
MRUBY_DIR = "#{COMPILER_DIR}/#{MRUBY_NAME}"
MRUBY = "#{MRUBY_DIR}/build/host/bin/mruby"
MRBC = "#{MRUBY_DIR}/build/host/bin/mrbc"
MRUBY_BUILD_CONFIG = "./mruby.conf.rb"
MGEM_SPEC = "./conf.rb"

BUILD_DIR = "./build"
CACHE_DIR = "./.cache"
PKG_C_NAME = "_usercode"

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


desc "init develop cache dir"
task :init_cache do
  sh "rm -rf #{CACHE_DIR}; mkdir #{CACHE_DIR}"
end

desc "init build dir"
task :init_build do
  sh "rm -rf #{BUILD_DIR}; mkdir #{BUILD_DIR}"
end

desc "merge program in cache"
task :cache_merge => [:init_cache] do
  rbfiles = Dir.glob("src/lib/*.rb")
  sh "cat #{rbfiles.join(" ")} src/main.rb > #{CACHE_DIR}/main.rb"
end

desc "merge program in build"
task :build_merge => [:init_build] do
  rbfiles = Dir.glob("src/lib/*.rb")
  sh "cat #{rbfiles.join(" ")} src/main.rb > #{BUILD_DIR}/main.rb"
end

desc "run program"
task :run => [:cache_merge, :"mruby:build"] do
  sh "#{MRUBY} build/main.rb"
end

desc "build to c code"
task :build_to_c do

  CODE_ENTER = "__ruby_code"

  sh "#{MRBC} -B#{CODE_ENTER} #{BUILD_DIR}/main.rb && mv #{BUILD_DIR}/main.c #{BUILD_DIR}/#{PKG_C_NAME}.c"

  File.open("#{BUILD_DIR}/#{PKG_C_NAME}.h", "w") do |f|
template = <<-CODE
#include <stdint.h>
extern const uint8_t #{CODE_ENTER}[];
CODE

  f.puts template

  end

  File.open("#{BUILD_DIR}/#{APP_NAME}.c", "w") do |f|
template = <<-CODE
#include <mruby.h>
#include <mruby/irep.h>
#include "#{PKG_C_NAME}.h"

int
main(void)
{
  mrb_state *mrb = mrb_open();
  if (!mrb) { /* handle error */ }
  mrb_load_irep(mrb, #{CODE_ENTER});
  mrb_close(mrb);
  return 0;
}

CODE

    f.puts template

  end
end


desc "build program"
task :build => [:build_merge, :"mruby:build"] do
  sh "#{MRUBY} build/main.rb"
end
