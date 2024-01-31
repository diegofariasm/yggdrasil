# Cookiecutter templates for your mama.
{inputs, ...}: {
  flake.templates = {
    default = inputs.self.templates.shells;
    shells = {
      path = ../../templates/shells;
      description = "All of my development shells.";
    };
  };
}
