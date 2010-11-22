require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the muruca_widgets plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the muruca_widgets plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'MurucaWidgets'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb', 'generators/**/templates/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "muruca_widgets"
    s.summary = "Additional interface elements for Muruca Sites."
    s.email = "ghub@limitedcreativity.org"
    s.homepage = "http://net7.github.com/muruca_widgets"
    s.description = "Some additional interface elements to be used on Muruca sites."
    s.authors = ["Daniel Hahn"]
    s.files = FileList["{lib}/**/*", "{generators}/**/*"]
    s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
    s.add_dependency('json', '>= 1.1.0')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dendency) is not available. Install with: gem install jeweler"
end

begin
  require 'gokdok'
  Gokdok::Dokker.new do |gd|
    gd.remote_path = '' # Put into the root directory
    gd.doc_home = 'rdoc'
  end
rescue LoadError
  puts "Gokdok is not available. Install with: gem install gokdok"
end
