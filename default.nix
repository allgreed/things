let
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "f2537a505d45c31fe5d9c27ea9829b6f4c4e6ac5"; # 27-06-2022
    # obtain via `git ls-remote https://github.com/nixos/nixpkgs nixos-unstable`
  };
  pkgs = import nixpkgs { config = {}; };
in
pkgs.mkShell {
  buildInputs =
  with pkgs;
  [
    git
    gnumake
    openscad
  ];
}
