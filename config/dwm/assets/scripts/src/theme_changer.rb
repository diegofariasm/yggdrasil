require "English"

module ThemeChanger
  def self.themes_to_rofi_option(theme_icon, themes)
    rofi_options = []

    themes.each do |theme|
      # Change all "_" to a space
      rofi_option = theme.gsub("_", " ")
      # Uppercase every first letter of word
      rofi_option = rofi_option.gsub(/\b\w/, &:upcase)
      # Put the theme icon in the beginning of all options
      rofi_option = "#{theme_icon} #{rofi_option}"
      rofi_options.push(rofi_option)
    end
    rofi_options.join("\n")
  end

  # Dynamically get all available options
  def self.get_available_wallpapers(wallpaper_dir)
    available_wallpapers = Dir.glob("#{wallpaper_dir}/*")

    return available_wallpapers
  end

  def self.get_available_themes(theme_dir)
    # TODO check for themes in all apps; luastatus, rofi and dwm
    # NOTE: This would be for makign sure that everything matches

    rofi_themes = Dir.glob("#{theme_dir}/rofi/*")
      .map { |f| File.basename(f, ".*") }

    dwm_themes = Dir.glob("#{theme_dir}/dwm/*")
      .map { |f| File.basename(f, ".*") }

    luastatus_themes = Dir.glob("#{theme_dir}/luastatus/*")
      .map { |f| File.basename(f, ".*") }

    available_themes = []

    for dwm_theme in dwm_themes
      if ((luastatus_themes.include? dwm_theme) && (rofi_themes.include? dwm_theme))
        available_themes.append(
          dwm_theme
        )
      end
    end

    return available_themes
  end

  def self.change_rofi_theme(theme_name, theme_dir)
    new_theme = "#{theme_dir}/rofi/#{theme_name}.rasi"
    active_theme = "#{theme_dir}/theme.rasi"
    # Replace the files
    system("cp -r #{new_theme} #{active_theme}")
  end

  def self.change_dwm_theme(theme_name, theme_dir, xresources_file)
    new_theme = "#{theme_dir}/dwm/#{theme_name}"
    active_theme = "#{theme_dir}/theme"

    # Replace the files
    system("cp -r #{new_theme} #{active_theme}")
    # Reload xresources
    system("xrdb -merge #{xresources_file}")
    # Call xrdb function in dwm
    system("dwmc xrdb")
  end

  def self.change_luastatus_theme(theme_name, theme_dir)
    new_theme = "#{theme_dir}/luastatus/#{theme_name}.lua"
    active_theme = "#{theme_dir}/theme.lua"
    # Replace the files
    system("cp -r #{new_theme} #{active_theme}")
    # Update luastatus
    system("kill -9 $(pidof luastatus)")
  end

  def self.change_wallpaper(theme_name, wallpapers)
    theme_wallpapers = wallpapers.select { |s| s.include?("#{theme_name}") }
    if theme_wallpapers.instance_of?(Array)
      random_wallpaper = theme_wallpapers.sample
      system("feh --bg-scale #{random_wallpaper}")
    elsif theme_wallpapers.instance_of?(String)
      system("feh --bg-fill #{theme_wallpapers}")
    end
  end

  def self.treat_rofi_output(rofi_option, theme_icon)
    rofi_option.delete!(theme_icon)
    rofi_option.strip! # Delete trailing whitespace
    rofi_option.gsub!(" ", "_") # Change space to "_"
    rofi_option.gsub!("\n", "") # Delete new line ascii

    rofi_option.downcase
  end
end
