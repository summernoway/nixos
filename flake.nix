{
  description = "multihost nixos config for systems at home";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05-small";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    vpn-confinement.url = "github:Maroka-chan/VPN-confinement";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, home-manager-unstable, vpn-confinement, ... }: {
    nixosConfigurations.arceus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/arceus/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.summer = import ./hosts/arceus/home.nix;
            backupFileExtension = "backup";
          };
        }
        vpn-confinement.nixosModules.default
      ];
    };

    nixosConfigurations.lugia = nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/lugia/configuration.nix
        home-manager-unstable.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.summer = import ./hosts/lugia/home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
