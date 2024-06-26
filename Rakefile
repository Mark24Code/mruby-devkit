MRUBY_NAME = "3.3.0"

PROJECT_DIR = "./"
COMPILER_DIR = "./mruby"
SOURCE_DIR = "./src"
SOURCE_LIB_DIR = "./src/lib"
BUILD_DIR = "./build"
CACHE_DIR = "./.cache"

MRUBY_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_NAME}.zip"
MRUBY_DIR = "#{COMPILER_DIR}/#{MRUBY_NAME}"
MRUBY_BIN = "#{MRUBY_DIR}/build/host/bin"
MRUBY = "#{MRUBY_DIR}/build/host/bin/mruby"
MRBC = "#{MRUBY_DIR}/build/host/bin/mrbc"
MRUBY_BUILD_CONFIG = "./mruby.conf.rb"
MGEM_SPEC = "./conf.rb"

PKG_C_NAME = "_usercode"
MGEM_BIN_SAVE_DIR = "#{MRUBY_DIR}/examples/mrbgems"

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
    sh "cd #{MRUBY_DIR} && rake"
  end

  desc "replace mruby build config"
  task :build_config do
    sh "cp #{MRUBY_BUILD_CONFIG} #{MRUBY_DIR}/build_config/#{APP_NAME}_config.rb"
  end

  desc "init"
  task :init => [:"mruby:download", :"mruby:build" ] do
    puts "init mruby #{MRUBY_NAME}"
  end

  desc "custom config build mruby"
  task :custom_build do
    sh "cd #{MRUBY_DIR} && rake MRUBY_CONFIG=#{APP_NAME}_config"
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



desc "package as mgem bin"
task :pkg_mgem_bin do
  gem_dir = "#{MGEM_BIN_SAVE_DIR}/mruby-bin-#{APP_NAME}"
  sh "rm -rf #{gem_dir}; mkdir -p #{gem_dir}/tools/#{APP_NAME}"
  sh "cp #{BUILD_DIR}/*.c #{BUILD_DIR}/*.h  #{gem_dir}/tools/#{APP_NAME}"
  sh "cp ./conf.rb #{gem_dir}/mrbgem.rake"
end




desc "build program"
task :build => [:build_merge, :build_to_c, :"mruby:build_config", :pkg_mgem_bin, :"mruby:custom_build"] do
  sh "mv #{MRUBY_BIN}/#{APP_NAME} #{BUILD_DIR}/"
end


desc "clean"
task :clean do
  sh "rm -rf #{COMPILER_DIR} && mkdir #{COMPILER_DIR}"
  sh "rm -rf #{BUILD_DIR} && mkdir #{BUILD_DIR}"
  sh "rm -rf #{CACHE_DIR} && mkdir #{CACHE_DIR}"
end
