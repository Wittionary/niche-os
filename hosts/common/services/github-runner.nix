{pkgs, ...}:{

  environment.systemPackages = with pkgs; [

    github-runner
  ];

  services.github-runners = {
    home-services = {
      enable = true;
      name = "home-services";
      tokenType = "access";
      tokenFile = "/home/witt/nixos.token";
      url = "https://github.com/wittionary/home-infra";
      extraPackages = [];
    };
  };
}
