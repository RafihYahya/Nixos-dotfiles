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
    in
        {
        devShells.x86_64-linux.default = pkgs.mkShell rec {
            name = "Test Env";
            nativeBuildInputs = with pkgs;[];

            buildInputs = with pkgs;[
                libxkbcommon
                libGL
                glm
                pkg-config
                xorg.libX11
                xorg.libXrandr
                xorg.libXcursor
                xorg.libXi
                xorg.libXxf86vm
                glfw
                glslang
                renderdoc
                spirv-tools
                vulkan-volk
                vulkan-tools
                vulkan-loader
                vulkan-headers
                vulkan-validation-layers
                vulkan-tools-lunarg
                vulkan-extension-layer
            ];

            shellHook = ''
		  echo "Welcome to my Vulkan Shell"
		  echo "vulkan loader: ${pkgs.vulkan-loader}"
		  echo "vulkan headers: ${pkgs.vulkan-headers}"
		  echo "validation layer: ${pkgs.vulkan-validation-layers}"
		  echo "tools: ${pkgs.vulkan-tools}"
		  echo "tools-lunarg: ${pkgs.vulkan-tools-lunarg}"
		  echo "extension-layer: ${pkgs.vulkan-extension-layer}"
		'';

            #LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
            #VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            #VULKAN_SDK = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            #XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
            #XDG_RUNTIME_DIR = "/run/user/1000";
        };
    };
}
