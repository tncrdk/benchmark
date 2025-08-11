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
        url = "git+https://github.com/tncrdk/arithmetic.git";
    };

    memory_benchmark = {
        # url = "git+file:///home/thorb/Code/Sandkasse/Benchmarking/memory";
        url = "git+https://github.com/tncrdk/memory.git";
    };

    disk_benchmark = {
        url = "git+https://github.com/tncrdk/disk.git";
    };

    parallel_benchmark = {
        url = "git+https://github.com/tncrdk/parallel.git";
    };
  };

  outputs = { self, nixpkgs, flake-utils, arithmetic_benchmark, memory_benchmark, disk_benchmark, parallel_benchmark, ... }@inputs:

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
          parallel_benchmark.packages.${system}.default
        ];
        cmakeFlags = [
          "-DCMAKE_BUILD_TYPE=Release"
          # Does not seem to need this
          # "-DCMAKE_PREFIX_PATH='arithmetic_benchmark.url;memory_benchmark.url;disk_benchmark.url;parallel_benchmark.url'"
        ];
        configurePhase = ''
          cmake -S ${src} -B $out/build --debug-find
        '';
        buildPhase = ''
          cmake --build $out/build
        '';
        installPhase = ''
          mkdir $out/install && cmake --install $out/build --prefix=$out/install
          runHook postInstall
        '';
        postInstall = ''
          mkdir -p $out/lib
          ln -s ${arithmetic_benchmark} $out/lib/arithmetic
          ln -s ${disk_benchmark} $out/lib/disk
          ln -s ${memory_benchmark} $out/lib/memory
          ln -s ${parallel_benchmark} $out/lib/parallel
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
          parallel_benchmark.defaultPackage.${system}.default
        ];
        shellHook = ''
          echo "Welcome to the Nix numerical simulation development environment!"
          echo "All your local dependencies are built and available."
        '';
      };
      packages.default = myExperiment;
    });
}
