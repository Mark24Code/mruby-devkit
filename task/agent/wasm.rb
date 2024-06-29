require_relative "./base"

class WasmAgent < BaseAgent
  def build_code
    shell "emcc -s WASM=1 -Os -I #{@mruby_include_dir} #{@build_dir}/*.c #{@mruby_lib_dir}/libmruby.a -lm -o #{@build_dir}/#{@app_name}.js --closure 1"
  end
end
