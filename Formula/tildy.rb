class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.3.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.2/tildy-0.3.2-aarch64-apple-darwin.tar.gz"
      sha256 "2240491b8743ada149f8116ea272654386c59727d322af547be36ab41089e3df"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.2/tildy-0.3.2-x86_64-apple-darwin.tar.gz"
      sha256 "08a5bc754f9f0eea9af1bd6a773ecb0df8802a9259d12fb3c6be583c4549ba90"
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

      Choose a theme, colors and layout (optional):
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
    ENV["ZDOTDIR"] = testpath.to_s
    system bin/"tildy", "init"
    initial = (testpath/".zshrc").read
    assert_match "# >>> tildy instant >>>", initial
    assert_match "# >>> tildy prompt >>>", initial
    system bin/"tildy", "init"
    assert_equal initial, (testpath/".zshrc").read
  end
end
