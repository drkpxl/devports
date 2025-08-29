class Devports < Formula
  desc "Interactive CLI tool for viewing and killing development server processes"
  homepage "https://github.com/drkpxl/devports"
  url "https://github.com/drkpxl/devports/archive/v1.0.0.tar.gz"
  sha256 "57240fc045e83bb6df823f81a5e5d05db77183de3b149d2a5521cdefa03c5aaa"
  license "MIT"

  depends_on "bash"

  def install
    bin.install "devports"
  end

  test do
    assert_match "devports version 1.0.0", shell_output("#{bin}/devports --version")
    assert_match "Interactive CLI for managing development server processes", 
                 shell_output("#{bin}/devports --help")
  end
end