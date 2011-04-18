ROOT = Rails.root 

def v(no)
  v = no.empty? ? 1 : no.sort.last.scan(/\d+/).join('').to_i + 1
  v = "%03d" % v
  v = v.split(//).join('.')
  return v
end

def log(fn)
  puts "=> Write #{Dir.pwd}/#{fn}"
end

def update(fn, path)
  a = Array.new
  fn = fn.split('.')
  Dir.chdir("#{ROOT}/public/#{path}")
  Dir.glob("*.#{fn.last}").each do |f| 
    a << f if f =~ /^#{fn.first}-(?:(\d+)\.)?(?:(\d+)\.)?(\*|\d+).min.#{fn.last}$/
  end
  "#{fn.first}-#{v(a)}.min.#{fn.last}"
end

namespace :ui do
  desc "Compress CSS"
  task :css do
    fn = update('style.css', 'stylesheets')
    system "cat base.css main.css print.css | yuicompressor --type=css > #{fn}"
    log(fn)
  end

  desc "Compress JS"
  task :js do
    fn = update('application.js', 'javascripts')
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

  desc "Build to deploy"
  task :build => [:css, :js, :img]
end
