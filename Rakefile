require 'rubygems'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

PLUGIN = "merb_global"
NAME = "merb_global"
GEM_VERSION = "0.0.4"
AUTHORS = ["Alex Coles", "Maciej Piechotka"]
EMAIL = "alex@alexcolesportfolio.com"
HOMEPAGE = "http://trac.ikonoklastik.com/merb_global/"
SUMMARY = "Localization (L10n) and Internationalization (i18n) support for the Merb MVC Framework"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = SUMMARY
  s.description = s.summary
  s.authors = AUTHORS
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.add_dependency('merb-core', '>= 0.9.1')
  s.add_dependency('treetop', '>= 1.2.3') # Tested on 1.2.3
  s.require_path = 'lib'
  s.autorequire = PLUGIN
  s.files = %w(LICENSE README Rakefile TODO HISTORY) +
            Dir.glob("{lib,specs,*_generators}/**/*")

  # rdoc
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README LICENSE TODO HISTORY)
end

windows = (PLATFORM =~ /win32|cygwin/) rescue nil

SUDO = windows ? "" : "sudo"

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install merb_global"
task :install => [:package] do
  sh %{#{SUDO} gem install pkg/#{NAME}-#{GEM_VERSION}}
end

Rake::RDocTask.new do |rd|
  rd.rdoc_dir = "doc"
  rd.rdoc_files.include "lib/**/*.rb"
end

desc "Run all specs"
Spec::Rake::SpecTask.new('specs') do |st|
  st.libs = ['lib', 'spec']
  st.spec_files = FileList['spec/**/*_spec.rb']
  st.spec_opts = ['--format specdoc', '--color']
end

desc "Run rcov"
Spec::Rake::SpecTask.new('rcov') do |rct|
  rct.libs = ['lib', 'spec']
  rct.rcov = true
  rct.rcov_opts = ['-x gems', '-x usr', '-x spec']
  rct.spec_files = FileList['spec/**/*.rb']
  rct.spec_opts = ['--format specdoc', '--color']
end
