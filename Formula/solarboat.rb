class Solarboat < Formula
  desc "Modern CLI for Infrastructure as Code and GitOps workflows"
  homepage "https://solarboat.io"
  version "0.8.9"
  license "BSD-3-Clause"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-apple-darwin.tar.gz"
      sha256 "14c3e46a4aef5f11940511bbfbca71dd35f5654b1c45bb604d0b58b1980f6278"
    elsif Hardware::CPU.arm?
      url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-aarch64-apple-darwin.tar.gz"
      sha256 "PLACEHOLDER_AARCH64_MACOS_SHA256"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4bdb22bc02a8d897721820ec3fa6b6c4e611bef5275207a869f6f50c5b66b323"
    elsif Hardware::CPU.arm?
      url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "PLACEHOLDER_AARCH64_LINUX_SHA256"
    end
  end

  def install
    bin.install "solarboat"
  end

  test do
    system "#{bin}/solarboat", "--help"
  end
end
