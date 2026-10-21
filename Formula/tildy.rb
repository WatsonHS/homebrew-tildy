class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.3.0-m3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.0-m3/tildy-0.3.0-m3-aarch64-apple-darwin.tar.gz"
      sha256 "d4f5b2dace13f3d978a94504e856ae3c45469efa6f0a437eef6864f8cf01c2a4"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.3.0-m3/tildy-0.3.0-m3-x86_64-apple-darwin.tar.gz"
      sha256 "0aefc10cd8c712c94fd0f44d6c821de3191c472a750fe5f48d55085863d217ab"
    end
  end

  def install
    bin.install "tildy"
  end

  def caveats
    <<~EOS
      Add to ~/.zshrc:
        first line:  eval "$(tildy init zsh --instant)"
        last line:   eval "$(tildy init zsh)"
      A Nerd Font is needed for the pastel-powerline preset.
    EOS
  end

  test do
    assert_match "tildy", shell_output("#{bin}/tildy --version")
  end
end
