nix のインストール
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |  sh -s -- install
```

nix-darwinのインストール
```sh
nix profile install github:LnL7/nix-darwin
```

homebrewのインストール
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

以下をzshrcへ反映
```sh
export DARWIN_USER=$(whoami)
export DARWIN_HOST=$(hostname -s)
```

設定反映
```sh
darwin-rebuild switch --flake . --impure
```

clean up
```sh
nix-collect-garbage -d
```