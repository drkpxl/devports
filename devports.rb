class Devports < Formula
  desc "Interactive CLI tool for viewing and killing development server processes"
  homepage "https://github.com/stevenhubert/devports"
  url "https://github.com/stevenhubert/devports/archive/v1.0.0.tar.gz"
  sha256 "" # This will be filled in when you create the release
  license "MIT"

  def install
    bin.install "devports"
  end

  test do
    assert_match "devports version 1.0.0", shell_output("#{bin}/devports --version")
    assert_match "Interactive CLI for managing development server processes", shell_output("#{bin}/devports --help")
  end
end