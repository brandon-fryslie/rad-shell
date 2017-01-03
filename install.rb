#!/usr/bin/env ruby

class String
  def colorize(color_code) "\e[#{color_code}m#{self}\e[0m" end
  def bold; colorize(1) end
  def red; colorize(31) end
  def green; colorize(32) end
  def yellow; colorize(33) end
  def cyan; colorize(36) end
end

def parse_opts
  options = {
    :mode => 'install',
    :zgen_dir => "#{ENV['HOME']}/.zgen"
  }

  OptionParser.new do |opts|
    opts.banner = "Usage: install.rb [options]"

    opts.on("--clean", "Clean") do
      options[:mode] = 'clean'
    end

    opts.on("--install", "Install (default)") do
      options[:mode] = 'install'
    end
  end.parse!

  options
end

$options = parse_opts


# TODO

# clean:
# remove ~/.zgen
# brew uninstall fasd
# remove ~/.zshrc

if $options[:mode] == 'clean'
  if File.exist?('~/.zshrc')
    puts "Moving existing ~/.zshrc to ~/.zshrc.rad...".yellow
    `mv ~/.zshrc ~/.zshrc.rad`
  end

  if File.exist?('~/.zshrc.bak')
    puts "Restoring ~/.zshrc.bak -> ~/.zshrc"
    `mv ~/.zshrc.bak ~/.zshrc`
  end

  puts "Removing Zgen at #{$options[:zgen_dir]}...".yellow
  `rm #{$options[:zgen_dir]}`

  puts "Uninstalling fasd with 'brew uninstall fasd'...".yellow
  `brew uninstall fasd`

  puts "Done!".green
end

# install:
# Switch default shell to zsh
# Install Zgen
# copy .zshrc.example
# Install fasd
if $options[:mode] == 'install'
  if File.exist?('~/.zshrc')
    puts 'Backing up existing ~/.zshrc -> ~/.zshrc.bak'
    `mv ~/.zshrc ~/.zshrc.bak`
  end

  if File.exist?('~/.zshrc.rad')
    puts 'Restoring existing ~/.zshrc.rad -> ~/.zshrc'
    `mv ~/.zshrc.rad ~/.zshrc`
  else
    puts 'Copying default .zshrc -> ~/.zshrc'
    `mv ~/.zshrc.rad ~/.zshrc`
  end

  puts "Cloning Zgen into #{$options[:zgen_dir]}...".yellow
  `git clone https://github.com/tarjoilija/zgen.git "#{$options[:zgen_dir]}"`

end
