#!/usr/bin/env ruby

require 'set'

class String
  def colorize(color_code) "\e[#{color_code}m#{self}\e[0m" end
  def bold; colorize(1) end
  def red; colorize(31) end
  def green; colorize(32) end
  def yellow; colorize(33) end
  def cyan; colorize(36) end
end

PROJECT_PATH = "#{ENV['HOME']}/projects"

DOCKER_GLOBS = [
  "#{PROJECT_PATH}/*/ci/**/plugins.txt",
  "#{PROJECT_PATH}/*/master/**/plugins.txt",
]

def find_repos_with_plugins_txt
  DOCKER_GLOBS.map do |plugin_pattern|
    Dir[plugin_pattern].map do |filename|
      filename.gsub(/^#{PROJECT_PATH}\/([^\/]+).*$/, '\1')
    end
  end.flatten.sort.uniq
end

# Do some basic option parsing

if ARGV.find { |arg| arg == '--help' || arg == '-h' }
  puts "Usage: jenkins-dedupe-plugins.rb [repos] [--rewrite]".yellow
  puts "The --rewrite flag will tell the script to automatically rewrite the plugins.txt in the repo"
  exit 0
end

$options = {}
possible_repos = ARGV.select { |arg| !arg.match(/^--/) }
$options[:repos] = if possible_repos.length > 0
   possible_repos
else
  find_repos_with_plugins_txt
end

$options[:rewrite] = ARGV.find { |arg| arg == '--rewrite' }
if $options[:rewrite]
  puts "Enabling rewrite mode!".bold.green
end

def find_plugin_files(repo)
  Dir["#{PROJECT_PATH}/#{repo}/**/plugins.txt"]
end

def parse_plugin_file(filename)
  plugins = IO.read(filename).each_line
  .select { |line| !line.match(/^\s+$/) && !line.match(/^#/) }
  .map { |line| line.strip }
end

def get_base_plugins
  base_plugin_file = find_plugin_files('docker-jenkins')[0]
  parse_plugin_file base_plugin_file
end

def dedupe_plugins(base_plugin_info, repo, plugin_file)
  plugin_info = parse_plugin_file plugin_file

  # Checkout master branch
  repo_path = "#{PROJECT_PATH}/#{repo}"

  duplicate_plugins = base_plugin_info.to_set.intersection(plugin_info).to_a
  if duplicate_plugins.length > 0
    puts "Base and #{repo} have these duplicate plugins:".yellow
    puts duplicate_plugins.map { |p| p.cyan }
  else
    puts "No duplicate plugins found in #{plugin_file}!".green
  end
  plugin_info.to_set.difference(base_plugin_info)
end

def dedupe_plugins_for_repo(base_plugin_info, repo)
  puts "Deduping plugins for repo #{repo}".yellow

  repo_path = "#{PROJECT_PATH}/#{repo}"
  git_cmd = "git -C #{repo_path}"
  puts "Stashing changes and switching to master in dir #{repo_path}...".yellow
  `#{git_cmd} stash && #{git_cmd} checkout master`

  plugin_files = find_plugin_files(repo)
  if plugin_files.length == 0
    puts "Error!  Didn't find any plugins.txt files in repo #{repo}"
    abort
  end

  plugin_files.each do |filename|
    if filename =~ /on-prem/
      next
    end
    unique_plugins = dedupe_plugins(base_plugin_info, repo, filename)
    if $options[:rewrite]
      write_plugins_file(repo_path, filename, unique_plugins)
    end
  end
end

def write_plugins_file(repo_path, filename, plugins)
  branch_name = 'dedupe_plugins'
  git_cmd = "git -C #{repo_path}"

  puts "Deleting and recreating git branch '#{branch_name}'...".yellow
  `#{git_cmd} branch -D #{branch_name} 2>/dev/null; #{git_cmd} checkout -b #{branch_name}`

  puts "Writing new plugin file: #{filename}...".yellow
  IO.write(filename, "#{plugins.to_a.join("\n")}\n")

  puts "Making a commit...".yellow
  msg = 'Remove plugins that are duplicated from base jenkins image'
  `#{git_cmd} add "*plugins.txt" && #{git_cmd} commit -am "#{msg}"`

  puts "Pushing commit...".yellow
  `#{git_cmd} push -uf origin #{branch_name}`

  puts "Switching back to master and deleting local branch...".yellow
  `#{git_cmd} checkout master && #{git_cmd} branch -D #{branch_name}`
end

base_plugins = get_base_plugins

puts "Deduping plugins in repos: #{$options[:repos].join(' ')}".bold.yellow

$options[:repos].map do |repo|
  dedupe_plugins_for_repo(base_plugins, repo)
end

puts "Done!".green
