# homebrew-tildy

Homebrew tap and binary releases for [tildy](https://github.com/WatsonHS/homebrew-tildy), an async, agent-friendly Zsh prompt. The source repository is private for now; this repository holds the formula and the release tarballs.

```sh
brew tap WatsonHS/tildy
brew trust WatsonHS/tildy   # Homebrew requires trusting a third-party tap first
brew install tildy
tildy init
```

Open a new terminal after running `tildy init`. It sets up the instant prompt and normal prompt in `~/.zshrc` (or `$ZDOTDIR/.zshrc`), backs up existing files and preserves symlinks. Running it again does not add duplicate entries. Use `tildy init --dry-run` to preview the result without writing files.

A Nerd Font is needed for the `pastel-powerline` preset. If you already use another prompt, disable its initialization before enabling Tildy.

Upgrade with:

```sh
brew update
brew upgrade tildy
```

For manual setup, `tildy init zsh` and `tildy init zsh --instant` continue to print scripts for `eval` without modifying `.zshrc`.
