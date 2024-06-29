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
    build_code
    build_clean
  end

  def web_template
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

  def build_code
    shell "emcc -s WASM=1 -Os -I #{@mruby_include_dir} #{@build_dir}/*.c #{@mruby_lib_dir}/libmruby.a -lm -o #{@build_dir}/#{@app_name}.js --closure 1"
  end
end
