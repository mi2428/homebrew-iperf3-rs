# homebrew-iperf3-rs

Homebrew tap for [iperf3-rs](https://github.com/mi2428/iperf3-rs).

```sh
brew tap mi2428/iperf3-rs
brew install iperf3-rs
```

Before the first [release](https://github.com/mi2428/iperf3-rs/releases) publishes a stable binary formula, install from the main branch:

```sh
brew install --HEAD iperf3-rs
```

The stable formula is maintained by the [release workflow](https://github.com/mi2428/iperf3-rs/blob/main/.github/workflows/release.yml).
Publishing a GitHub Release in [`mi2428/iperf3-rs`](https://github.com/mi2428/iperf3-rs) generates a formula that points at that release's binary assets, verifies their SHA-256 checksums, and pushes [`Formula/iperf3-rs.rb`](Formula/iperf3-rs.rb) to this tap.
