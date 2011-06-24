# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "zabbixapi/version"

Gem::Specification.new do |s|
  s.name        = "zabbixapi"
  s.version     = Zabbix::VERSION
  s.authors     = ['Eduard Snesarev',"Edmund Haselwanter"]
  s.email       = ['verm666@gmail.com',"edmund@haselwanter.com"]
  s.homepage    = "https://github.com/iteh/zabbixapi"
  s.license     = 'Apache'
  s.has_rdoc = true
  s.extra_rdoc_files  = 'README.rdoc'

  s.summary     = %q{Ruby module for work with zabbix api.}
  s.description = %q{Ruby module for work with zabbix api.}

  s.rubyforge_project = "zabbixapi"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

#  s.add_dependency 'nokogiri', '~> 1.4.4'
#  s.add_dependency 'zabbix', '~> 0.3.0'
#  s.add_dependency 'httparty', '~> 0.7.8'
#  s.add_dependency 'activesupport', '~> 3.0.8'
#  s.add_dependency "i18n", "~> 0.6.0"
  s.add_dependency 'yajl-ruby', '~> 0.8.2'
  s.add_dependency "awesome_print", "~> 0.4.0"
#  s.add_dependency "mixlib-cli", "~> 1.2.0"

  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'fakeweb', '~> 1.3.0'

end