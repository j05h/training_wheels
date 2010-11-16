# -*- encoding: utf-8 -*-
require File.expand_path('../lib/training_wheels/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'training_wheels'
  s.version     = TrainingWheels::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Josh Kleinpeter']
  s.email       = ['josh@kleinpeter.org']
  s.homepage    = 'http://github.com/j05h/training_wheels'
  s.summary     = 'A Gosu gem to help teach kids'
  s.description = 'For now this gem helps kindergarteners learn sight words.'

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "training_wheels"

  s.add_runtime_dependency     'gosu', '~> 0.7.23'
  s.add_development_dependency 'bundler', '~> 1.0.0'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
