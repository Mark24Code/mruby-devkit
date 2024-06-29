MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gem :mgem => 'mruby-os'
  conf.gembox 'default'
end

MRuby::CrossBuild.new('wasm') do |conf|
  toolchain :clang
  conf.gembox 'default'
  conf.cc.command = 'emcc'
  conf.cc.flags = %W(-Os)
  conf.linker.command = 'emcc'
  conf.archiver.command = 'emar'
end
