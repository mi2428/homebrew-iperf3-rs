class Iperf3Rs < Formula
  desc "Rust API for libiperf with live iperf3 metrics export"
  homepage "https://github.com/mi2428/iperf3-rs"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-aarch64-apple-darwin.tar.xz"
      sha256 "ed4696aee6b1641e05c40133bb2373a4d99aa96dfff6091bb71b29e73f06f9d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-x86_64-apple-darwin.tar.xz"
      sha256 "b4dd9d29233229959c2e49e57d7c2866e9c46e67f32650a0f329d0f532dfae4f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0346d65fadc9c77dcd1ee54416fa866fdd1cc3cdd48b174c146e3e3ef5da0a0b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.3/iperf3-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bfe3ee9e094d45d85bd9178b388383591816808ed8086b9b8bdcec5106c510fe"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "iperf3-rs"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "iperf3-rs"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "iperf3-rs"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "iperf3-rs"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/iperf3-rs --version")
  end
end
