class Caupain < Formula
  desc "Your best buddy for keeping versions catalogs up to date!"
  homepage "https://github.com/bishiboosh/caupain"
  url "https://github.com/bishiboosh/caupain/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "66c590f573dca5ce2a5451b850165f89717622436d2836b0cb23fbaecb163a5f"
  license "MIT"

  bottle do
    root_url "https://github.com/bishiboosh/homebrew-test/releases/download/caupain-0.2.0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e4e62e00716709687bfa9c235713fbf3f2e31883ca6627d4f6fbff52afe8806"
    sha256 cellar: :any_skip_relocation, ventura:       "04d6e5915331e6d897cdca399a923bb649ca31246bc156b30c3bb741f0d6a792"
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
    system "./gradlew", task, "--no-configuration-cache"
    folder =
      if Hardware::CPU.arm?
        "macosArm64"
      else
        "macosX64"
      end
    bin.install "cli/build/bin/#{folder}/releaseExecutable/caupain.kexe" => "caupain"
    bash_completion.install "cli/completions/bash-completion.sh" => "caupain"
    fish_completion.install "cli/completions/fish-completion.sh"
    zsh_completion.install "cli/completions/zsh-completion.sh" => "_caupain"
  end

  test do
    resource "testcatalog" do
      url "https://raw.githubusercontent.com/bishiboosh/caupain/refs/heads/main/cli/tests/libs.versions.toml"
      sha256 "0438c2ab962721021790e4fea4ead214b91c5019119593a801c9da562ae374ac"
    end
    resource("testcatalog").stage do
      shell_output("#{bin}/caupain --verbose -i libs.versions.toml")
    end
  end
end
