require 'optparse'
# Folder path
project_folder = File.dirname(__FILE__)
# Local requires
require "#{project_folder}/libs/brightness"
require "#{project_folder}/libs/volume"
require "#{project_folder}/libs/signals"

OptionParser.new do |opts|
  Signals::SIGNALS.each do |signal|
    function_name = signal.gsub('-', '_')
    opts.on("--#{signal}", :none) do
      send(function_name)
    end
  end
end.parse!
