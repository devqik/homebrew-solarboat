class Solarboat < Formula
    desc "Modern CLI for Infrastructure as Code and GitOps workflows"
    homepage "https://solarboat.io"
    version "0.7.3"
    license "BSD-3-Clause"

    if OS.mac?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-apple-darwin.tar.gz"
        sha256 "b875df477c4a1f0f85c898d7ccaae2a7ebd11df46d24f14bfb76b724c20b9c82"
    elsif OS.linux?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "b875df477c4a1f0f85c898d7ccaae2a7ebd11df46d24f14bfb76b724c20b9c82"
    end

    def install
        bin.install "solarboat"
    end

    test do
        system "#{bin}/solarboat", "--help"
    end
end
  
