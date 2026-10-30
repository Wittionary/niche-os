{...}:{

  # https://search.nixos.org/options?channel=unstable&query=llama-cpp&type=options#show=option%253Aservices.llama-cpp.settings
  services.llama-cpp = {
    enable = true;
    settings = {
      port = 12000;
    };
  };
}
