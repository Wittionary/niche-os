{
  pkgs,
  ...
}:
{

  imports = [
    ./global # Gotta get the basics
  ];

  services.spotifyd = {
    settings = {
      # https://docs.spotifyd.rs/config/File.html#configuration-file
      global = {
        device_name = "starmachine"; # TODO: replace with variable
      };
    };
  };
}
