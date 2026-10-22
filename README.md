# homebrew-tildy

Homebrew tap and binary releases for [tildy](https://github.com/WatsonHS/homebrew-tildy), an async, agent-friendly Zsh prompt. The source repository is private for now; this repository holds the formula and the release tarballs.

Supported packages: macOS ARM64/x86_64 and Linux ARM64/x86_64. Linux binaries require **system glibc 2.39 or newer** (for example, Ubuntu 24.04); the formula rejects older systems. Zsh is required to enable the prompt. Linux ARM64 has full Rust/Zsh/PTY validation; x86_64 has package and Homebrew validation under emulation.

```sh
brew tap WatsonHS/tildy
brew trust WatsonHS/tildy   # Homebrew requires trusting a third-party tap first
brew install tildy
tildy init
```

Open a new terminal after running `tildy init`. It sets up the instant prompt and normal prompt in `~/.zshrc` (or `$ZDOTDIR/.zshrc`), backs up existing files and preserves symlinks. Running it again does not add duplicate entries. Use `tildy init --dry-run` to preview the result without writing files.

The default appearance is `pastel-powerline`: two rows with a blank line before each prompt. A Nerd Font is needed for this preset. Explicit preset, layout and blank-line settings take precedence. If you already use another prompt, disable its initialization before enabling Tildy.

To choose a theme, colors, layout and blank lines with live preview, run `tildy theme`. Press Tab to focus the controls, use Left/Right to select Blank line, Space to toggle, and Enter to save. The choice is restored when reopening the picker and preserved when switching presets. This step is optional; Tildy works with its built-in defaults. The old `tildy configure` command remains available as a compatibility alias with the same arguments.

Version notices, setup messages, theme controls and preview descriptions use English by default. Set `export TILDY_LANG=zh` before the initialization lines in `.zshrc` for Chinese, or `export TILDY_LANG=auto` to follow `LC_ALL`, `LC_MESSAGES`, then `LANG`. Use `en` to force English; unsupported languages fall back to English. CLI help and low-level validation errors remain English. Commands, configuration keys and JSON metadata stay in English.

For scripts, use `tildy theme --preset pastel-powerline --add-newline` to enable blank lines, or `--no-add-newline` to disable them.

`tildy config` provides `get`, `validate`, `apply`, `history` and `rollback` commands for managing the same configuration, with JSON output for scripts and agents. Both entry points share configuration writes, revision checks and history. These are subcommands without a leading dash: `tildy theme` and `tildy config get`. See `tildy config --help` for details.

Upgrade with:

```sh
brew update
brew upgrade tildy
exec zsh
```

Use a new terminal or `exec zsh` after upgrading to load the new shell adapter. Running `source ~/.zshrc` keeps an adapter that is already loaded. Version 0.4.0 completes M4 with Starship migration reports, repository display overrides, and terminal compatibility fixes. Existing themes and shell setup are preserved. Ghostty, cmux, and iTerm2 retain compact history and command navigation; Terminal.app keeps the full accepted prompt to preserve its native command marks.

For manual setup, `tildy init zsh` and `tildy init zsh --instant` continue to print scripts for `eval` without modifying `.zshrc`.

## M4 configuration and migration

Preview a Starship migration before applying it:

```sh
tildy import starship --file ~/.config/starship.toml --json
```

The report separates ignored options, Starship bridges, and items requiring manual changes. Bridged modules retain the absolute source TOML path and require both Starship and that file. `--write` only creates a missing Tildy user config, uses the same bounded transaction lock as other config writes, and refuses to overwrite an existing file.

A `.tildy.json` in the nearest Git worktree root can override display settings for existing modules:

```json
{
  "schema_version": 1,
  "modules": {
    "cwd": { "style": { "foreground": "cyan", "bold": true } }
  }
}
```

The repository layer cannot define commands, change executable paths, add modules, or activate modules absent from the lower layout. Invalid layers are ignored as a whole and reported by `tildy config get --effective --json`. Changes apply on the next prompt request. Set `TILDY_PROJECT_CONFIG=0` before initialization to disable this layer.

```sh
tildy config get --effective --cwd /path/to/repo --json
tildy config validate --project --file .tildy.json --json
tildy schema --project --json
```

M4 native GUI acceptance covered Ghostty 1.3.1, cmux 0.65.0, iTerm2 3.7.6, and Terminal.app 2.15: width calibration, window and font resizing, command navigation, instant cache display, and input typed during startup. Calibration measures cell widths; it does not supply missing font glyphs. Recalibrate after changing terminal or font settings.
