MRuby::Gem::Specification.new('mruby-bin-hello') do |spec|
  spec.license = 'MIT'
  spec.author  = 'mruby developers'
  spec.summary = 'hello command'


  spec.bins = %w(hello)
  spec.add_dependency('mruby-compiler', :core => 'mruby-compiler')
end
