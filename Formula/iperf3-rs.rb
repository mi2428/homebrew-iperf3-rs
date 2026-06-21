class Iperf3Rs < Formula
  desc "Rust API for libiperf with live iperf3 metrics export"
  homepage "https://github.com/mi2428/iperf3-rs"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.2/iperf3-rs-aarch64-apple-darwin.tar.xz"
      sha256 "2d0034409d45217412827231a8cae08f48fb5430fe5c1e3ccb50aa77bb2b0796"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.2/iperf3-rs-x86_64-apple-darwin.tar.xz"
      sha256 "7d944a109e670a545ae1a600e1f395f4deac22ee20a8aaef5c0e3aba8d256dc5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.2/iperf3-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7a1b515292c74fe26d2941cb2f6e425b5fe85eb6922338edf03af478199112c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.2/iperf3-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d0fbf55d262c28a5a3f992b61a12b6b5bb17100db28d5c377d3d215277289e06"
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
