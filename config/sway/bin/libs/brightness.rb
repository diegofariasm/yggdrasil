require 'English'
project_folder = File.dirname(__FILE__)
require "#{project_folder}/utils"

def current_brightness
  brightness_level = `brightnessctl get`.strip.gsub(/[^0-9]/, '')
  max_brightness = `brightnessctl max`.strip.gsub(/[^0-9]/, '')

  brightness_level = brightness_level.to_f
  max_brightness = max_brightness.to_f

  current_brightness = brightness_level / max_brightness

  (current_brightness * 100).to_i
end

def increase_brightness(device = 'intel_backlight', brightness_increase = 5)
  system("brightnessctl --quiet --device  '#{device}' set +#{brightness_increase}%")
  update_eww('brightness-level', current_brightness)
end

def decrease_brightness(device = 'intel_backlight', brightness_decrease = 5)
  if (current_brightness - brightness_decrease) < 5
    system("brightnessctl --quiet --device '#{device}' s 5%")
  else
    system("brightnessctl --quiet --device '#{device}' s #{brightness_decrease}%-")
  end

  update_eww('brightness-level', current_brightness)
end
