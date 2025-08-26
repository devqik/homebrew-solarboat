class Solarboat < Formula
    desc "Modern CLI for Infrastructure as Code and GitOps workflows"
    homepage "https://solarboat.io"
    version "0.8.7"
    license "BSD-3-Clause"

    if OS.mac?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-apple-darwin.tar.gz"
        sha256 "4b41ac916ac2c26b95d8a94061cacb5e57d54a10b6148034e53cb62d0f88b0ed"
    elsif OS.linux?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "86456d85c21d892525f9a0a246d63b5939e477eee4ac2f487cbca4b4d0062d1c"
    end

    def install
        bin.install "solarboat"
    end

    test do
        system "#{bin}/solarboat", "--help"
    end
end
  
