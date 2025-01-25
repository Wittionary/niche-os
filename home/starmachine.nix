{
  pkgs,
  ...
}: {

  imports = [
    ./global # Gotta get the basics
  ];
  
  programs.kitty = {
    theme = "Doom One";
  };
}