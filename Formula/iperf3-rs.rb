class Iperf3Rs < Formula
  desc "Rust API for libiperf with live iperf3 metrics export"
  homepage "https://github.com/mi2428/iperf3-rs"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.1/iperf3-rs-aarch64-apple-darwin.tar.xz"
      sha256 "ed6173a1cc19b68dee4bd4ada4c14946287288ad48b472dc6d58c0b860b13a5b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.1/iperf3-rs-x86_64-apple-darwin.tar.xz"
      sha256 "a0304fae5444c6843e0d3517ca0cf9631a4fd318a8ab19cdf04f8ed3056f8102"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.1/iperf3-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a7b259da26337d2aadc28838a2dddd76e2a164905465a1e3218f586eed52702"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.1/iperf3-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "de5f98f14f74cf74b4225ab6847a1146e8d66717265b79b5cf4ad95a2cab348e"
    end
  end
  license all_of: ["MIT", "BSD-3-Clause-LBNL"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "iperf3-rs" if OS.mac? && Hardware::CPU.arm?
    bin.install "iperf3-rs" if OS.mac? && Hardware::CPU.intel?
    bin.install "iperf3-rs" if OS.linux? && Hardware::CPU.arm?
    bin.install "iperf3-rs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
