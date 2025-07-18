{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/d89fc19e";
    nixpkgs-experimental.url = "github:nixos/nixpkgs/a39ed32a";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixpkgs-unstable
    , nixpkgs-experimental, ... }@inputs:
    let
      system = "x86_64-linux";
      homeStateVersion = "24.11";
      user = "simon";
      hosts = [{
        hostname = "digital_spirit";
        stateVersion = "24.11";
      }];

      # Общая функция для создания overlays
      mkOverlays = system:
        [
          (final: prev: {
            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
            experimental = import inputs.nixpkgs-experimental {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];

      makeSystem = { hostname, stateVersion }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs user hostname stateVersion; };

          modules = [
            ({ config, ... }: {
              # Добавляем overlays в системную конфигурацию
              nixpkgs.overlays = mkOverlays config.nixpkgs.system;
              nixpkgs.config.allowUnfree = true;
            })
            ./hosts/${hostname}/configuration.nix
          ];
        };

    in {
      nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
        configs // {
          "${host.hostname}" =
            makeSystem { inherit (host) hostname stateVersion; };
        }) { } hosts;

      homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = mkOverlays system;
        };
        extraSpecialArgs = { inherit inputs homeStateVersion user; };
        modules = [ ./home-manager/home.nix ];
      };
    };
}
