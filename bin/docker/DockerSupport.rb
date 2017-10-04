# This file is a ruby module that contains code shared by scripts that manage
# Docker

# Allows colorized printing
class String
  def colorize(color_code) "\e[#{color_code}m#{self}\e[0m" end
  def bold; colorize(1) end
  def red; colorize(31) end
  def green; colorize(32) end
  def yellow; colorize(33) end
  def cyan; colorize(36) end
end

require 'json'
require 'optparse'
def parse_opts
  options = {
    :verbose => false
  }

  parser = OptionParser.new do|opts|
  	opts.on('-v', '--verbose', 'Print stuff') do
      puts "Enabling verbose mode".red
      options[:verbose] = true
    end
  end

  begin
    opts = parser.parse(ARGV)
  rescue OptionParser::InvalidOption
    # Don't throw error on options not defined here for the case when users of
    # this module have defined their own
  end

  options
end

$options = parse_opts # global

module DockerSupport

  # Variable to store docker host information
  @docker_hosts

  # Uses `docker info` to get information about swarm hosts
  # Memoized so only gets info one time
  def DockerSupport.get_all_hosts_internal
    data = JSON.parse `docker info --format "{{json .}}"`

    hosts = if data['SystemStatus'].nil?
      # Non-swarm Host
      [ENV['DOCKER_HOST'] || ''] # use empty string for local docker
    else
      # Swarm Host
      data['SystemStatus'].reduce([]) do |memo, s|
        if s[0].match(/^\s*[\w_\-]+\.[\w_\-]+\.[\w_\-]+/)
          hostname = s[0].strip

          # Get port from IP address
          match = s[1].strip.match(/:(\d+)$/)
          port = match[1]

          memo.push "tcp://#{hostname}:#{port}"
        end
        memo
      end
    end

    if $options[:verbose]
      puts "Using hosts: #{hosts.map { |h| h.empty? ? 'local' : h }.join(', ').cyan}".yellow
    end

    hosts
  end

  # Uses `docker info` to get information about swarm hosts
  def DockerSupport.get_all_hosts
    @docker_hosts ||= DockerSupport.get_all_hosts_internal
  end

  # This function will run some code for each docker host in your defined hosts
  # Will use your DOCKER_HOST environment variable
  # Will try to figure out if you're a swarm and grep out individual swarm hosts
  def DockerSupport.all_hosts
    DockerSupport.get_all_hosts.map { |host| yield host }
  end

  # Runs the `docker images` command for one host, returns an array of hashes, each
  # hash corresponding to the data for one image
  def DockerSupport.get_docker_image_data_one_host(docker_host)
    format_string = '{{.ID}}\|{{.Repository}}\|{{.Tag}}\|{{.Size}}'

    ENV['DOCKER_HOST'] = docker_host
    `docker images --format #{format_string} | tail -n +2`.lines.map do |line|
      out = line.split('|')
      {
        :full_name => "#{out[1]}:#{out[2]}",
        :sha => out[0],
        :repo => out[1],
        :tag => out[2],
        :size => out[3].strip,
        :host => docker_host
      }
    end
  end

  # Get information about the docker images
  # Runs `docker images` on all hosts in different threads for mo fasta
  def DockerSupport.get_docker_image_data
    DockerSupport.all_hosts do |docker_host|
      Thread.new do
        get_docker_image_data_one_host(docker_host)
      end
    end.map { |thread| thread.value }.reduce({}) do |accum, host_image_data|
      host_image_data.each do |image|
        if accum.has_key?(image[:sha])
          accum[image[:sha]][:hosts].push(image[:host])
        else
          image[:full_name] = "#{image[:repo]}:#{image[:tag]}"
          accum[image[:sha]] = image
          accum[image[:sha]][:hosts] = [image[:host]]
        end
      end
      accum
    end.values
  end

  def DockerSupport.get_untagged_images
    DockerSupport.get_docker_image_data.select { |image| image[:repo] == '<none>' || image[:tag] == '<none>' }
  end

  # Get information about the docker containers on a host
  def DockerSupport.get_docker_container_data(docker_host)
    format_string = '{{.ID}}\|{{.Image}}\|{{.Command}}\|{{.CreatedAt}}\|{{.RunningFor}}\|{{.Ports}}\|{{.Status}}\|{{.Size}}\|{{.Names}}\|{{.Labels}}\|{{.Mounts}}'
    `DOCKER_HOST=#{docker_host} docker ps --no-trunc --format #{format_string}`.lines.map do |line|
      out = line.strip.split('|')
      {
        :id => out[0],
        :image => out[1],
        :command => out[2],
        :created_at => out[3],
        :running_for => out[4],
        :ports => out[5],
        :status => out[6],
        :size => out[7],
        :names => out[8],
        :labels => out[9],
        :mounts => out[10],
      }
    end
  end


  # Runs a Docker command
  def DockerSupport.command(docker_host, command)
    ENV['DOCKER_HOST'] = docker_host
    `#{command}`
  end
end
