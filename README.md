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

環境変数の設定
```sh
export DARWIN_USER=$(whoami)
export DARWIN_HOST=$(hostname -s)
```

nix-darwinの設定ファイルの読み込み先のシンボリックファイルを作成
```sh
    ln -s configuration.private.nix configuration.nix 
```

設定反映
```sh
darwin-rebuild switch --flake . --impure
```

パッケージのアップグレード
```sh
nix flake update
darwin-rebuild switch --flake . --impure
```

clear cache
```sh
nix store gc
```

uninstall
```sh
darwin-uninstaller
/nix/nix-installer uninstall
```
