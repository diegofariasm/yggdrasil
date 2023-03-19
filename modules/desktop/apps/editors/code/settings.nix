{
  breadcrumbs.enabled = true;

  remote.SSH.useLocalServer = false;

  editor.accessibilitySupport = "off";
  editor.bracketPairColorization.enabled = true;
  editor.cursorBlinking = "phase";
  editor.cursorStyle = "line";
  editor.dragAndDrop = false;
  editor.fontFamily = "'Jetbrains Mono', Consolas, 'Courier New', monospace";
  editor.fontLigatures = true;
  editor.fontSize = 14;
  editor.glyphMargin = false;
  editor.lineHeight = 20;
  editor.linkedEditing = true;
  editor.minimap.enabled = false;
  editor.tabSize = 2;
  editor.formatOnSave = true;
  editor.formatOnPaste = true;

  explorer.autoReveal = true;
  explorer.confirmDragAndDrop = false;
  explorer.confirmDelete = false;
  extensions.autoUpdate = false;
  extensions.autoCheckUpdates = false;
  update.mode = "none";

  files.insertFinalNewline = true;
  files.trimTrailingWhitespace = true;

  git.autofetch = false;
  git.inputValidationSubjectLength = 72;
  git.confirmSync = false;

  html.format.enable = true;
  html.format.endWithNewline = false;

  markdown.preview.scrollEditorWithPreview = true;
  markdown.preview.scrollPreviewWithEditor = true;

  sync.askGistName = false;
  sync.autoDownload = false;
  sync.autoUpload = false;
  sync.forceDownload = false;
  sync.gist = "";
  sync.host = "";
  sync.pathPrefix = "";
  sync.quietSync = false;
  sync.removeExtensions = true;

  telemetry.enableCrashReporter = false;
  telemetry.enableTelemetry = false;

  window.title = "\${activeEditorMedium}\${separator}\${rootName}";

  workbench.editor.enablePreview = false;
  workbench.editor.highlightModifiedTabs = true;
  workbench.editor.tabCloseButton = "right";
  workbench.editor.tabSizing = "shrink";
  workbench.colorTheme = "Andromeda Bordered";
  workbench.iconTheme = "vscode-icons";
  workbench.enableExperiments = false;
  workbench.panel.defaultLocation = "bottom";
  workbench.settings.enableNaturalLanguageSearch = false;
  workbench.statusBar.feedback.visible = false;
  workbench.sideBar.location = "right";

  todo-tree.highlights.enabled = false;
  highlight.regexes = {
    "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *TODO(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" =
      {
        filterFileRegex = ".*(?<!CHANGELOG.md)$";
        decorations = [
          {
            overviewRulerColor = "#ffcc00";
            backgroundColor = "#ffcc00";
            color = "#1f1f1f";
            fontWeight = "bold";
          }
          {
            backgroundColor = "#ffcc00";
            color = "#1f1f1f";
          }
        ];
      };
    "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:FIXME|FIX|BUG|UGLY|DEBUG|HACK)(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" =
      {
        filterFileRegex = ".*(?<!CHANGELOG.md)$";
        decorations = [
          {
            overviewRulerColor = "#cc0000";
            backgroundColor = "#cc0000";
            color = "#1f1f1f";
            fontWeight = "bold";
          }
          {
            backgroundColor = "#cc0000";
            color = "#1f1f1f";
          }
        ];
      };
    "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:REVIEW|OPTIMIZE|NOTE|TSC)(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" =
      {
        filterFileRegex = ".*(?<!CHANGELOG.md)$";
        decorations = [
          {
            overviewRulerColor = "#00ccff";
            backgroundColor = "#00ccff";
            color = "#1f1f1f";
            fontWeight = "bold";
          }
          {
            backgroundColor = "#00ccff";
            color = "#1f1f1f";
          }
        ];
      };
    "((?:<!-- *)?(?:#|// @|//|./\\*+|<!--|--|\\* @|{!|{{!--|{{!) *(?:IDEA)(?:\\s*\\([^)]+\\))?:?)((?!\\w)(?: *-->| *\\*/| *!}| *--}}| *}}|(?= *(?:[^:]//|/\\*+|<!--|@|--|{!|{{!--|{{!))|(?: +[^\\n@]*?)(?= *(?:[^:]//|/\\*+|<!--|@|--(?!>)|{!|{{!--|{{!))|(?: +[^@\\n]+)?))" = {
      filterFileRegex = ".*(?<!CHANGELOG.md)$";
      decorations = [
        {
          overviewRulerColor = "#cc00cc";
          backgroundColor = "#cc00cc";
          color = "#1f1f1f";
          fontWeight = "bold";
        }
        {
          backgroundColor = "#cc00cc";
          color = "#1f1f1f";
        }
      ];
    };
  };

}
