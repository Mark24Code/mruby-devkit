require "./core/agent"

AppName = "app"
Platform = "host"

agent = Agent.new(
  app_name: AppName,
  platform: Platform,
  debug: true
)

namespace :mruby do
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

  # desc "replace mruby build config"
  # task :build_config do
  #   if file_content_change?(MRUBY_BUILD_CONFIG, "#{MRUBY_DIR}/build_config/#{APP_NAME}_config.rb")
  #     sh "cp #{MRUBY_BUILD_CONFIG} #{MRUBY_DIR}/build_config/#{APP_NAME}_config.rb"
  #   end
  # end

  # desc "init"
  # task :init => [:"mruby:download"] do
  #   puts "init mruby #{MRUBY_VERSION}"
  # end

  # desc "custom config build mruby"
  # task :custom_build do
  #   sh "cd #{MRUBY_DIR} && rake MRUBY_CONFIG=#{APP_NAME}_config"
  # end

end


# desc "init develop cache dir"
# task :init_cache do
#   sh "rm -rf #{CACHE_DIR}; mkdir #{CACHE_DIR}"
# end

# desc "init build dir"
# task :init_build do
#   sh "rm -rf #{BUILD_DIR}; mkdir #{BUILD_DIR}"
# end

# desc "merge program in cache"
# task :cache_merge => [:init_cache] do
#   rbfiles = Dir.glob("src/lib/*.rb")
#   sh "cat #{rbfiles.join(" ")} src/main.rb > #{CACHE_DIR}/main.rb"
# end

# desc "merge program in build"
# task :build_merge => [:init_build] do
#   rbfiles = Dir.glob("src/lib/*.rb")
#   sh "cat #{rbfiles.join(" ")} src/main.rb > #{BUILD_DIR}/main.rb"
# end

# desc "run program"
# task :run => [:"mruby:init", :"mruby:build_config", :"mruby:custom_build", :cache_merge] do
#   sh "#{MRUBY} #{CACHE_DIR}/main.rb"
# end

# desc "build to c code"
# task :build_to_c do

#   CODE_ENTER = "__ruby_code"

#   sh "#{MRBC} -B#{CODE_ENTER} #{BUILD_DIR}/main.rb && mv #{BUILD_DIR}/main.c #{BUILD_DIR}/#{CODE_WRAPPER_NAME}.c"

#   File.open("#{BUILD_DIR}/main.c", "w") do |f|
# template = <<-CODE
# #include <mruby.h>
# #include <mruby/irep.h>
# extern const uint8_t #{CODE_ENTER}[];

# int
# main(void)
# {
#   mrb_state *mrb = mrb_open();
#   if (!mrb) { /* handle error */ }
#   mrb_load_irep(mrb, #{CODE_ENTER});
#   mrb_close(mrb);
#   return 0;
# }

# CODE

#     f.puts template

#   end
# end


# desc "build program"
# task :build => [:"mruby:init", :"mruby:build_config", :"mruby:custom_build", :build_merge, :build_to_c] do
#   sh "cc -std=c99 -I#{MRUBY_INCLUDE_DIR} #{BUILD_DIR}/*.c -o #{BUILD_DIR}/#{APP_NAME} #{MRUBY_LIB_DIR}/libmruby.a -lm"
#   sh "mkdir -p #{BUILD_DIR}/portable/"
#   sh "cp #{MRUBY_BIN_DIR}/mruby #{BUILD_DIR}/portable/"
#   sh "mv #{BUILD_DIR}/main.rb #{BUILD_DIR}/portable/"
#   sh "rm -f #{BUILD_DIR}/*.h; rm -f #{BUILD_DIR}/*.c; rm -f #{BUILD_DIR}/*.rb"
#   sh "tar -czvf app.tar.gz #{BUILD_DIR}"
# end


# desc "clean"
# task :clean do
#   sh "rm -rf #{MRUBY_REPO_DIR} && mkdir #{MRUBY_REPO_DIR}"
#   sh "rm -rf #{BUILD_DIR} && mkdir #{BUILD_DIR}"
#   sh "rm -rf #{CACHE_DIR} && mkdir #{CACHE_DIR}"
# end
