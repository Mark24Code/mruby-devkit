require 'pathname'

module Utils
  def content_md5(file_path)
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
    hash1 = content_md5(file1)
    hash2 = content_md5(file2)
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

  def dep_tools
    ["curl, unzip"]
  end
end

class Agent
  include Utils

  def initialize(app_name:, platform: "host", debug: false)
    @app_name = app_name

    @proj = Pathname.new(__dir__).parent

    @mruby_repo_dir = @proj + "mruby"
    @source_dir = @proj +  "src"
    @source_lib_dir = @proj +  "src" + "lib"
    @build_dir = @proj +  "build"
    @cache_dir = @proj +  ".cache"
    @config_dir = @proj +  "config"
    @temp_dir = @proj +  ".tmp"
    @platform = platform

    @mruby_version = "3.3.0"
    @mruby_url = "https://github.com/mruby/mruby/archive/#{@mruby_version}.zip"
    @mruby_dir = @mruby_repo_dir + @mruby_version

    @mruby_build_dir = @mruby_dir + "build"
    @mruby_bin_dir = @mruby_build_dir + @platform + "bin"
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

  end

  def shell(command, log = false)
    if log || @debug
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
      shell "curl -L -C - -o #{mruby_file}.zip #{@mruby_url}"
      shell "unzip -x #{mruby_file}.zip -d #{@temp_dir} > /dev/null 2>&1"
      shell_mv @temp_dir+"mruby-#{@mruby_version}", @mruby_dir
      shell_rm @temp_dir
    end
  end

  def mruby_build
    shell "cd #{@mruby_dir} && rake MRUBY_CONFIG=#{@copied_custom_build_config_name}"
  end

  def copy_config
    shell_cp @custom_build_config_file, @copied_custom_build_config_file
  end

  def clean_dir(dir_path)
    shell_rm dir_path
  end

  [:mruby, :cache, :build].each do | target |
    define_method("clean_#{target}") {
      clean_dir instance_variable_get("#{target}_dir")
    }
  end

  def clean_all
    clean_dir @mruby_dir
    clean_dir @cache_dir
    clean_dir @build_dir
  end
end

fl = Agent.new(app_name: "app", platform: "host", debug: false)
# fl.mruby_download
puts fl.methods - Object.methods
