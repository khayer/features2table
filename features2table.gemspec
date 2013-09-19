Gem::Specification.new do |s|
  s.name        = 'features2table'
  s.version     = '0.0.1'
  s.date        = '2013-09-19'
  s.summary     = "Features2table"
  s.description = "..."
  s.authors     = ["Katharina Hayer"]
  s.email       = 'katharinaehayer@gmail.com'
  s.files       = Dir.glob("lib/**/*")
  s.homepage    =
    'https://github.com/khayer/features2table'
  s.executables = Dir.glob("bin/**/*").map{|f| File.basename(f)}
end
