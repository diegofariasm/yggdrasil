project_folder = File.dirname(__FILE__)
require "#{project_folder}/utils"

def current_volume
  volume = `pamixer --get-volume`

  # TODO: find way of setting a mute mode on eww bar
  volume.to_i
end

def toggle_mute
  was_muted = `pamixer --get-mute`.to_b
  if was_muted
    puts 'Now unmuted'
  else
    puts 'Now muted'
  end
  system('pamixer --toggle-mute')
end

def increase_volume(volume_increase = 5)
  system("pamixer -i #{volume_increase}")
  update_eww('volume-level', current_volume)
end

def decrease_volume(volume_decrease = 5)
  system("pamixer -d #{volume_decrease}")
  update_eww('volume-level', current_volume)
end
