# Edit this configuration file to define what should be installed on your system. Help is 
# available in the configuration.nix(5) man page, on https://search.nixos.org/options and in the 
# NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  boot.loader.efi.canTouchEfiVariables = true;


  # Use latest kernel.
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_lqx;
  # Kernel Params
  boot.kernelParams = [ 
    "mitigations=off" "intel_iommu=on"
  ];
   
  hardware.graphics.enable = true;
 
  # Sysctl
  
  boot.kernel.sysctl = {
  
  # VM tuning
  "vm.swappiness" = 100;
  "vm.dirty_ratio" = 40;
  "vm.dirty_background_ratio" = 20;
  "vm.vfs_cache_pressure" = 50;
  "kernel.core_pattern" = "|/bin/false";
  # Overcommit settings
  #"vm.overcommit_memory" = 1;

  # File system tuning
  #"fs.file-max" = 1000000;  # Max number of open files
 
   };
  #services.preload.enable = true;
  #Zram
  zramSwap = {
	enable = true;
	memoryPercent = 250;
 	algorithm = "lz4";
  };

  #PowerManagement
  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  #powerManagement.cpufreq.min = 2200000;

  #
  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  networking.networkmanager.dns = "none";
   networking.nameservers = [
   "8.8.8.8" "8.8.4.4"
	"1.1.1.1" "1.0.0.1"
];

  # Set your time zone.
   time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
   services.xserver.enable = true;
   services.xserver.desktopManager.lxqt.enable = true;
   services.displayManager.sddm.enable = true;
   services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --gamma 0.45";
   
   xdg.portal.lxqt.enable = true;
   xdg.portal.lxqt.styles = [
     pkgs.kdePackages.breeze
   ];

   qt.platformTheme = "gnome";

  # Configure keymap in X11
   services.xserver.xkb.layout = "us";
   services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
   };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.einsam = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
   };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     vim neovim nixos-rebuild-ng # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget curl xorg.xrandr flameshot libGL libGLU gdb gcc glfw3  
     chromium kdePackages.falkon nixos-option strace neofetch
     networkmanagerapplet glfw glm rustc cargo ghc btop retroarch-free
     vscodium kdePackages.okular kdePackages.kate p7zip libreoffice-qt6
     mpv texliveFull papirus-icon-theme mesa mesa-demos blender
     gnome-themes-extra qbittorrent-enhanced gimp3-with-plugins
     pciutils  hdparm  wineWowPackages.full winetricks krita
   ] ++ (with pkgs.nixos-artwork.wallpapers; [ binary-black simple-dark-gray ]) ;
   fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
   ];
  
  environment.variables = {
     QT_STYLE_OVERRIDE = "fusion";
   };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;
   services.openssh.settings.X11Forwarding = true;
   /*
   services.avahi = {
	enable = true;
	nssmdns4 = true;
	openFirewall = true;
	publish.enable = true;
   };
   */
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
	/home/einsam/NFS 192.168.1.0/24(rw,async,no_subtree_check,no_root_squash)
	/home/einsam/NFS 10.0.0.20(rw,async,no_subtree_check,no_root_squash)
  '';
  networking.interfaces.enp3s0.useDHCP = false;
  networking.interfaces.enp3s0.ipv4.addresses = [{
  	address = "10.0.0.10";
	prefixLength = 24;
  }];
  #
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["einsam"];
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full ;
  virtualisation.spiceUSBRedirection.enable = true;

  
  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 22 2049  ];
   networking.firewall.allowedUDPPorts = [ 22 2049  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
   system.copySystemConfiguration = true;
   nixpkgs.config.allowUnfree = true;
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}



# Common lxqt used theme

# adwaita-dark gtk2/3 // breeze-dark for qt apps // fusion with panel Leech theme and graphite theme pallete// 
# darkpastels for qterminal // Onyx for openbox // papirus icons // nerdfont-jetbrains-mono // breeze cursor
