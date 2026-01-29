{ stdenv, fetchFromGitHub }:
{
  sddm-theme-dialog = stdenv.mkDerivation rec {
    pname = "sddm-theme-dialog";
    version = "53f81e3";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sddm-theme-dialog
    '';
    src = fetchFromGitHub {
      owner = "joshuakraemer";
      repo = "sddm-theme-dialog";
      rev = "53f81e322f715d3f8e3f41c38eb3774b1be4c19b";
      sha256 = "qoLSRnQOvH3rAH+G1eRrcf9ZB6WlSRIZjYZBOTkew/0=";
    };
  };

  sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "+R0PX84SL2qH8rZMfk3tqkhGWPR6DpY1LgX9bifNYCg=";
    };
  };

  where-is-my-sddm-theme = stdenv.mkDerivation rec {
    pname = "where-is-my-sddm-theme";
    version = "1.12.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/where-is-my-sddm-theme
    '';
    src = fetchFromGitHub {
      owner = "stepanzubkov";
      repo = "where-is-my-sddm-theme";
      rev = "v${version}";
      sha256 = "+R0PX84SL2qH8rZMfk3tqkhGWPR6DpY1LgX9bifNYCg=";
    };
  };
}
