require 'formula'

class Zsh < Formula
  homepage 'http://www.zsh.org/'
  url 'http://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2'
  mirror 'http://www.zsh.org/pub/zsh-5.0.5.tar.bz2'
  sha256 '6624d2fb6c8fa4e044d2b009f86ed1617fe8583c83acfceba7ec82826cfa8eaf'

  depends_on 'gdbm'
  depends_on 'pcre'

  option 'disable-etcdir', 'Disable the reading of Zsh rc files in /etc'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{share}/zsh/functions
      --enable-scriptdir=#{share}/zsh/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
      --enable-etcdir=/etc
    ]

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    system "make install"

    if ENV['HOMEBREW_KEEP_INFO']
      system "make install.info"
    end
  end

  def test
    system "#{bin}/zsh", "--version"
  end

  def caveats; <<-EOS
    Add the following to your zshrc to access the online help:
      unalias run-help
      autoload run-help
      HELPDIR=#{HOMEBREW_PREFIX}/share/zsh/helpfiles
    EOS
  end
end
