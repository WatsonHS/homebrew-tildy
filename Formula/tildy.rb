class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.3/tildy-0.3.3-aarch64-apple-darwin.tar.gz"
      sha256 "514454bbcb9465e7c21752efc41260d28023e10332c7adcbb4943168c51ec8c4"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.3/tildy-0.3.3-x86_64-apple-darwin.tar.gz"
      sha256 "80721d36b1847ecb981286bf5367c75e2df8067190b2e7c1c25d7ed91f27b86e"
    end
  end

  def install
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
      A Nerd Font is needed for the pastel-powerline preset.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tildy --version")
    theme_help = shell_output("#{bin}/tildy theme --help")
    assert_match "Usage: tildy theme", theme_help
    assert_equal theme_help, shell_output("#{bin}/tildy configure --help")
    ENV["TILDY_CONFIG"] = (testpath/"config.json").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
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
