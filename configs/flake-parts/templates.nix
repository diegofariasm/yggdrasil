{...}: {
  flake.templates = {
    shells-basic = {
      path = ../../templates/shells/basic;
      description = "A basic development shell";
    };
    shells-devenv = {
      path = ../../templates/shells/devenv;
      description = "A devenv based development shell";
    };
  };
}
