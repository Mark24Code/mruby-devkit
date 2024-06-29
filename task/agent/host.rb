require_relative "./base"

class HostAgent < BaseAgent
  def build_code
    shell "cc -std=c99 -I#{@mruby_include_dir} #{@build_dir}/*.c -o #{@build_dir}/#{@app_name} #{@mruby_lib_dir}/libmruby.a -lm"
  end
end
