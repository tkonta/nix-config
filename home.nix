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

  # 初回もアプリのリンク配置を済ませてからランチャーを生成する。
  home.activation.prepareNixAppTrampolines =
    lib.hm.dag.entryBetween [ "trampolineApps" ] [ "linkGeneration" ] "";

  # osacompile由来のアイコン指定が元アプリの.icnsより優先されるため、
  # 汎用appletアイコンの指定だけを除去する。変更後は再署名・再登録する。
  home.activation.fixNixAppIcons = lib.hm.dag.entryAfter [ "trampolineApps" ] ''
    for name in Emacs Alacritty; do
      app="$HOME/Applications/Home Manager Trampolines/$name.app"
      plist="$app/Contents/Info.plist"
      if [ -f "$plist" ] && \
        [ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIconName' "$plist" 2>/dev/null || true)" = applet ]; then
        run /usr/libexec/PlistBuddy -c 'Delete :CFBundleIconName' "$plist"
        run /usr/bin/codesign --force --sign - "$app"
        run /usr/bin/touch "$app"
        run /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
      fi
    done
  '';

  # Dockにはランチャーではなく実体を登録し、起動中の本体と一致させる。
  # Home Managerのリンクを解決するので、更新時も最新のstoreパスに追従する。
  # --replacing は、既に同名の項目があれば置き換え、
  # なければDock末尾へ追加する。ほかのDock項目には触れない。
  home.activation.addNixAppsToDock = lib.hm.dag.entryAfter [ "fixNixAppIcons" ] ''
    dockutil="${lib.getExe pkgs.dockutil}"
    dock_changed=0

    for name in Emacs Alacritty; do
      app_link="$HOME/Applications/Home Manager Apps/$name.app"
      if [ -d "$app_link" ]; then
        app=$(cd "$app_link" && pwd -P)
        run "$dockutil" \
          --add "$app" \
          --replacing "$name" \
          --no-restart
        dock_changed=1
      fi
    done

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
