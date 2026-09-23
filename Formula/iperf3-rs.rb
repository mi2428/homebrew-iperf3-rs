class Iperf3Rs < Formula
  desc "Rust API for libiperf with live iperf3 metrics export"
  homepage "https://github.com/mi2428/iperf3-rs"
  version "1.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-aarch64-apple-darwin.tar.xz"
      sha256 "181a0c38ec8af3121cfa1198bb9a1834ff911ce4301399ce626af89d2c674d6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-x86_64-apple-darwin.tar.xz"
      sha256 "07ba7df03b235cf4a1b8472b8f666610e49825e01d05cd89969ebafda9d40a70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1bd30af86cbbaa4a93af9d85608f8c37ed80e5dee7e82acbb054615e6b2e1887"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "30c80d8b09e3d392ed71986ab3804bde67bc017071fe88972f21d761b3988ee8"
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
