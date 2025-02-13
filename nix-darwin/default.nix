{pkgs, ...}: {

  # nix自体の設定
  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = "nix-command flakes";
      max-jobs = 8;
    };
  };

  # システムの設定（nix-darwinが効いているかのテスト）
  system = {
    stateVersion = 5; # 必要そう。。。
    defaults = {
      NSGlobalDomain.AppleShowAllExtensions = true;
      finder = {
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = false;
        show-recents = false;
        orientation = "bottom";
      };
    };
  };

  # homebrewの設定
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      # !! 注意 !!
      cleanup = "uninstall";
    };

    casks = [

    ];
    masApps = {

    };
  };
}