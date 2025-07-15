class Solarboat < Formula
    desc "Modern CLI for Infrastructure as Code and GitOps workflows"
    homepage "https://solarboat.io"
    version "0.7.3"
    license "BSD-3-Clause"

    if OS.mac?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-apple-darwin.tar.gz"
        sha256 "sha256:55fa3f63d5bd671049c01a0f5bbb2a8173d020e7b5f513937150bde58c71fdc0"
    elsif OS.linux?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "sha256:3b9bdbbe38483e32d77b25ca13f16d0acd4b4269a0cfcb39fcf996ad023fb8ab"
    end

    def install
        bin.install "solarboat"
    end

    test do
        system "#{bin}/solarboat", "--help"
    end
end
  