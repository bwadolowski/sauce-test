Gem::Specification.new do |s|

  s.name = 'sauce-test'
  s.version = '0.1'
  s.platform = Gem::Platform::RUBY
  s.summary = <<-DESC.strip.gsub(/\n\s+/, " ")
    Run your Selenium tests on Sauce Labs cloud
  DESC

  s.files = Dir.glob("{bin,lib,examples}/**/*") + %w(README.rdoc TODO.rdoc)
  s.require_path = 'lib'
  s.has_rdoc = true

  s.bindir = "bin"
  s.executables << "sauce_test"

  s.add_dependency 'rspec'
  s.add_dependency 'selenium-client'

  s.author = "Bart Wadolowski"
  s.email = "bart@saucelabs.com"
  s.homepage = "http://www.saucelabs.com"
  s.rubyforge_project = "sauce-test"

end
