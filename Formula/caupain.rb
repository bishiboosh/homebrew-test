class Caupain < Formula
  desc "Your best buddy for keeping versions catalogs up to date!"
  homepage "https://github.com/bishiboosh/caupain"
  url "https://github.com/bishiboosh/caupain/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9bbd11ce5fde4ccc9d645f340e2f11c305bbb377de9b9a6dfc87d2a69feea61f"
  license "MIT"

  depends_on "openjdk" => :build

  def install
    system "./gradlew", (OS.mac?) ? ((Hardware::CPU.arm?) ? ":cli:macosArm64Binaries" : ":cli:macosX64Binaries") : "cli:linuxX64Binaries"
    bin.install "cli/build/#{(OS.mac?) ? ((Hardware::CPU.arm?) ? "macosArm64" : ":macosX64") : "linuxX64"}/releaseExecutable/caupain.kexe" => "caupain"
    bash_completion.install "cli/completions/bash-completions.sh" => "caupain"
    fish_completion.install "cli/completions/fish-completions.sh"
    zsh_completion.install "cli/completions/zsh-completions.sh" => "_caupain"
  end

  test do
    system "#{bin}/caupain", "-h"
  end
end
