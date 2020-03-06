# -*- encoding: utf-8 -*-
# stub: paperclip-cloudinary 1.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "paperclip-cloudinary".freeze
  s.version = "1.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Carl Scott".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-02-11"
  s.description = "Store Paperclip-managed assets with Cloudinary. Requires a free Cloudinary account to get started.".freeze
  s.email = ["carl.scott@solertium.com".freeze]
  s.homepage = "http://github.com/GoGoCarl/paperclip-cloudinary".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Store Paperclip-managed assets with Cloudinary.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cloudinary>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    else
      s.add_dependency(%q<cloudinary>.freeze, ["~> 1.1"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<cloudinary>.freeze, ["~> 1.1"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.11"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
