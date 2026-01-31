{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell"; # Use same quickshell version
    };
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nix-flatpak,
    lanzaboote,
    noctalia,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/desktop/configuration.nix
        lanzaboote.nixosModules.lanzaboote
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.uli = import ./home/uli;
            backupFileExtension = "backup";
            extraSpecialArgs = {inherit inputs;};
          };
        }
        ./modules/noctalia
      ];
    };
  };
}
