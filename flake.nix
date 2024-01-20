{
  description = "Nixos config flake";

  inputs = {
    # stable system channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # unstable for bleeding edge packages
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, unstable, home-manager,... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
	modules = [
          ./hosts/configuration.nix
	  home-manager.nixosModules.default
	];
      };
    };
}
