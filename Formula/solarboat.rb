class Solarboat < Formula
    desc "Modern CLI for Infrastructure as Code and GitOps workflows"
    homepage "https://solarboat.io"
    version "0.8.4"
    license "BSD-3-Clause"

    if OS.mac?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-apple-darwin.tar.gz"
        sha256 "c92a62467789c40dfc5cc6ae6c7a7906c55f65021c71d384a7f04f95b6fda677"
    elsif OS.linux?
        url "https://github.com/devqik/solarboat/releases/download/v#{version}/solarboat-x86_64-unknown-linux-gnu.tar.gz"
        sha256 "624d43e7fae3168988a16794c9c674c5770e8bfa9b528aa48425b2dea09ee586"
    end

    def install
        bin.install "solarboat"
    end

    test do
        system "#{bin}/solarboat", "--help"
    end
end
  
