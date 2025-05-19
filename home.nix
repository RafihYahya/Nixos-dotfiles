{ config, pkgs, lib, ... }:

{

  home.username = "einsam";
  home.homeDirectory = "/home/einsam";

  home.packages = with pkgs; [

  neofetch
  qbittorrent-enhanced
  nnn
  sysstat
  pciutils
  browsh
  #rustc
  #cargo
 
  #haskell.compiler.ghc98
  #haskellPackages.cabal-install
  #haskellPackages.haskell-language-server
 #
 #  (blender.override {
 #   cudaSupport = true;
 #  })
 #
  ];
  
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.

  programs.home-manager.enable = true;

################################################
  
 programs.git.enable = true;
 programs.git.userName = "rafihyahya";
 programs.git.userEmail = "rafihyahya@gmail.com";
 
#################################################
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscodium;
  programs.vscode.profiles.default.userSettings = {
    "editor.fontLigatures" = true;
    "editor.fontFamily" = "JetBrains Mono";
    "editor.fontSize" = 15;
    "editor.fontWeight" = "500";
    };
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [

   usernamehw.errorlens
   pkief.material-icon-theme
   rust-lang.rust-analyzer
  ];

##################   
  gtk = {
      enable = true ;
      theme = {
        name = "Adwaita" ;
        package = null;
        };
      gtk3.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
       };
      ### gtk4.extraConfig = { "gtk-application-prefer-dark-theme" = true; };
      };


  dconf.settings = {
	"org/gnome/desktop/input-sources" = {
          sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
          xkb-options = [ ];
        };
       "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark"; 
       };
    };


}
