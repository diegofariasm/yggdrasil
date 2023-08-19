{ pkgs, config, lib, ... }:
{
  # A tame $HOME is a tame mind.
  xdg = {
    # We are not barbarians.
    enable = true;

    userDirs =
      let
        # The home directory-related options should be already taken care
        # of at this point. It is an ABSOLUTE MUST that it is set properly
        # since other parts of the home-manager config relies on it being
        # set properly.
        appendToHomeDir = path: "${config.home.homeDirectory}/${path}";
      in
      {
        enable = true;
        createDirectories = true;

        # Some peace of mind.
        # Let's just say i kinda dislike
        # uppercase letters on folders and paths.
        music = appendToHomeDir "music";
        videos = appendToHomeDir "videos";
        desktop = appendToHomeDir "desktop";
        pictures = appendToHomeDir "pictures";
        download = appendToHomeDir "downloads";
        documents = appendToHomeDir "documents";
        templates = appendToHomeDir "templates";

        # Some folders i generally make use of.
        # This might not look quite like it, but it makes my life
        # a lot easier. Keys are on my config are managed by folders.
        extraConfig = {
          XDG_WORK_DIR = appendToHomeDir "work";
          XDG_PERSONAL_DIR = appendToHomeDir "personal";
        };
      };
  };
}
