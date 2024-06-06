
MRubyURL = "https://github.com/mruby/mruby/archive/3.3.0.zip"
MRubyName = "mruby-3.3.0"
Lib = "compiler/#{MRubyName}/build/host/lib"
Include = "compiler/#{MRubyName}/build/host/include"
MRuby = "compiler/#{MRubyName}/build/host/bin/mruby"
MRbc = "compiler/#{MRubyName}/build/host/bin/mrbc"

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


def download(url)
  sh "wget -O .tmp/#{MRubyName}.zip #{url}"
end

def unzip(filename)
  sh "tar -xzvf #{filename}"
end


namespace :compiler do
  desc "download mruby"
  task :download do
    sh "rm -rf .tmp && rm -rf ./compiler/#{MRubyName}"
    sh "mkdir .tmp"
    download(MRubyURL)
    sh "cd .tmp && unzip #{MRubyName}.zip"
    # filename = File.basename(MRubyName)
    sh "mv ./.tmp/#{MRubyName} ./compiler/#{MRubyName}"
    sh "rm -rf .tmp "
  end

  desc "build mruby"
  task :build do
    sh "cd compiler/#{MRubyName} && rake"
  end
end

desc "install"
task :install do
  case osname
  when "darwin"
    sh "brew install gcc@14 wget"
  when "linux"
    sh "sudo apt install gcc wget"
  else
    raise "[Error] OS not support!"
  end
end

desc "init"
task :init => [:install, :"compiler:download", :"compiler:build"  ] do
  puts "init compiler"
end


desc "run program. default use src/main.rb"
task :run, [:enter] do |t, args|
  enter = args[:enter] || 'main.rb'

  sh "#{MRuby} src/#{enter}"
end

desc "build program. default use main.rb -> main.out"
task :build, [:enter, :output] do |t, args|
  enter = args[:enter] || 'main.rb'
  enter_basename = File.basename(enter, '.*')

  output = args[:enter] ? enter_basename : 'main.out'
  if args[:output]
    output = args[:output]
  end


  sh "rm -rf build && mkdir build"
  sh "#{MRbc} -B__ruby_code src/#{enter_basename}.rb"
  sh "mv ./src/#{enter_basename}.c ./build/"
  File.open("./build/_wrapper.c", "w") do |f|
template = <<-CODE
#include <mruby.h>
#include <mruby/irep.h>
#include "#{enter_basename}.c"

int
main(void)
{
  mrb_state *mrb = mrb_open();
  if (!mrb) { /* handle error */ }
  mrb_load_irep(mrb, __ruby_code);
  mrb_close(mrb);
  return 0;
}

CODE

    f.puts template

  end

  gcc_cmd = 'gcc'
  case osname
  when "darwin"
    gcc_cmd = 'gcc-14'
  end

  sh "#{gcc_cmd} -std=c99 -I./#{Include} ./build/_wrapper.c -o ./build/#{output} ./#{Lib}/libmruby.a -lm"
  sh "rm ./build/#{enter_basename}.c && rm ./build/_wrapper.c"
end
