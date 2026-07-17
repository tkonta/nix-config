{ pkgs, lib, username, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    tmux
    tree
    python3
    dockutil
  ];

  # Alacritty本体はHomebrewではなくNix/Home Managerで管理する。
  # settingsを書いていないため、既存のalacritty.tomlは上書きしない。
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
  };

  # Emacs本体とEmacs LispパッケージはNixで一元管理する。
  # init.elでは、これらのパッケージの設定だけをuse-packageで記述する。
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;

    extraPackages = epkgs: [
      epkgs."exec-path-from-shell"
      epkgs.macrostep
      epkgs."undo-tree"
      epkgs.smartparens
      epkgs.ripgrep
      epkgs."yaml-mode"
      epkgs."idea-darkula-theme"
      epkgs."solarized-theme"
      epkgs."visual-regexp-steroids"
      epkgs."easy-kill"
      epkgs.consult
      epkgs.orderless
      epkgs.vertico
      epkgs.marginalia
      epkgs.embark
      epkgs."embark-consult"
      epkgs."highlight-indent-guides"
      epkgs."rainbow-delimiters"
      epkgs.company
      epkgs."which-key"
      epkgs."persistent-scratch"
      epkgs.flycheck
      epkgs."flycheck-inline"
      epkgs."lsp-mode"
      epkgs."lsp-ui"
      epkgs.dashboard
      epkgs.projectile
      epkgs.neotree
      epkgs."multiple-cursors"
    ];
  };

  # Home Managerで導入した*.appを
  # ~/Applications/Home Manager Apps に公開する。
  # mac-app-utilは、このディレクトリを元にランチャーを生成する。
  targets.darwin.linkApps.enable = true;

  # Nixで導入したGUIアプリをDockへ追加する。
  # mac-app-utilがTrampolineを生成したあとに実行する。
  # --replacing は、既に同名の項目があれば置き換え、
  # なければDock末尾へ追加する。ほかのDock項目には触れない。
  home.activation.addNixAppsToDock = lib.hm.dag.entryAfter [ "trampolineApps" ] ''
    dockutil="${lib.getExe pkgs.dockutil}"
    emacs_app="$HOME/Applications/Home Manager Trampolines/Emacs.app"
    alacritty_app="$HOME/Applications/Home Manager Trampolines/Alacritty.app"
    dock_changed=0

    if [ -d "$emacs_app" ]; then
      $DRY_RUN_CMD "$dockutil" \
        --add "$emacs_app" \
        --replacing "Emacs" \
        --no-restart
      dock_changed=1
    fi

    if [ -d "$alacritty_app" ]; then
      $DRY_RUN_CMD "$dockutil" \
        --add "$alacritty_app" \
        --replacing "Alacritty" \
        --no-restart
      dock_changed=1
    fi

    if [ "$dock_changed" -eq 1 ]; then
      $DRY_RUN_CMD /usr/bin/killall Dock 2>/dev/null || true
    fi
  '';

  # ユーザー情報
  home.username = username;
  home.homeDirectory = lib.mkForce "/Users/${username}";

  # 環境変数
  home.sessionVariables = {
    ZDOTDIR = "~/.config/zsh";
  };

  # Home Managerの互換性バージョン。既存値を維持する。
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
}
