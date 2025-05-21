{ config, pkgs, ... }:

{

  home.username = "einsam";
  home.homeDirectory = "/home/einsam";

  home.packages = with pkgs; [

  neofetch
  nnn
  sysstat
  pciutils
 #  (blender.override {
 #   cudaSupport = true;
 #  })
  ];

  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
  #gtk.enable = true;  
  #gtk.gtk3.extraCss = ''
  #		window.ssd headerbar * {
  #		 margin-top: -100px;
  #		}
  #		'';
  #gtk.gtk4.extraCss = ''
  #              window.ssd headerbar * {
  #              margin-top: -100px;
  #             }
  #             '';

}
