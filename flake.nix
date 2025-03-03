{
  description = "A very basic flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    recursiveMergeAttrsList = builtins.foldl' (acc: attr: nixpkgs.lib.attrsets.recursiveUpdate acc attr) {};
    forAllSystems = func:
      recursiveMergeAttrsList (builtins.map func [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
      ]);
  in forAllSystems (system: let
    pkgs = import nixpkgs {inherit system;};
    packages = self.packages.${system};
  in {
    packages.${system} = {
      default = packages.barotrauma-modding-tool;
      barotrauma-modding-tool = pkgs.python3Packages.callPackage ./nix {inherit (packages) dearpygui;};
      dearpygui = pkgs.python3Packages.callPackage ./nix/dearpygui.nix {};
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs.python3Packages; [
        packages.dearpygui
        pyinstaller
        colorama
        pyyaml
        requests
        pyperclip
        tkinter
      ];
    };
  });
}
