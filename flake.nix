# Based on response in sec2 Nix-v2-workflow.md
{
  description = "Benchmarking";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    # --- Local Project Inputs ---
    # Define an input for each scattered local project.
    # Provide a *relative* path as a default or a sensible fallback.
    # The user will override this in their local setup.

    arithmetic_benchmark = {
        url = "git+file:///home/thorb/Code/Sandkasse/Benchmarking/arithmetic";
    };

    memory_benchmark = {
        url = "git+file:///home/thorb/Code/Sandkasse/Benchmarking/memory";
    };

    disk_benchmark = {
        url = "git+file:///home/thorb/Code/Sandkasse/Benchmarking/disk";
    };
  };

  outputs = { self, nixpkgs, flake-utils, arithmetic_benchmark, memory_benchmark, disk_benchmark, ... }@inputs:

    flake-utils.lib.eachDefaultSystem (system:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Your main numerical simulation project itself
      myExperiment = pkgs.stdenv.mkDerivation rec {
        name = "myExperiment";
        version = "git";
        src = self; # The current directory (your main project's Git repo)

        buildInputs = with pkgs; [
          cmake
          gcc
          # Custom libs
          memory_benchmark.packages.${system}.default
          arithmetic_benchmark.packages.${system}.default
          disk_benchmark.packages.${system}.default
        ];
        configurePhase = ''
          cmake -S ${src} -B $out/build -DCMAKE_PREFIX_PATH="arithmetic_benchmark.url;memory_benchmark.url;disk_benchmark.url"
        '';
        buildPhase = ''
          cmake --build $out/build
        '';
        installPhase = ''
          mkdir $out/install && cmake --install $out/build --prefix=$out/install \
          && echo "Out: $out" && echo "lib_b: ${memory_benchmark.packages.${system}.default}" && \
          ln -s ${memory_benchmark.packages.${system}.default} $out/lib_b_install && \
          ln -s ${memory_benchmark} $out/lib_b
        '';
      };

    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          git cmake gcc gdb valgrind
        ];
        buildInputs = [
          # buildarithmetic_benchmark
          # buildmemory_benchmark
          myExperiment # If you want to use the built sim executable directly
          arithmetic_benchmark.defaultPackage.${system}.default
          memory_benchmark.defaultPackage.${system}.default
          disk_benchmark.defaultPackage.${system}.default
        ];
        shellHook = ''
          echo "Welcome to the Nix numerical simulation development environment!"
          echo "All your local dependencies are built and available."
        '';
      };
      packages.default = myExperiment;
    });
}
