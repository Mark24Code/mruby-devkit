require 'pathname'
require_relative "./utils"

class BaseAgent

  include Utils

  attr_accessor :platform
  attr_reader :mruby_dir, :cache_dir, :build_dir, :mruby_build_dir
  attr_reader :mruby, :mrbc
  attr_reader :custom_build_config_file, :copied_custom_build_config_file
  def initialize(app_name:, debug: false)
    @app_name = app_name

    @proj = Pathname.new(__dir__).parent.parent # TODO 变更需要修改

    @mruby_repo_dir = @proj + "mruby"
    @source_dir = @proj +  "src"
    @source_lib_dir = @proj +  "src" + "lib"
    @build_dir = @proj +  "build"
    @cache_dir = @proj +  ".cache"
    @config_dir = @proj +  "config"
    @temp_dir = @proj +  ".tmp"

    @platform = set_platform

    @mruby_version = "3.3.0"
    @mruby_url = "https://github.com/mruby/mruby/archive/#{@mruby_version}.zip"
    @mruby_dir = @mruby_repo_dir + @mruby_version

    @mruby_build_dir = @mruby_dir + "build" +  @platform
    @mruby_bin_dir = @mruby_build_dir + "bin"
    @mruby = @mruby_bin_dir + "mruby"
    @mrbc = @mruby_bin_dir + "mrbc"
    @mruby_include_dir = @mruby_build_dir + "include"
    @mruby_lib_dir = @mruby_build_dir + "lib"
    @mruby_build_config_dir = @mruby_dir + "build_config"

    @custom_build_config_name = @platform
    @custom_build_config_file = @config_dir + "#{@platform}.rb"
    @copied_custom_build_config_name = "#{@app_name}_#{@platform}"
    @copied_custom_build_config_file = @mruby_build_config_dir + "#{@copied_custom_build_config_name}.rb"

    @code_wrapper_name = "_code_wrapper"

    @debug = debug
    init_hook
  end

  def init_hook
  end

  def set_platform
  end

  def shell(command, debug = false)
    if debug || @debug
      puts "sh: #{command}"
    end
    system(command)
  end


  def shell_rm(file_or_dir)
    shell "rm -rf #{file_or_dir}"
  end

  def shell_dir(dir_path)
    shell "mkdir -p #{dir_path}"
  end

  def shell_clean(dir_path)
    shell_rm(dir_path)
    shell_dir(dir_path)
  end

  def shell_mv(from, to)
    shell "mv #{from} #{to}"
  end

  def shell_cp(from, to)
    shell "cp #{from} #{to}"
  end

  def mruby_download
    if !File.exist?(@mruby_bin_dir.to_s)
      shell_rm @temp_dir
      shell_rm @mruby_dir
      shell_dir @temp_dir
      shell_dir @mruby_repo_dir
      mruby_file = @temp_dir + @mruby_version
      shell "wget -O #{mruby_file}.zip #{@mruby_url}"
      shell "unzip -x #{mruby_file}.zip -d #{@temp_dir} #> /dev/null 2>&1"
      shell_mv @temp_dir+"mruby-#{@mruby_version}", @mruby_dir
      shell_rm @temp_dir
    end
  end

  def mruby_build
    shell "cd #{@mruby_dir} && rake MRUBY_CONFIG=#{@copied_custom_build_config_name}"
  end

  def mruby_config
    shell_cp @custom_build_config_file, @copied_custom_build_config_file
  end

  def config_changed
    file_content_change? @custom_build_config_file, @copied_custom_build_config_file
  end


  def clean_dir(dir_path)
    shell_rm dir_path
  end

  [:mruby, :cache, :build].each do | target |
    define_method("clean_#{target}") {
      shell_clean instance_variable_get("@#{target}_dir")
    }
  end

  def clean_all
    [:mruby, :cache, :build].each do | target |
      __send__("clean_#{target}")
    end
  end

  def pack_code(dir_name)
    # TODO 根据依赖关系合并
    rbfiles = Dir.glob("#{@source_lib_dir}/*.rb")
    shell "cat #{rbfiles.join(" ")} #{@source_dir}/main.rb > #{dir_name}/main.rb"
  end

  def build_to_c_code

    shell "#{@mrbc} -B#{@code_wrapper_name} #{@build_dir}/main.rb && mv #{@build_dir}/main.c #{@build_dir}/#{@code_wrapper_name}.c"

  File.open("#{@build_dir}/main.c", "w") do |f|
template = <<-CODE
#include <mruby.h>
#include <mruby/irep.h>
extern const uint8_t #{@code_wrapper_name}[];

int
main(void)
{
  mrb_state *mrb = mrb_open();
  if (!mrb) { /* handle error */ }
  mrb_load_irep(mrb, #{@code_wrapper_name});
  mrb_close(mrb);
  return 0;
}

CODE

    f.puts template
    end
  end


  def run
    shell_clean @cache_dir
    pack_code @cache_dir
    shell "#{@mruby} #{@cache_dir}/main.rb"
  end

  def build_clean
    shell "rm -rf #{@build_dir}/*.h; rm -rf #{@build_dir}/*.rb; rm -rf #{@build_dir}/*.c"
  end

  def build_code
    shell "cc -std=c99 -I#{@mruby_include_dir} #{@build_dir}/*.c -o #{@build_dir}/#{@app_name} #{@mruby_lib_dir}/libmruby.a -lm"
  end

  def build
    shell_clean @build_dir
    pack_code(@build_dir)
    build_to_c_code
    build_code
    build_clean
  end
end
