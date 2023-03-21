require 'English'

project_folder = File.dirname(__FILE__)

require "#{project_folder}/volume"
require "#{project_folder}/brightness"

class String
  def to_b
    return true if self =~ /^(true|t|yes|y|1)$/i
    return false if self =~ /^(false|f|no|n|0)$/i

    raise ArgumentError, "invalid value for Boolean: '#{self}'"
  end
end

def update_eww(variable, value)
  system("eww update #{variable}=#{value}")
end

def update_modules
  update_eww('volume-level', current_volume)
  update_eww('brightness-level', current_brightness)
end
