class Iperf3Rs < Formula
  desc "Rust frontend for libiperf with live Pushgateway export"
  homepage "https://github.com/mi2428/iperf3-rs"
  license "MIT"
  head "https://github.com/mi2428/iperf3-rs.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "git", "submodule", "update", "--init", "--recursive"

    ENV["IPERF3_RS_CONFIGURE_ARGS"] = "--without-openssl"
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/iperf3-rs.bash" => "iperf3-rs"
    zsh_completion.install "completions/_iperf3-rs"
    fish_completion.install "completions/iperf3-rs.fish"
  end

  test do
    assert_match "iperf3-rs", shell_output("#{bin}/iperf3-rs --version")
  end
end
