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

ユーザー名は以下の反映コマンドで `DARWIN_USER` に渡すため、設定ファイルに記載する必要はありません。
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
sudo DARWIN_USER="$(whoami)" /run/current-system/sw/bin/darwin-rebuild switch --flake . --impure
```

ユーザー名を環境変数から取得するため、`--impure` が必要です。
普段のユーザーのターミナルから実行してください。`$(whoami)` は sudo の実行前に評価されます。
システムへの反映には root 権限が必要ですが、Homebrew や Home Manager の適用対象はこのユーザーです。
移行後の nix-darwin を確実に使うため、コマンドは `/run/current-system/sw/bin/darwin-rebuild` を指定しています。

パッケージのアップグレード
```sh
nix flake update
sudo DARWIN_USER="$(whoami)" /run/current-system/sw/bin/darwin-rebuild switch --flake . --impure
```

別のPCへ同じ構成を反映する場合は、検証済みの `flake.nix` と `flake.lock` を取り込み、設定反映コマンドだけを実行します。
そのPCで改めて `nix flake update` を実行する必要はありません。
`result-darwin` はローカルのビルド結果へのリンクなので、コミットには含めません。

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
