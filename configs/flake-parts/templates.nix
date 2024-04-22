# Cookiecutter templates for your mama.
{inputs, ...}: {
  flake.templates = {
    default = inputs.self.templates.basic-shell;
    basic-shell = {
      path = ../../templates/shells/basic;
      description = "A basic shell template";
    };
    devenv-shell = {
      path = ../../templates/shells/devenv;
      description = "A devenv shell template";
    };
  };
}
