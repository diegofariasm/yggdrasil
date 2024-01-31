{
  buildFirefoxXpiAddon,
  fetchurl,
  lib,
  stdenv,
}: {
  "sourcegraph-for-firefox" = buildFirefoxXpiAddon {
    pname = "sourcegraph-for-firefox";
    version = "23.4.14.1343";
    addonId = "sourcegraph-for-firefox@sourcegraph.com";
    url = "https://addons.mozilla.org/firefox/downloads/file/4097469/sourcegraph_for_firefox-23.4.14.1343.xpi";
    sha256 = "fa02236d75a82a7c47dabd0272b77dd9a74e8069563415a7b8b2b9d37c36d20b";
    meta = with lib; {
      description = "Adds code intelligence to GitHub, GitLab, Bitbucket Server, and Phabricator: hovers, definitions, references. Supports 20+ languages.";
      mozPermissions = [
        "activeTab"
        "storage"
        "contextMenus"
        "https://github.com/*"
        "https://sourcegraph.com/*"
        "<all_urls>"
      ];
      platforms = platforms.all;
    };
  };
}
