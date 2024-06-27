hello_NAME = 'hello'
MRuby::Gem::Specification.new('mruby-bin-hello') do |spec|
  spec.license = 'MIT'
  spec.author  = 'mruby developers'
  spec.summary = 'hello command'

  # spec.add_dependency('mruby-compiler', :core => 'mruby-compiler')
  spec.add_dependency('mruby-compiler', :core => 'mruby-compiler')
  spec.add_test_dependency('mruby-print', :core => 'mruby-print')

  exec = exefile("#{build.build_dir}/bin/hello")
  hello_objs = Dir.glob("#{spec.dir}/tools/hello/*.[c|h]").map { |f| objfile(f.pathmap("#{spec.build_dir}/tools/hello/%n")) }

  file exec => hello_objs << build.libmruby_core_static do |t|
    build.linker.run t.name, t.prerequisites
  end

  build.bins << 'hello'
end
