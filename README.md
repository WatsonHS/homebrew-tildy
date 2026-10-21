# homebrew-tildy

Homebrew tap and binary releases for [tildy](https://github.com/WatsonHS/homebrew-tildy), an async, agent-friendly Zsh prompt. The source repository is private for now; this repository holds the formula and the release tarballs.

```sh
brew tap WatsonHS/tildy
brew trust WatsonHS/tildy   # Homebrew requires trusting a third-party tap first
brew install tildy
```

Then in `~/.zshrc`: first line `eval "$(tildy init zsh --instant)"`, last line `eval "$(tildy init zsh)"`. A Nerd Font is needed for the `pastel-powerline` preset.

Upgrade with `brew upgrade tildy`.
