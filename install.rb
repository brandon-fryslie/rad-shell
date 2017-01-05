#!/usr/bin/env ruby

require 'optparse'

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
RAD_DIR=File.expand_path(File.dirname(__FILE__))

puts "Mode: #{$options[:mode]}".cyan

if $options[:mode] == 'clean'
  # Back up current .zshrc and .zgen-setup.zsh
  if File.exist?("#{ENV['HOME']}/.zshrc")
    puts "Moving existing #{ENV['HOME']}/.zshrc to #{ENV['HOME']}/.zshrc.zgen...".yellow
    puts `mv #{ENV['HOME']}/.zshrc #{ENV['HOME']}/.zshrc.zgen`
  end
  if File.exist?("#{ENV['HOME']}/.zshrc")
    puts "Moving existing #{ENV['HOME']}/.zgen-setup.zsh to #{ENV['HOME']}/.zgen-setup.zsh.bak...".yellow
    puts `mv #{ENV['HOME']}/.zgen-setup.zsh #{ENV['HOME']}/.zgen-setup.zsh.bak`
  end

  # Restore any backup .zshrc
  if File.exist?("#{ENV['HOME']}/.zshrc.bak")
    puts "Restoring #{ENV['HOME']}/.zshrc.bak -> #{ENV['HOME']}/.zshrc"
    puts `mv #{ENV['HOME']}/.zshrc.bak #{ENV['HOME']}/.zshrc`
  end

  # Remove Zgen
  puts "Removing Zgen at #{$options[:zgen_dir]}...".yellow
  puts `rm -rf #{$options[:zgen_dir]}`

  # Remove fasd
  `which fasd`
  if $? == 0
    puts "Uninstalling fasd with 'brew uninstall fasd'...".yellow
    puts `brew uninstall fasd`
  else
    puts "Did not find 'fasd' binary, skipping fasd uninstall...".yellow
  end
end

if $options[:mode] == 'install'
  if File.exist?("#{ENV['HOME']}/.zshrc")
    puts "Backing up existing #{ENV['HOME']}/.zshrc -> #{ENV['HOME']}/.zshrc.bak"
    puts `mv #{ENV['HOME']}/.zshrc #{ENV['HOME']}/.zshrc.bak`
  end

  # Copy default .zgen-setup and .zshrc
  puts "Copying default .zshrc and .zgen-setup.zsh -> #{ENV['HOME']}"
  zgen_setup_path = "#{RAD_DIR}/.zgen-setup.zsh"
  zshrc_path = "#{RAD_DIR}/.zshrc.zgen"
  puts `cp #{zshrc_path} #{ENV['HOME']}/.zshrc`
  puts `cp #{zgen_setup_path} #{ENV['HOME']}`

  if !File.exist?("#{$options[:zgen_dir]}")
    puts "Cloning Zgen into #{$options[:zgen_dir]}...".yellow
    puts `git clone https://github.com/tarjoilija/zgen.git "#{$options[:zgen_dir]}"`
  else
    puts "#{$options[:zgen_dir]} exists, skipping clone...".yellow
  end

  `which fasd`
  if $? == 0
    puts "Found 'fasd' binary, skipping fasd installation...".yellow
  else
    puts "Doing 'brew install fasd'...".yellow
    puts `brew install fasd`
  end
end

puts "Done!".green
