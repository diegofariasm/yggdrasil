(final: prev: {
  heroic = prev.heroic.overrideAttrs (oldAttrs: {
    src = builtins.fetchTarball {
      url =
        "https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/archive/main.tar.gz";
      sha256 = "sha256:0c8bx50x8zg9vsqn2d5l9qdqkqhzlss62ixnkzscjp6f80p2j4pi";
    };
  });
})
