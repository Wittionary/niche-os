{pkgs, ...}:{

  environment.systemPackages = with pkgs; [

    github-runner
  ];

  services.github-runners = {
    home-services = {
      enable = true;
      name = "home-services";
      tokenType = "access";
      tokenFile = "/run/secrets/github-runner/nixos.token";
      url = "https://github.com/wittionary/home-infra";
      extraPackages = [];
    };
  };
}
