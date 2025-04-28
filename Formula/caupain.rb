class Caupain < Formula
  desc "Your best buddy for keeping versions catalogs up to date!"
  homepage "https://github.com/bishiboosh/caupain"
  url "https://github.com/bishiboosh/caupain/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "9bbd11ce5fde4ccc9d645f340e2f11c305bbb377de9b9a6dfc87d2a69feea61f"
  license "MIT"

  bottle do
    root_url "https://github.com/bishiboosh/homebrew-test/releases/download/caupain-0.1.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eeef011accd3410ca4a1c9332b77a88f8497cb048942a707fd30a5fef762af4"
    sha256 cellar: :any_skip_relocation, ventura:       "83343d0aafc789de402c13eb03e7fd9b5819d168cbc06bedf4683beeb9781784"
  end

  depends_on "openjdk@17" => :build

  def install
    ENV["GRADLE_OPTS"] = '-Dorg.gradle.configureondemand=true \
    -Dkotlin.incremental=false \
    -Dorg.gradle.project.kotlin.incremental.multiplatform=false \
    -Dorg.gradle.project.kotlin.native.disableCompilerDaemon=true \
    -Dorg.gradle.jvmargs="-Xmx12g \
    -Dfile.encoding=UTF-8"'
    task =
      if Hardware::CPU.arm?
        ":cli:macosArm64Binaries"
      else
        ":cli:macosX64Binaries"
      end
    system "./gradlew", task
    folder =
      if Hardware::CPU.arm?
        "macosArm64"
      else
        "macosX64"
      end
    bin.install "cli/build/bin/#{folder}/releaseExecutable/caupain.kexe" => "caupain"
    # bash_completion.install "cli/completions/bash-completions.sh" => "caupain"
    # fish_completion.install "cli/completions/fish-completions.sh"
    # zsh_completion.install "cli/completions/zsh-completions.sh" => "_caupain"
  end

  test do
    system "#{bin}/caupain", "-h"
  end
end
