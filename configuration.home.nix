{ pkgs, ... }:
{
  nix.enable = false;
  # システムにインストールするパッケージ
  environment.systemPackages = with pkgs; [
    git
  ];

  # Nixデーモンの自動アップグレードを有効化
  # services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # zshの設定
  programs.zsh.enable = true;

  # 非自由パッケージを許可
  nixpkgs.config.allowUnfree = true;


  # Finder設定
  system.defaults.finder = {
    # 全てのファイル拡張子を表示: trueにすると、すべてのファイルの拡張子が表示されます。
    # ファイルタイプを一目で確認できるため、ファイル管理が容易になります。
    AppleShowAllExtensions = true;

    # 隠しファイルを表示: trueにすると、通常は非表示のファイル（.で始まるファイル）も表示されます。
    # 開発作業や詳細な設定を行う際に便利ですが、通常使用では不要なファイルも表示されるため注意が必要です。
    AppleShowAllFiles = true;

    # デスクトップアイコンの非表示: falseにすると、デスクトップ上のアイコンが非表示になります。
    # クリーンな作業環境を好む場合や、デスクトップの整理を強制する場合に有用です。
    CreateDesktop = false;

    # 拡張子変更時の警告を無効化: falseにすると、ファイル拡張子を変更する際の警告が表示されなくなります。
    # 頻繁にファイル拡張子を変更する作業を行う場合、作業効率が向上します。
    FXEnableExtensionChangeWarning = false;

    # パスバーを表示: trueにすると、Finderウィンドウの下部にファイルパスが表示されます。
    # 現在の位置を把握しやすくなり、ディレクトリ間の移動が容易になります。
    ShowPathbar = true;

    # ステータスバーを表示: trueにすると、Finderウィンドウの下部に選択したアイテムの情報が表示されます。
    # ファイル数や容量などの情報を素早く確認できるため、ファイル管理に役立ちます。
    ShowStatusBar = true;
    
    # ファイルをリスト表示
    FXPreferredViewStyle = "Nlsv";
  };

  # Dock設定
  system.defaults.dock = {
    # Dockの自動非表示: trueの場合、Dockを自動で隠します。
    # これを有効にすると画面を広く使えるため、作業スペースが拡大します。
    autohide = true;

    # 最近使用したアプリケーションの非表示: falseにすると、Dockに最近のアプリが表示されなくなります。
    # プライバシーを重視する場合や、Dockをシンプルに保ちたい場合に有用です。
    show-recents = false;

    # Dockアイコンのサイズ: ピクセル単位でアイコンサイズを設定します。
    # 50pxは中程度のサイズで、見やすさと省スペースのバランスが取れています。
    tilesize = 50;

    # Dockアイコンの拡大機能: trueにすると、マウスオーバー時にアイコンが拡大表示されます。
    # アイコンの識別が容易になり、特に多くのアプリがDockにある場合に便利です。
    magnification = true;

    # 拡大時のアイコンサイズ: マウスオーバー時のアイコンサイズをピクセル単位で設定します。
    # 64pxは適度な拡大サイズで、アイコンの詳細が見やすくなります。
    largesize = 64;

    # Dockの位置: "bottom"、"left"、"right"のいずれかを指定できます。
    # 画面下部に配置すると、一般的なmacOSの外観に近くなります。
    orientation = "bottom";

    # ウィンドウ最小化エフェクト: "scale"は縮小エフェクトを使用します。
    # このエフェクトは視覚的に分かりやすく、システムの応答が速く感じられます。
    mineffect = "scale";

    # アプリケーション起動時のアニメーションを無効化: falseにすると、起動アニメーションが表示されなくなります。
    # システムの応答が速く感じられ、特に低スペックのマシンで有用です。
    launchanim = false;

    # App Exposéを有効にする（マルチタッチジェスチャーで利用可能に）
    # showAppExposeGestureEnabled = true;

    # アプリケーションごとにウィンドウをグループ化
    expose-group-apps = true;
  };

  # キーボードのリピート速度を速くする設定
  system.defaults.NSGlobalDomain = {
    # キーリピートの速度（数値が小さいほど速い、デフォルトは6）

    KeyRepeat = 2;

    # キーリピート開始までの遅延（数値が小さいほど速い、デフォルトは25）
    InitialKeyRepeat = 10;

    # 継続的なキー押下を有効化（必要に応じて）
    ApplePressAndHoldEnabled = false;
  };

  # homebrewの設定
  homebrew = {
      enable = true;
        onActivation = {
        autoUpdate = true;      # `brew update`を実行
        cleanup = "zap";        # 管理されていないFormulaeを削除
        upgrade = true;         # `brew upgrade`を実行
      };
      brews = [
        "mas"
        "cpanminus"
        "openjdk"
      ];
      casks = [
        "emacs"
        "alacritty"
        "google-chrome"
        "google-japanese-ime"
        "google-drive"
        "clipy"
        "slack"
        "sequel-ace"
        "raycast"
        "discord"
        "qfinder-pro"
        "keka"
        "brave-browser"
        "mi@beta"
        "elgato-camera-hub"
        "obs"
      ];

      # AppStore
      masApps = {
        LINE = 539883307;
        Xcode = 497799835;
        Monosnap = 540348655;
        G2FA = 6444865161;
        "まるごと英和検索for英辞郎" = 919856506;
        "MARKETSPEED" = 946680495;
      };
  };

  # 下位互換性のため（変更時はchangelogを確認）
  system.stateVersion = 6;

  # ターゲットプラットフォーム
  nixpkgs.hostPlatform = "aarch64-darwin";
}
