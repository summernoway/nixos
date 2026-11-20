{
  description = "our media/storage server";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05-small";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vpn-confinement.url = "github:Maroka-chan/VPN-confinement";
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.arceus = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.summer = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
        vpn-confinement.nixosModules.default
      ];
    };
  };
}
