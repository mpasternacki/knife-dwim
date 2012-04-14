# -*- mode: ruby; encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-dwim/version"

Gem::Specification.new do |s|
  s.name        = "knife-dwim"
  s.version     = KnifeDwim::VERSION
  s.authors     = ["Maciej Pasternacki"]
  s.email       = ["maciej@pasternacki.net"]
  s.homepage    = "https://github.com/mpasternacki/knife-dwim"
  s.summary     = %q{Upload file to Chef server correctly}
  s.description = %q{Run a correct knife command to upload file to Chef server}

  s.rubyforge_project = "knife-dwim"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "chef"
end
