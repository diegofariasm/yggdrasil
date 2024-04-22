{config, ...}: {
  xdg = {
    enable = true;
    userDirs = let
      appendToHomeDir = path: "${config.home.homeDirectory}/${path}";
    in {
      enable = true;
      desktop = appendToHomeDir "desktop";
      documents = appendToHomeDir "documents";
      download = appendToHomeDir "downloads";
      music = appendToHomeDir "music";
      pictures = appendToHomeDir "pictures";
      publicShare = appendToHomeDir "public";
      templates = appendToHomeDir "templates";
      videos = appendToHomeDir "videos";
      extraConfig = {
        library = appendToHomeDir "library";
        projects = appendToHomeDir "projects";
      };
    };
  };
}
