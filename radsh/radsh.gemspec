# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'radsh/version'

Gem::Specification.new do |spec|
  spec.name          = "radsh"
  spec.license       = ""
  spec.version       = Radsh::VERSION
  spec.authors       = ["Brandon Fryslie"]
  spec.email         = ["brandon@fryslie.com"]

  spec.summary       = %q{rad-shell: a rad way to manage your shell}
  spec.description   = %q{rad-shell is a dotfile manager and also includes a rad shell configuration}
  spec.homepage      = "https://github.com/brandon-fryslie/rad-shell"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_dependency('methadone', '~> 1.9.5')
end
