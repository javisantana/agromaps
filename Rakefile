# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Agromaps::Application.load_tasks

ROOT = File.dirname(__FILE__)

def v(no)
  v = no.empty? ? 1 : no.sort.last.scan(/\d+/).join('').to_i + 1
  v = "%03d" % v
  v = v.split(//).join('.')
  return v
end

def log(fn)
  puts "=> Write #{Dir.pwd}/#{fn}"
end

def update(fn)
  a = Array.new
  fn = fn.split('.')
  Dir.chdir("#{ROOT}/public/#{fn.last}")
  Dir.glob("*.#{fn.last}").each do |f|
    a << f if f =~ /^#{fn.first}-(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+).min.#{fn.last}$/
  end
  "#{fn.first}-#{v(a)}.min.#{fn.last}"
end

desc "Compress CSS"
task :css do
  fn = update('style.css')
  system "cat base.css main.css print.css | yuicompressor --type=css > #{fn}"
  log(fn)
end

desc "Compress example CSS"
task :example do
  fn = update('flatland.css')
  system "cat base.css flatland.css print.css | yuicompressor --type=css > #{fn}"
  log(fn)
end

desc "Compress JS"
task :js do
  fn = update('app.js')
  system "cat plugins.js script.js | yuicompressor --type=js > #{fn}"
  log(fn)
end

desc "Compress images"
task :img do
  Dir.chdir(File.join(ROOT, 'public'))
  Dir['*.png'].each { |file| system "smusher #{file}" }
  Dir['images/**/*'].each { |file| system "smusher #{file}" }
end

desc "Remove generated files"
task :cleanup do
  Dir.chdir(File.join(ROOT, 'public'))
  system 'rm stylesheets/style-*.min.css'
  system 'rm javascripts/application-*.min.js'
end

desc "Setup public folder"
task :start do
  Dir.chdir(ROOT)
  system 'rm README.md'
  system 'rm public/flatland.html'
  system 'rm public/stylesheets/flatland.css'
  system 'rm public/stylesheets/flatland-0.0.1.min.css'
  system 'rm public/javascripts/application-0.0.1.min.js'
  system 'rm -f .gitignore'
  system 'rm -rf .git'
  system 'git init'
  system 'git add .'
  system 'git commit -a -m "Initial commit"'
end

desc "Prepare for Apache"
task :apache => [:start] do
  Dir.chdir(ROOT)
  system 'rm Gemfile'
  system 'rm config.ru'
  system 'git init'
  system 'git add *'
  system 'git commit -a -m "Initial commit"'
end

desc "Prepare for Heroku"
task :heroku => [:start] do
  Dir.chdir(ROOT)
  system 'rm -f public/.htaccess'
  system 'bundle'
  system 'git init'
  system 'git add .'
  system 'git commit -a -m "Initial commit"'
  system 'heroku create'
  system 'git push heroku master'
  system 'heroku open'
end

desc "Build to deploy"
task :build => [:css, :js, :img]

desc "Alias to build"
task :default => [:build]
