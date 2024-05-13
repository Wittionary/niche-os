{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "gruvbox-plus";

  src = pkgs.fetchUrl {
    url = "https://github.com/SylEleuth/gruvbox-plus-icon-pack/releases/download/v5.3.1/gruvbox-plus-icon-pack-5.3.1.zip";
    sha256 = "1mi6197hrwnkm2109pajb3vkwlddrak109281dbwgl1gagklsxny"; # pkgs.lib.fakeSha256 or nix-prefetch-url
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -P $out
    ${pkgs.unzip}/bin/unzip $src -d $out/
    '';
}