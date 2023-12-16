{ config, ... }:
{
  xdg = {
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
        desktop = appendToHomeDir "desktop";
        documents = appendToHomeDir "documents";
        download = appendToHomeDir "downloads";
        music = appendToHomeDir "music";
        pictures = appendToHomeDir "pictures";
        publicShare = appendToHomeDir "public";
        templates = appendToHomeDir "templates";
        videos = appendToHomeDir "videos";
      };
  };
}
