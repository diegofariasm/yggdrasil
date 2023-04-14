{
  breadcrumbs.enabled = true;

  remote.SSH.useLocalServer = false;

  editors = {
    accessibilitySupport = "off";
    bracketPairColorization.enabled = true;
    cursorBlinking = "phase";
    cursorStyle = "line";
    dragAndDrop = false;
    fontFamily = "'Jetbrains Mono', Consolas, 'Courier New', monospace";
    fontLigatures = true;
    fontSize = 14;
    glyphMargin = false;
    lineHeight = 20;
    linkedEditing = true;
    minimap.enabled = false;
    tabSize = 2;
  };
  explorer = {
    autoReveal = true;
    confirmDragAndDrop = false;
    confirmDelete = false;
  };

  update.mode = "none";
  extensions = {
    autoUpdate = false;
    autoCheckUpdates = false;
  };

  files = {
    insertFinalNewline = true;
    trimTrailingWhitespace = true;
  };
  git = {
    autofetch = false;
    inputValidationSubjectLength = 72;
    confirmSync = false;
  };
  html.format = {
    enable = true;
    endWithNewline = false;

  };
  markdown.preview = {
    scrollEditorWithPreview = true;
    scrollPreviewWithEditor = true;
  };
  sync = {
    askGistName = false;
    autoDownload = false;
    autoUpload = false;
    forceDownload = false;
    gist = "";
    host = "";
    pathPrefix = "";
    quietSync = false;
    removeExtensions = true;
  };
  telemetry = {
    enableCrashReporter = false;
    enableTelemetry = false;
  };

  window.title = "\${activeEditorMedium}\${separator}\${rootName}";
  workbench = {
    colorTheme = "Andromeda Bordered";
    iconTheme = "vscode-icons";
    enableExperiments = false;
    panel.defaultLocation = "bottom";
    settings.enableNaturalLanguageSearch = false;
    statusBar.feedback.visible = false;
    sideBar.location = "left";

    editor = {
      enablePreview = false;
      highlightModifiedTabs = true;
      tabCloseButton = "right";
      tabSizing = "shrink";
      formatOnPaste = true;
      formatOnSave = true;
    };
  };

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
