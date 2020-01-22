{ compiler ? null, nixpkgs ? null}:

let
  compilerVersion = if isNull compiler then "ghc864" else compiler;
  haskellPackagesOverlay = self: super: with super.haskell.lib; {
    haskellPackages = super.haskell.packages.${compilerVersion}.override {
      overrides = hself: hsuper: {
        purebred = hsuper.callPackage ./purebred.nix { };
        purebred-email = hsuper.callPackage ./purebred-email.nix { };
        purebred-icu = hsuper.callPackage ./purebred-icu.nix { };
        tasty-tmux = hsuper.callPackage ./tasty-tmux.nix { };
        notmuch = hsuper.callPackage ./hs-notmuch.nix {
          notmuch = self.pkgs.notmuch;
          talloc = self.pkgs.talloc;
        };
      };
    };
  };
  pkgSrc =
    if isNull nixpkgs
    then
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/5d6da42cf793cd194cf31bca7193926e7752e51e.tar.gz";
      sha256 = "1hxghqs31f75rc2p059zfvzkcg41jmhqhpsad42cm2rqf5vj4khz";
    }
    else
    nixpkgs;
in
  import pkgSrc { overlays = [ haskellPackagesOverlay ]; }
