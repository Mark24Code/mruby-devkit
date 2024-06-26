APP_NAME = 'app'
MRuby::Gem::Specification.new('mruby-bin-app') do |spec|
  spec.license = 'MIT'
  spec.author  = 'mruby developers'
  spec.summary = 'hello command'

  spec.add_dependency('mruby-compiler', :core => 'mruby-compiler')

  exec = exefile("#{build.build_dir}/bin/app")
  app_objs = Dir.glob("#{spec.dir}/tools/app/*.[c|h]").map { |f| objfile(f.pathmap("#{spec.build_dir}/tools/app/%n")) }

  file exec => app_objs << build.libmruby_core_static do |t|
    build.linker.run t.name, t.prerequisites
  end

  build.bins << 'app'
end
