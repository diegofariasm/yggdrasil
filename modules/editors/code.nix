{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.code;
in
{
  options.modules.editors.code = {
    enable = mkBoolOpt false;
  };
  config = mkIf cfg.enable {

    home.programs.vscode =
      {
        enable = true;
        package = pkgs.vscode;
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide # Duh
          pkief.material-icon-theme # Icons for the folders

        ];
        userSettings = {
          "emmet.syntaxProfiles" = {
            "javascript" = "jsx";
          };
          "workbench.startupEditor" = "newUntitledFile";
          "javascript.suggest.autoImports" = true;
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "editor.rulers" = [
            80
            120
          ];
          "extensions.ignoreRecommendations" = true;
          "typescript.tsserver.log" = "off";
          "files.associations" = {
            ".sequelizerc" = "javascript";
            ".stylelintrc" = "json";
            "*.tsx" = "typescriptreact";
            ".env.*" = "dotenv";
            ".prettierrc" = "json";
          };
          "screencastMode.onlyKeyboardShortcuts" = true;
          "cSpell.userWords" = [
            "chakra"
            "IUGU"
            "middlewares"
            "mixpanel"
            "Onboarded"
            "prefetch"
            "rocketseat"
            "upsert"
          ];
          "editor.parameterHints.enabled" = false;
          "editor.renderLineHighlight" = "gutter";
          "cSpell.language" = "en;pt";
          "material-icon-theme.languages.associations" = {
            "dotenv" = "tune";
          };

          "typescript.updateImportsOnFileMove.enabled" = "never";
          "workbench.colorTheme" = "Omni";
          "material-icon-theme.files.associations" = {
            "tsconfig.json" = "tune";
            "*.webpack.js" = "webpack";
            "*.proto" = "3d";
            "ormconfig.json" = "database";
          };
          "material-icon-theme.activeIconPack" = "nest";
          "editor.suggestSelection" = "first";
          "explorer.confirmDelete" = false;
          "gitlens.codeLens.recentChange.enabled" = false;
          "terminal.integrated.showExitAlert" = false;

          "[prisma]" = {
            "editor.formatOnSave" = true;
          };

          "typescript.suggest.autoImports" = true;
          "terminal.integrated.env.osx" = {
            "FIG_NEW_SESSION" = "1";
          };
          "workbench.editor.labelFormat" = "short";
          "editor.fontLigatures" = true;
          "emmet.includeLanguages" = {
            "javascript" = "javascriptreact";
          };
          "liveshare.featureSet" = "insiders";
          "material-icon-theme.folders.associations" = {
            "adapters" = "contract";
            "grpc" = "pipe";
            "kube" = "kubernetes";
            "main" = "lib";
            "websockets" = "pipe";
            "implementations" = "core";
            "protos" = "pipe";
            "entities" = "class";
            "kafka" = "pipe";
            "use-cases" = "functions";
            "migrations" = "tools";
            "schemas" = "class";
            "useCases" = "functions";
            "eslint-config" = "tools";
            "typeorm" = "database";
            "_shared" = "shared";
            "mappers" = "meta";
            "fakes" = "mock";
            "modules" = "components";
            "subscribers" = "messages";
            "domain" = "class";
            "protocols" = "contract";
            "infra" = "app";
            "view-models" = "views";
            "presentation" = "template";
            "dtos" = "typescript";
            "http" = "container";
            "providers" = "include";
            "factories" = "class";
            "repositories" = "mappings";
          };
          "cSpell.enableFiletypes" = [
            "!asciidoc"
            "!c"
            "!cpp"
            "!csharp"
            "!go"
            "!handlebars"
            "!haskell"
            "!jade"
            "!java"
            "!latex"
            "!php"
            "!pug"
            "!python"
            "!restructuredtext"
            "!rust"
            "!scala"
            "!scss"
          ];
          "editor.acceptSuggestionOnCommitCharacter" = false;
          "explorer.compactFolders" = false;
          "git.enableSmartCommit" = true;
          "editor.accessibilitySupport" = "off";
          "explorer.confirmDragAndDrop" = false;
          "terminal.integrated.fontSize" = 14;
          "editor.codeActionsOnSave" = {
            "source.fixAll.eslint" = true;
          };
          "editor.semanticHighlighting.enabled" = false;
          "breadcrumbs.enabled" = true;
          "gitlens.codeLens.authors.enabled" = false;
          "editor.tabSize" = 2;
          "security.workspace.trust.untrustedFiles" = "newWindow";
          "files.exclude" = {
            "**\/CVS" = true;
            "**\/.DS_Store" = true;
            "**\/.hg" = true;
            "**\/.svn" = true;
            "**\/.git" = true;
          };
          "explorer.autoReveal" = true;

          "files.trimTrailingWhitespace" = true;
          "files.insertFinalNewline" = true;

          "debug.toolBarLocation" = "docked";


          "workbench.productIconTheme" = "fluent-icons";
          "workbench.iconTheme" = "material-icon-theme";

          "editor.formatOnPaste" = true;
          "editor.formatOnSave" = true;
          "editor.fontFamily" = "JetBrains Mono";
          "editor.lineHeight" = 20;
          "editor.fontSize" = 14;
          "editor.mouseWheelZoom" = true;
          "editor.cursorBlinking" = "smooth";
          "editor.cursorSmoothCaretAnimation" = true;


        };
      };
    fonts.fonts = with pkgs; [
      jetbrains-mono
    ];
    home.packages = with pkgs; [
      nixpkgs-fmt
    ];
  };
}
