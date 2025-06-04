# typed: false
# frozen_string_literal: true

class Benchi < Formula
  desc "Benchmarking tool for data pipelines"
  homepage "https://github.com/ConduitIO/benchi"
  url "https://github.com/ConduitIO/benchi/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "c97fc9f2e2fac7be61e9e9c2282e7ee1c9a5da78c3d6c10e40c472b1e79168ab"
  license "Apache-2.0"
  head "https://github.com/ConduitIO/benchi.git", branch: "main"


  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/benchi"
    bin.install "benchi"
  end

  test do
    # Create a simple config file for testing
    (testpath/"config.yaml").write <<~EOS
      name: test-benchmark
      iterations: 1
      pipeline:
        source:
          type: generator
          config:
            records: 1
        processors: []
        destination:
          type: noop
    EOS

    # Run a simple benchmark to test actual functionality
    system "#{bin}/benchi", "run", "--config", testpath/"config.yaml"
  end
end 