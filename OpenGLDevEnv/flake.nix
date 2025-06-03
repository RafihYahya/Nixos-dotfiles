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
	glad = pkgs.fetchurl {
          url = "https://github.com/RafihYahya/C-EXPLORATIONS/blob/Experimental/MODULES/OPENGL/glad.c";
          sha256 = "sha256-E1FTR0CZuGg/2lnhBDOA/QWUHwzUMnkar+Lu68c5UTQ=";
        };
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
		   echo "Glad.c available at: ${glad}"
		'';

            #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
            #VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            #VULKAN_SDK = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            #XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
            #XDG_RUNTIME_DIR = "/run/user/1000";
        };
    };
}
