class Iperf3Rs < Formula
  desc "Rust API for libiperf with live iperf3 metrics export"
  homepage "https://github.com/mi2428/iperf3-rs"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.0/iperf3-rs-aarch64-apple-darwin.tar.xz"
      sha256 "ace2d90a71fc2fb1a016effba7475c4083a2ca39334b589ba595320745a4e6fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.0/iperf3-rs-x86_64-apple-darwin.tar.xz"
      sha256 "7de04896ee975bfcb13c1ad3ce23336761aeda25085bc7b49e3355060d39ef45"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.0/iperf3-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "48671f64b4c2667ef27bd315f0f49674896082ede11bfeacda0ecd44a483b3c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.0/iperf3-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88e7fc347bc6db97bee2993e64ade0455e29c4a772cb5351ddd89c37c1da1f7b"
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
