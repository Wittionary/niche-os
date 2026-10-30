# This module contains all the config needed to be a llama (LLM) server
# A LLAMA? HE'S SUPPOSED TO BE DEAD!
{...}:{

  # https://search.nixos.org/options?channel=unstable&query=llama-cpp&type=options#show=option%253Aservices.llama-cpp.settings
  services.llama-cpp = {
    enable = true;
    openFirewall = true;
    settings = {
      port = 9931;
    };
  };
}
