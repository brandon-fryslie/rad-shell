#!/usr/bin/env ruby

require File.expand_path('../DockerSupport', __FILE__)

require 'optparse'
options = {
  :ignore_images => [],
  :test => false,
  :threshold_length => 12,
  :threshold_units => 'hour',
}

parser = OptionParser.new do |opts|
  opts.on('--ignore IMAGE_NAMES', 'Comma separated list of image names to ignore') do |image_str|
    images = image_str.strip.split(',')
    puts "Ignoring images with names: #{images}".yellow
    options[:ignore_images] = images
  end

  opts.on('--test', 'Print containers to kill, but do not kill them') do
    puts "TEST MODE".red
    options[:test] = true
  end

  opts.on('--threshold-length LENGTH', 'Length of threshold defining a long-running container (default: 12)') do |n|
    options[:threshold_length] = n.to_i
  end

  opts.on('--threshold-units UNITS', 'Units of threshold length (default: hours)') do |units|
    options[:threshold_units] = units.sub(/s?$/)
  end
end

parser.parse!

TIME_UNITS = ['second', 'minute', 'hour', 'day', 'week', 'month', 'year']

$TEST_MODE = options[:test]
$THRESHOLD_LENGTH = options[:threshold_length]
$THRESHOLD_UNIT_INDEX = TIME_UNITS.find_index(options[:threshold_units])

unless $THRESHOLD_UNIT_INDEX
  puts "#{options[:threshold_units]} is not a valid threshold unit".red
  puts "valid units: #{TIME_UNITS}".red
  abort
end

# This script cleans up images that have been running longer than a specified
# time limit

def parse_uptime(container)
  # need to handle 'about an' bs
  if container[:running_for] =~ /^About /
    uptime_length = 1
    uptime_units = container[:running_for].gsub(/^.* (\w+)$/, '\1')
  else
    uptime_length = container[:running_for].split(' ')[0].to_i
    uptime_units = container[:running_for].split(' ')[1].gsub(/s?$/, '')
  end

  {
    units: uptime_units,
    length: uptime_length,
  }
end

def is_long_running(container)
  uptime = parse_uptime(container)
  $THRESHOLD_UNIT_INDEX < TIME_UNITS.find_index(uptime[:units]) ||
    ($THRESHOLD_UNIT_INDEX == TIME_UNITS.find_index(uptime[:units]) && $THRESHOLD_LENGTH <= uptime[:length])
end

def container_status_str(c)
  "#{'image:'.yellow} '#{c[:image].cyan}' #{'name:'.yellow} '#{c[:names].cyan}' #{'status:'.yellow} '#{c[:status].cyan}'"
end

def kill_long_running_containers(docker_host, ignore_images)
  puts "Finding long-running containers on DOCKER_HOST=#{docker_host}...".yellow
  containers = DockerSupport.get_docker_container_data(docker_host)
  to_kill_containers = containers.select { |container| !ignore_images.include?(container[:image]) }
  to_ignore_containers = containers.select { |container| ignore_images.include?(container[:image]) }

  puts "Found #{containers.length} container(s)".yellow
  puts "Ignoring #{to_ignore_containers.length} container(s):".yellow
  puts to_ignore_containers.map { |c| "\t#{container_status_str(c)}" }.join("\n")

  if to_kill_containers.length == 0
    puts "Did not find any non-ignored containers".green
  else
    long_running_containers = to_kill_containers.select { |c| is_long_running(c) }
    non_long_running_containers = to_kill_containers.select { |c| !is_long_running(c) }

    puts "Found #{non_long_running_containers.length} non-long-running container(s):".yellow
    puts non_long_running_containers.map { |c| "\t#{container_status_str(c)}" }.join("\n")

    puts "Found #{long_running_containers.length} long-running container(s)".green
    puts long_running_containers.map { |c| "\t#{container_status_str(c)}" }.join("\n")

    long_running_containers.map do |container|
      uptime = parse_uptime(container)
      puts "Container #{container[:names]} up for #{uptime[:length]} #{uptime[:units]}(s)".yellow.bold
      puts "Killing container...".yellow
      if !$TEST_MODE
        `docker rm -fv #{container[:id]}`
      else
        puts "Skipping kill of container #{container[:id]} because we're in TEST_MODE".yellow.bold
      end
    end
  end
end

docker_host = ENV['DOCKER_HOST']

kill_long_running_containers(docker_host, options[:ignore_images])

puts "Done!".green
