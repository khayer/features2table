require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

task :build do
  system "rm features2table*.gem"
  system "gem build features2table.gemspec"
  system "gem install features2table*.gem"
end

task :release => :build do
  system "gem push features2table*.gem"
end