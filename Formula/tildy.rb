class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.3.6"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.6/tildy-0.3.6-aarch64-apple-darwin.tar.gz"
      sha256 "ff134a8f8c5d388f7686f90b46419f48a65091eaa37233ec04657a22d3c9bc6e"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.6/tildy-0.3.6-x86_64-apple-darwin.tar.gz"
      sha256 "cd98b52aeb9cc02771d3fba48489e62a920ceb5c31e46dd647a7bfec3973730b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.6/tildy-0.3.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fa822550fd1fa2abdd639328ac530b0e7696142a1eb864a27a915d7fa9fb95d1"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.6/tildy-0.3.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "061920372e7599aee3c9c138b611050bc91d6465c86730260364480ee7bc6262"
    end
  end

  def install
    if OS.linux? && OS::Linux::Glibc.system_version < Version.new("2.39")
      odie "Tildy requires system glibc 2.39 or newer (for example, Ubuntu 24.04)."
    end
    bin.install "tildy"
  end

  def caveats
    <<~EOS
      Enable Tildy in Zsh (backs up .zshrc; respects ZDOTDIR):
        tildy init
      Then open a new terminal.

      Choose a theme, colors, layout and blank lines (optional):
        tildy theme

      Inspect or manage the same config (advanced use and scripts):
        tildy config --help

      Preview shell setup without writing: tildy init --dry-run
      Default: pastel-powerline, two rows, with a blank line before the prompt.
      A Nerd Font is needed for this preset. Use tildy theme to choose another.
      UI language: English by default; export TILDY_LANG=zh for Chinese,
      or TILDY_LANG=auto to follow the system locale.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tildy --version")
    theme_help = shell_output("#{bin}/tildy theme --help")
    assert_match "Usage: tildy theme", theme_help
    assert_equal theme_help, shell_output("#{bin}/tildy configure --help")
    ENV["TILDY_CONFIG"] = (testpath/"config.json").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    effective = JSON.parse(shell_output("#{bin}/tildy config get --effective --json"))["data"]["config"]
    assert_equal "pastel-powerline", effective["preset"]
    assert_equal true, effective["add_newline"]
    assert_equal 2, effective["layout"]["rows"].length
    system bin/"tildy", "theme", "--preset", "plain", "--add-newline"
    assert_equal true, JSON.parse((testpath/"config.json").read)["add_newline"]
    system bin/"tildy", "theme", "--preset", "plain", "--no-add-newline"
    assert_equal false, JSON.parse((testpath/"config.json").read)["add_newline"]
    ENV["ZDOTDIR"] = testpath.to_s
    system bin/"tildy", "init"
    initial = (testpath/".zshrc").read
    assert_match "# >>> tildy instant >>>", initial
    assert_match "# >>> tildy prompt >>>", initial
    system bin/"tildy", "init"
    assert_equal initial, (testpath/".zshrc").read
  end
end
