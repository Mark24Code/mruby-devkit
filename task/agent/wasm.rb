require_relative "./base"
require_relative "./host"
require_relative "../../config"

class WasmAgent < BaseAgent

  def init_hook
    @host_agent = HostAgent.new(
      app_name: Devkit::AppName,
      debug: Devkit::Debug
    )
  end
  def set_platform
    @platform = "wasm"
  end

  def build
    shell_clean @build_dir
    @host_agent.pack_code(@build_dir)
    @host_agent.build_to_c_code
    build_code @build_dir
    build_clean
  end

  def generate_web_template(dir_path)
    File.open("#{dir_path}/index.html", "w") do |f|
    template = <<-CODE
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
</head>
<body>
    <h1>Hello World</h1>
    <script src="./app.js"></script>
</body>
</html>
    CODE

    f.puts template
    end
  end

  def serve(dir_path)
    system("ruby -run -e httpd #{dir_path}")
  end

  def run
    build
    serve @build_dir
  end

  def build_code(dir_path)
    shell "emcc -s WASM=1 -Os -I #{@mruby_include_dir} #{dir_path}/*.c #{@mruby_lib_dir}/libmruby.a -lm -o #{dir_path}/#{@app_name}.js --closure 1"
    generate_web_template(dir_path)
  end
end
