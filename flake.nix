{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixで導入したmacOSアプリをSpotlightやDockから安定して扱えるようにする。
    # mac-app-util自身が動作確認済みのnixpkgsを固定しているため、
    # ここでは inputs.nixpkgs.follows は指定しない。
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    mac-app-util,
    ...
  }:
    let
      darwinUser = builtins.getEnv "DARWIN_USER";
      darwinHost = builtins.getEnv "DARWIN_HOST";

      mkDarwinSystem = { hostname, username }:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
            # ./configuration.office.nix
            ./configuration.home.nix
            home-manager.darwinModules.home-manager

            {
              networking.hostName = hostname;
              users.users.${username}.home = "/Users/${username}";

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # Home Managerで導入したEmacs.appやAlacritty.appに対して、
              # Spotlight対応のランチャー作成とDockリンクの追従を行う。
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];

              home-manager.users.${username} = { pkgs, lib, ... }:
                import ./home.nix {
                  inherit pkgs lib username;
                };
            }
          ];

          specialArgs = {
            inherit (nixpkgs) lib;
            inherit username;
          };
        };
    in
    {
      darwinConfigurations.${darwinHost} = mkDarwinSystem {
        hostname = darwinHost;
        username = darwinUser;
      };
    };
}
