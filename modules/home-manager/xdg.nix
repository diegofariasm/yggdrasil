{ config, ... }:
{
  # A tame $HOME is a tame mind.
  xdg = {
    # We are not barbarians.
    enable = true;

    # Hardcoding this is not really great especially if you consider using
    # other locales but its default values are already hardcoded so what
    # the hell. For other users, they would have to do set these manually.
    userDirs =
      let
        # The home directory-related options should be already taken care
        # of at this point. It is an ABSOLUTE MUST that it is set properly
        # since other parts of the home-manager config relies on it being
        # set properly.
        #
        # Here are some of the common cases for setting the home directory
        # options.
        #
        # * For exporting home-manager configurations, this is done in this
        #   flake definition.
        # * For NixOS configs, this is done automatically by the
        #   home-manager NixOS module.
        # * Otherwise, you'll have to manually set them.
        appendToHomeDir = path: "${config.home.homeDirectory}/${path}";
      in
      {
        enable = true;
        # Let's just say that i don't like capital letters
        # on my folders.
        music = appendToHomeDir "music";
        videos = appendToHomeDir "videos";
        desktop = appendToHomeDir "desktop";
        pictures = appendToHomeDir "pictures";
        publicShare = appendToHomeDir "public";
        download = appendToHomeDir "downloads";
        templates = appendToHomeDir "templates";
        documents = appendToHomeDir "documents";
      };
  };
}
