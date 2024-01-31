{ config, ... }:
{
  xdg = {
    enable = true;
    userDirs =
      let
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
