with import <nixpkgs> {};

let
	unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

in pkgs.mkShell rec{
	buildInputs = [
		python311Packages.matplotlib
		unstable.julia-bin
	];

	shellHook = ''
		exec zsh
	'';
}
