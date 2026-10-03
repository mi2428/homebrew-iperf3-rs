class Iperf3Rs < Formula
  desc "Rust API for libiperf with live iperf3 metrics export"
  homepage "https://github.com/mi2428/iperf3-rs"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.4/iperf3-rs-aarch64-apple-darwin.tar.xz"
      sha256 "517d3886b36fe8f5c6328a55de4cc49f4be10221248a20f01e7a4e559bbfc95b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.4/iperf3-rs-x86_64-apple-darwin.tar.xz"
      sha256 "82bb1b0129ecb0bd7567598b694dbd14e383394948253fd7bea438b84822a222"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.4/iperf3-rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "312d4f5028ea89f9221a5f4939ed27057b8ae44a79fbe19aed9352c24e51782d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mi2428/iperf3-rs/releases/download/v1.0.4/iperf3-rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "54d902de2e6c778b21bd83de773b8ed5bf410b9cac12575cff512c18dc1b9acb"
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
