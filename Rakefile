MRUBY_NAME = "3.3.0"
MRUBY_URL = "https://github.com/mruby/mruby/archive/#{MRUBY_NAME}.zip"

MRUBY_DIR = "./mruby"
MRUBY = "#{MRUBY_DIR}/#{MRUBY_NAME}/build/host/bin/mruby"
MRBC = "#{MRUBY_DIR}/#{MRUBY_NAME}/build/host/bin/mrbc"

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
    sh "rm -rf .tmp ; rm -rf #{MRUBY_DIR}/#{MRUBY_NAME}"
    sh "mkdir .tmp; mkdir -p #{MRUBY_DIR}"
    sh "wget -O .tmp/#{MRUBY_NAME}.zip #{MRUBY_URL}"
    sh "unzip -x ./.tmp/#{MRUBY_NAME}.zip -d ./.tmp"
    sh "mv ./.tmp/mruby-#{MRUBY_NAME} #{MRUBY_DIR}/#{MRUBY_NAME}"
    sh "rm -rf .tmp "
  end

  desc "build mruby"
  task :build do
    sh "cd #{MRUBY_DIR}/#{MRUBY_NAME} && rake"
  end

  desc "init"
  task :init => [:"mruby:download", :"mruby:build"  ] do
    puts "init mruby #{MRUBY_NAME}"
  end

end
