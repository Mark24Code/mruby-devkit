MRuby::Gem::Specification.new('mruby-bin-app') do |spec|
  spec.license = 'MIT'
  spec.author  = 'mruby developers'
  spec.summary = 'hello command'


  spec.bins = %w(app)
  spec.add_dependency('mruby-compiler', :core => 'mruby-compiler')
end
