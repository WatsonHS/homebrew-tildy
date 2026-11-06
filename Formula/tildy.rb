class Tildy < Formula
  desc "Async, agent-friendly Zsh prompt"
  homepage "https://github.com/WatsonHS/homebrew-tildy"
  version "0.4.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.4.1/tildy-0.4.1-aarch64-apple-darwin.tar.gz"
      sha256 "68bcfe13fc2e19ae430fcb5b7076f6898df0cef17c6a60a759399d7a4c1e03c5"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.4.1/tildy-0.4.1-x86_64-apple-darwin.tar.gz"
      sha256 "3f89511f51a6a061dbde7cfac8ef4e94142f15a9f534836fe41ba1bc5d81ae6b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.4.1/tildy-0.4.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "70152c1d1f27007e7fa7508cd3d1bd4e164e9e1320690059b9514e3f886e9309"
    end
    on_intel do
      url "https://github.com/WatsonHS/homebrew-tildy/releases/download/v0.4.1/tildy-0.4.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c54dc1193e70999f1f744948dfd101699cb82a60c6c5b8686fca01b5edac63b3"
    end
  end

  def install
    if OS.linux? && OS::Linux::Glibc.system_version < Version.new("2.39")
      odie "Tildy requires system glibc 2.39 or newer (for example, Ubuntu 24.04)."
    end
    bin.install "tildy"
    doc.install "LICENSE", "NOTICE", "licenses"
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
