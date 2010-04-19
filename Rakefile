require 'rake'
require 'rake/gempackagetask'

PKG_FILES = FileList[
  '[a-zA-Z-]*', 
  'generators/**/*', 
  'lib/**/*'
]

spec = Gem::Specification.new do |s|
  s.name = "taobao_fu" 
  s.version = "1.0.0.beta4" 
  s.author = "why404" 
  s.email = "why404@gmail.com" 
  s.homepage = "http://rubygems.org/gems/taobao_fu" 
  s.platform = Gem::Platform::RUBY 
  s.summary = "Ruby SDK for the Taobao Open Platform" 
  s.description = "TaobaoFu is a Ruby gem (also can be a Rails plugin, supports Rails 3.0.0 or above) as an unofficial Ruby SDK for the Taobao Open Platform(http://open.taobao.com/)."
  s.files = PKG_FILES.to_a 
  s.require_path = "lib" 
  s.has_rdoc = false 
  s.extra_rdoc_files = ["README.markdown"] 
  s.add_dependency("crack", ">= 0.1.7")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end
