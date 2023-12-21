# All of the custom functions used for this configuration.
{ lib, ... }:
with builtins;
with lib;
rec {

  /*
    Signature:
    path -> attrset
    Where:
    - `path` is the starting point.
    Returns:
    An attribute set. The keys are the basename of the file or the directory
    and the values are the filepath to the Nix file.

    !!! Implementation detail is based from
    https://github.com/divnix/digga/blob/main/src/importers.nix looking at it
    multiple times for the purpose of familiarizing myself to coding in Nix
    and functional programming shtick.

    Example:
    filesToAttr ./hosts
    => { ni = ./hosts/ni/default.nix; zilch = ./hosts/zilch/default.nix }
  */
  filesToAttr = dirPath:
    let
      isModule = file: type:
        (type == "regular" && hasSuffix ".nix" file && !hasSuffix ".theme.nix" file)
        || (type == "directory");

      collect = file: type: {
        name = removeSuffix ".nix" file;
        value =
          let path = dirPath + "/${file}";
          in
          if type == "regular" then
            path
          else if type == "directory" then
            filesToAttr path
          else
            null;
      };
      files = filterAttrs isModule (builtins.readDir dirPath);
    in
    filterAttrs (name: value: value != null)
      (mapAttrs' collect files);

  /* Collect all modules (results from `filesToAttr`) into a list.

    Signature:
    attrs -> [ function ]
    Where:
    - `attrs` is the set of modules and their path.
    Returns:
    - A list of imported modules.

    Example:
    modulesToList (filesToAttr ../modules)
    => [ <lambda> <lambda> <lambda> ]
  */
  modulesToList = attrs:
    let paths = collect builtins.isPath attrs;
    in builtins.map (path: import path) paths;

  /* Count the attributes with the given predicate.

    Examples:
    countAttrs (name: value: value) { d = true; f = true; a = false; }
    => 2

    countAttrs (name: value: value.enable) { d = { enable = true; }; f = { enable = false; package = [ ]; }; }
    => 1
  */
  countAttrs = pred: attrs:
    count (attr: pred attr.name attr.value)
      (mapAttrsToList nameValuePair attrs);

  getSecrets = sopsFile: secrets:
    let
      getKey = key: { inherit key sopsFile; };
    in
    mapAttrs
      (path: attrs:
        (getKey path) // attrs)
      secrets;

  /* Prepend a prefix for the given secrets. This allows a workflow for
    separate sops file.

    Examples:
    getSecrets ./sops.yaml {
    ssh-key = { };
    "borg/ssh-key" = { };
    } //
    (getSecrets ./wireguard.yaml
    (attachSopsPathPrefix "wireguard" {
    "private-key" = {
    group = config.users.users.systemd-network.group;
    reloadUnits = [ "systemd-networkd.service" ];
    mode = "0640";
    };
    }))
  */
  attachSopsPathPrefix = prefix: secrets:
    mapAttrs'
      (key: settings:
        nameValuePair
          "${prefix}/${key}"
          ({ inherit key; } // settings))
      secrets;

  # attrsToList
  attrsToList = attrs:
    mapAttrsToList (name: value: { inherit name value; }) attrs;

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  # Generate an attribute set by mapping a function over a list of values.
  genAttrs' = values: f: listToAttrs (map f values);


}
