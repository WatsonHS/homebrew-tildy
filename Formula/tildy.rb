class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.3.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.4/tildy-0.3.4-aarch64-apple-darwin.tar.gz"
      sha256 "175f21cad5d8ba8d5fdf2f383b8eb5d0dc72ab0f67a7f4ea550a6795507a5761"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.4/tildy-0.3.4-x86_64-apple-darwin.tar.gz"
      sha256 "a017d66b9e12ca257cba79c4daff79bed2c5fa23bbac30be3e42ba0226717ffc"
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
