{
  pkgs,
  self,
  secrets,
  ...
}:
let
  font = {
    name = "JetBrains Mono";
    size = 15;
  };
in
{
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    # rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-nextest

    # python
    python3
    uv
    mypy
    ruff

    # js
    nodejs
    typescript
    pnpm
    prettier
    eslint

    # nix
    nil
    nixfmt-rfc-style

    # typst
    typst
    tinymist

    # cli
    bashInteractive
    eza
  ];

  home.shellAliases = {
    ls = "eza -a";
    cd = "z";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "eastwood";
      plugins = [ "git" ];
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "OneDark";
    font = font;
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g mouse on

      # map prefix to C-a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # fix colours
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"
    '';
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = secrets.gitUserName;
    userEmail = secrets.gitEmail;
    extraConfig = {
      core.editor = "code --wait";
    };
    ignores = [ ".DS_Store" ];
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        navigate = true;
        hunk-header-style = "omit";
        file-style = "bold blue";
        syntax-theme = "TwoDark";
      };
    };
  };

  programs.btop = {
    enable = true;
    settings.color_theme = "TTY";
  };

  programs.helix = {
    enable = true;
    settings.theme = "gruvbox";
  };

  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      userSettings = {
        "extensions.autoCheckUpdates" = false;

        # appearance
        "workbench.colorTheme" = "Dark+";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = font.name;
        "editor.fontSize" = font.size;
        "editor.inlayHints.enabled" = "offUnlessPressed";
        "editor.minimap.enabled" = false;

        # saving
        "editor.formatOnSave" = true;
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.autoSave" = "onFocusChange";

        # extensions
        "rust-analyzer.lens.enable" = false;
        "rewrap.autoWrap.enabled" = true;
        "rewrap.wrappingColumn" = 80;
      };
      extensions = with pkgs.vscode-marketplace; [
        # themes
        pkief.material-icon-theme

        # lsp
        myriad-dreamin.tinymist
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        zxh404.vscode-proto3
        yzhang.markdown-all-in-one

        # tools
        usernamehw.errorlens
        dnut.rewrap-revived
        gruntfuggly.todo-tree
      ];
    };
  };
}
