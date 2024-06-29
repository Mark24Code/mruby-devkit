require 'digest/md5'

MRUBY_VERSION = "3.3.0"

PROJECT_DIR = "./"
MRUBY_REPO_DIR = "./mruby"
SOURCE_DIR = "./src"
SOURCE_LIB_DIR = "./src/lib"
BUILD_DIR = "./build"
CACHE_DIR = "./.cache"
DOCKER_DIR = "./docker"

MRUBY_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.zip"
MRUBY_DIR = "#{MRUBY_REPO_DIR}/#{MRUBY_VERSION}"
MRUBY_BIN_DIR = "#{MRUBY_DIR}/build/host/bin"
MRUBY = "#{MRUBY_DIR}/build/host/bin/mruby"
MRBC = "#{MRUBY_DIR}/build/host/bin/mrbc"
MRUBY_LIB_DIR = "#{MRUBY_DIR}/build/host/lib"
MRUBY_INCLUDE_DIR = "#{MRUBY_DIR}/build/host/include"

MRUBY_BUILD_CONFIG = "./mruby.conf.rb"

CODE_WRAPPER_NAME = "code_wrapper"

APP_NAME = "app"


def file_md5(file_path)
  File.open(file_path, 'rb') do |file|
    md5 = Digest::MD5.new
    md5 << file.read
    md5.hexdigest
  end
end

def file_content_change?(file1, file2)
  if !File.exist?(file1) || !File.exist?(file2)
    return true
  end

  hash1 = file_md5(file1)
  hash2 = file_md5(file2)

  return !(hash1 == hash2)
end

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
    if !File.exist?("#{MRUBY_BIN_DIR}")
      sh "rm -rf .tmp ; rm -rf #{MRUBY_DIR}"
      sh "mkdir .tmp; mkdir -p #{MRUBY_REPO_DIR}"
      sh "wget -O .tmp/#{MRUBY_VERSION}.zip #{MRUBY_URL}"
      sh "unzip -x ./.tmp/#{MRUBY_VERSION}.zip -d ./.tmp"
      sh "mv ./.tmp/mruby-#{MRUBY_VERSION} #{MRUBY_DIR}"
      sh "rm -rf .tmp "
    end
  end

  desc "build mruby"
  task :build do
    if !File.exist?("#{MRUBY_BIN_DIR}/mruby")
      sh "cd #{MRUBY_DIR} && rake"
    end
  end

  desc "replace mruby build config"
  task :build_config do
    if file_content_change?(MRUBY_BUILD_CONFIG, "#{MRUBY_DIR}/build_config/#{APP_NAME}_config.rb")
      sh "cp #{MRUBY_BUILD_CONFIG} #{MRUBY_DIR}/build_config/#{APP_NAME}_config.rb"
    end
  end

  desc "init"
  task :init => [:"mruby:download"] do
    puts "init mruby #{MRUBY_VERSION}"
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
task :run => [:"mruby:init", :"mruby:build_config", :"mruby:custom_build", :cache_merge] do
  sh "#{MRUBY} #{CACHE_DIR}/main.rb"
end

desc "build to c code"
task :build_to_c do

  CODE_ENTER = "__ruby_code"

  sh "#{MRBC} -B#{CODE_ENTER} #{BUILD_DIR}/main.rb && mv #{BUILD_DIR}/main.c #{BUILD_DIR}/#{CODE_WRAPPER_NAME}.c"

  File.open("#{BUILD_DIR}/main.c", "w") do |f|
template = <<-CODE
#include <mruby.h>
#include <mruby/irep.h>
extern const uint8_t #{CODE_ENTER}[];

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
task :build => [:"mruby:init", :"mruby:build_config", :"mruby:custom_build", :build_merge, :build_to_c] do
  sh "cc -std=c99 -I#{MRUBY_INCLUDE_DIR} #{BUILD_DIR}/*.c -o #{BUILD_DIR}/#{APP_NAME} #{MRUBY_LIB_DIR}/libmruby.a -lm"
  sh "mkdir -p #{BUILD_DIR}/portable/"
  sh "cp #{MRUBY_BIN_DIR}/mruby #{BUILD_DIR}/portable/"
  sh "mv #{BUILD_DIR}/main.rb #{BUILD_DIR}/portable/"
  sh "rm -f #{BUILD_DIR}/*.h; rm -f #{BUILD_DIR}/*.c; rm -f #{BUILD_DIR}/*.rb"
  sh "tar -czvf app.tar.gz #{BUILD_DIR}"
end


desc "clean"
task :clean do
  sh "rm -rf #{MRUBY_REPO_DIR} && mkdir #{MRUBY_REPO_DIR}"
  sh "rm -rf #{BUILD_DIR} && mkdir #{BUILD_DIR}"
  sh "rm -rf #{CACHE_DIR} && mkdir #{CACHE_DIR}"
end
