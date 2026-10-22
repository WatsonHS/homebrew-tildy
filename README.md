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

To choose a theme, colors, layout and blank lines with live preview, run `tildy theme`. Press Tab to focus the controls, use Left/Right to select 提示符前空行 (blank line before the prompt), Space to toggle, and Enter to save. The choice is restored when reopening the picker and preserved when switching presets. This step is optional; Tildy works with its built-in defaults. The old `tildy configure` command remains available as a compatibility alias with the same arguments.

For scripts, use `tildy theme --preset pastel-powerline --add-newline` to enable blank lines, or `--no-add-newline` to disable them.

`tildy config` provides `get`, `validate`, `apply`, `history` and `rollback` commands for managing the same configuration, with JSON output for scripts and agents. Both entry points share configuration writes, revision checks and history. These are subcommands without a leading dash: `tildy theme` and `tildy config get`. See `tildy config --help` for details.

Upgrade with:

```sh
brew update
brew upgrade tildy
```

For manual setup, `tildy init zsh` and `tildy init zsh --instant` continue to print scripts for `eval` without modifying `.zshrc`.
