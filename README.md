nix のインストール
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |  sh -s -- install
```

nix-darwinのインストール
```sh
nix profile add github:LnL7/nix-darwin
```

homebrewのインストール
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

環境変数の設定
```sh
export DARWIN_USER="$(whoami)"
```

ユーザー名は実行時に取得するため、設定ファイルに記載する必要はありません。
`DARWIN_HOST` の設定は不要です。

`darwin-rebuild` が現在のホスト名から、以下の設定を自動で選択します。

| ホスト名 (`hostname -s`) | 設定ファイル |
| --- | --- |
| `tkontaMacBookAir` | `configuration.home.nix` |
| `FONP00191` | `configuration.office.nix` |

ホスト名との対応は `flake.nix` の `hostConfigurations` で管理します。
未登録のホスト名では設定が見つからずエラーになります。

設定反映
```sh
darwin-rebuild switch --flake . --impure
```

ユーザー名を環境変数から取得するため、`--impure` が必要です。

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


## トラブルシューティング

一部のソフトウェアがAppleの検証によりオープンできない場合は手動でインストールを行う

```sh
brew uninstall alacritty
brew install --cask alacritty --no-quarantine
```

nix-darwinでトラブルがあったときは、flake updateで最新版を試してみる

```sh
nix flake update
```
