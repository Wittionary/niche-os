{
  pkgs,
  ...
}: {

  imports = [
    ./global # Gotta get the basics
  ];
  
  programs.kitty = {
    themeFile = "Doom_One";
  };
}