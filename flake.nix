{
  description = "Nix package for Task Manager TMOG";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfreePredicate = pkg:
              nixpkgs.lib.getName pkg == "tmog";
          };

          version = "0.1.4";
          src = pkgs.fetchurl {
            url = "https://tmog.org/downloads/TaskManagerOG-${version}-x86_64.AppImage";
            hash = "sha256-qYczR+4rGkiVzyyPOWYNjPS4aribJMCNVB8jfjZbQ0Y=";
          };
          appimageContents = pkgs.appimageTools.extract {
            pname = "tmog";
            inherit version src;
          };
        in {
          tmog = pkgs.appimageTools.wrapType2 {
            pname = "tmog";
            inherit version src;

            extraInstallCommands = ''
              install -Dm444 \
                ${appimageContents}/com.tmog.taskmanager.desktop \
                $out/share/applications/com.tmog.taskmanager.desktop
              substituteInPlace \
                $out/share/applications/com.tmog.taskmanager.desktop \
                --replace-fail "Exec=tmog-task-manager" "Exec=tmog"
              install -Dm444 \
                ${appimageContents}/usr/share/pixmaps/tmog-task-manager.png \
                $out/share/pixmaps/tmog-task-manager.png
            '';

            meta = {
              description = "Native system monitor and task manager by Dave Plummer";
              homepage = "https://tmog.org/";
              license = pkgs.lib.licenses.unfree;
              mainProgram = "tmog";
              platforms = [ "x86_64-linux" ];
              sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
            };
          };

          default = self.packages.${system}.tmog;
        });

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.tmog}/bin/tmog";
          meta.description = "Launch Task Manager TMOG";
        };
      });
    };
}
