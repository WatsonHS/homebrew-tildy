class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.1/tildy-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "71bc7590939fea750b534f3332c1b0f2c9281cfa5a6a8b9896fd92a23f0a9127"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.1/tildy-0.3.1-x86_64-apple-darwin.tar.gz"
      sha256 "c87a4fe35a5c24ea5c9e4560f857d052497e24b5445618a23c209bc40ab4db67"
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
        tildy configure

      Inspect or manage the same config (advanced use and scripts):
        tildy config --help

      Preview shell setup without writing: tildy init --dry-run
      A Nerd Font is needed for the pastel-powerline preset.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tildy --version")
    ENV["ZDOTDIR"] = testpath.to_s
    system bin/"tildy", "init"
    initial = (testpath/".zshrc").read
    assert_match "# >>> tildy instant >>>", initial
    assert_match "# >>> tildy prompt >>>", initial
    system bin/"tildy", "init"
    assert_equal initial, (testpath/".zshrc").read
  end
end
