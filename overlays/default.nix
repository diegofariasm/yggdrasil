# A bunch of custom overlays. This is more suitable for larger and more
# established packages that needed extensive customization. Take note each of
# the values in the attribute set is a separate overlay function so you'll
# simply have to append them as a list (i.e., `lib.attrValues`).
{
  default = _: prev: import ../pkgs {pkgs = prev;};
  yggdrasil-kak-lsp = import ./yggdrasil-kak-lsp;
  yggdrasil-kakoune = import ./yggdrasil-kakoune;
  yggdrasil-river = import ./yggdrasil-river;
  yggdrasil-eww = import ./yggdrasil-eww;
  yggdrasil-act = import ./yggdrasil-act;
  yggdrasil-flavours = import ./yggdrasil-flavours;
}
