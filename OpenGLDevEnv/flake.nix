{
    description = "Vulkan Dev Flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }@inputs:
    let
        lib = nixpkgs.lib;
        pkgs = import inputs.nixpkgs {
            system = "x86_64-linux";
        };
	#glad = pkgs.fetchurl {
        #  url = "https://raw.githubusercontent.com/RafihYahya/C-EXPLORATIONS/Experimental/MODULES/OPENGL/glad.c";
        #  sha256 = "sha256-w34N9MmArTTAVj3tmZWrwq77Ho1SIgt7N0rxCJBnj64=";
        #};
    in
        {
        devShells.x86_64-linux.default = pkgs.mkShell rec {
            name = "OpenGl Env";
            nativeBuildInputs = with pkgs;[ gcc gdb wget ];

            buildInputs = with pkgs;[
                libxkbcommon
                libGL
		libGLU
                glm
                pkg-config
                xorg.libX11
                xorg.libXrandr
                xorg.libXcursor
                xorg.libXi
                xorg.libXxf86vm
                glfw glfw3
                glslang
            ];

            shellHook = ''
		
		'';

            #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
            #XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
            #XDG_RUNTIME_DIR = "/run/user/1000";
        };
    };
}
