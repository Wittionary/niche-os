{
  description = "Your new nix config";

  inputs = { # "inputs" defines all the dependencies of this flake
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # hosts file provider - https://github.com/StevenBlack/hosts#nix-flake
    hosts.url = "github:StevenBlack/hosts/master";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hosts,
    nixos-hardware,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Yoga laptop - mainly for nixOS development
      snowmachine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        # > Our main nixos configuration file <
        modules = [
          ./hosts/snowmachine
          hosts.nixosModule
        ];
      };

	    # PC desktop
      starmachine = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [ 
          ./hosts/starmachine
          # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-gpu-nvidia-nonprime # the real graphics card
          nixos-hardware.nixosModules.common-pc
          # nixos-hardware.nixosModules.common-pc-ssd # not sure if needed
          # nixos-hardware.nixosModules.common-hidpi # not sure if needed
        ];
      };

      # WSL terminals
      stormtrooper = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [ ./hosts/stormtrooper ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Yoga laptop - mainly for nixOS development
      "witt@snowmachine" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/global
          ./home/snowmachine.nix
        ];
      };

      # PC Desktop
      "witt@starmachine" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pk>
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/global
          ./home/starmachine.nix
        ];
      };

      # WSL terminals
      "witt@stormtrooper" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home/global
          ./home/stormtrooper.nix
        ];
      };
    };
  };
}
