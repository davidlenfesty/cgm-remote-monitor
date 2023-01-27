{
  description = "Nightscout remote CGM service";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs"; };

  outputs = {self, nixpkgs} :
    let 
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      buildNpmPackage = pkgs.buildNpmPackage.override { nodejs = pkgs.nodejs-16_x;};


      # OOF, currently stuck on this not building because of npm issues
      webpack-command = pkgs.buildNpmPackage rec {
        pname = "webpack-command";
        version = "0.5.1";
        npmDepsHash = "sha256-ifBybsZrtg03BK07EoG2/Oi+CF6BDouVPJuSroOI+GA=";

        npmPackFlags = [ "--ignore-scripts" ];
        # Didn't work
        #makeCacheWritable = true;
        #npmFlags = [ "--legacy-peer-deps" ];

        src = pkgs.fetchFromGitHub {
          owner = "shellscape";
          repo = "webpack-command";
          rev = "v${version}";
          hash = "sha256-PRrbTSjV3Va01bouqIUGVqIf5T19rJ0T7lCIvkyl2uA=";
        };
      };
    in {
        packages.x86_64-linux.nightscout = buildNpmPackage rec {
          pname = "nightscout";
          version = "14.2.6";
          npmDepsHash = "sha256-TyMmqTZiE7fBdBkDGQBzUIQtGsmFK7REDhL+31h/ZvU=";

          # I think this is hacky? not the same version of node?
          nativeBuildInputs = [webpack-command];

          npmPackFlags = [ "--ignore-scripts" ];

          #src = builtins.fetchGit {
          #  url = ./.;
          #  rev = "a09e586b95065d502390475bb4ec415f95c7eff5";
          #  allRefs = true;
          #};

          src = pkgs.fetchFromGitHub {
            owner = "nightscout";
            repo = "cgm-remote-monitor";
            rev = "14.2.6";
            hash = "sha256-1uAoqQd/F0sNH/hbztoLR4au8PmCgldP3Rb6OlvVrq4=";
          };
      };
    };
}
