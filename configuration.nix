# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;  # Enables all SysRq functions
    "vm.swappiness" = 180;
    "vm.admin_reserve_kbytes" = 131072;
  };
  boot.kernelParams = [ 
    "intel_iommu=on"
    "iommu=pt"
  ];
  #
  # boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
  #
  boot.extraModprobeConfig = ''
    options kvm ignore_msrs=1
  '';
  
  # NixSettings.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = false;
 
  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;


  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;

  zramSwap.enable = true;
  
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  
  #Nvidia 
  
  hardware.nvidia = {

    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  
  # CustomSystemdServices 
  
  systemd.user.services.novideo = {
	name = "nonvidsett";
	description = "nvidia-settings apply";
	enable = true;
	serviceConfig = {
    Type = "oneshot";
  };
  script = '' ${config.hardware.nvidia.package.settings}/bin/nvidia-settings --load-config-only '';
  after = [ "graphical-session.target" ];
  wantedBy = [ "graphical-session.target" ];
};

  systemd.services."libvirt-net-default" = {
  wantedBy = [ "multi-user.target" ];
  serviceConfig = {
    Type = "oneshot";
    ExecStart = "/run/current-system/sw/bin/virsh net-autostart default";
    RemainAfterExit = true;
  };
};

###################################

  hardware.graphics.extraPackages = with pkgs; [ nvidia-vaapi-driver ];


  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = [

     # Google
      "8.8.8.8"
      "8.8.4.4"

     # Cloudflare
      "1.1.1.1"
      "1.0.0.1"

    ];

  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  networking.networkmanager.dns = "none";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
 
  services.xserver.displayManager.gdm.enable = true; 
  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;
 
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.einsam = {
    isNormalUser = true;
    description = "Einsam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  fonts.packages = with pkgs; [

  jetbrains-mono
  noto-fonts
  fira-code

  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  
  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  git
  git-filter-repo
  gnome-terminal
  mpv
  btop
  glxinfo
  mesa
  libepoxy
  nix-index
  # virtio-win
  # win-spice
  libarchive
  cdrtools
  ntfs3g
  hdparm
  gnome-themes-extra
  f2fs-tools  
  
  ];
  
  environment.gnome.excludePackages = [   pkgs.geary ];
  
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["einsam"];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.extraConfig = ''
    log_filters="1:libvirt 1:qemu 1:conf 1:security 3:event 3:json 3:file 3:object 1:util"
    log_outputs = "1:file:/tmp/libvirtd.log"
  '';
  virtualisation.libvirtd.qemu.ovmf.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = false;
  virtualisation.libvirtd.qemu.ovmf.packages = [ pkgs.OVMFFull.fd ];
  virtualisation.libvirtd.qemu.runAsRoot = true;
  virtualisation.libvirtd = {
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  virtualisation.libvirtd.qemu.package = pkgs.qemu_full;
  virtualisation.spiceUSBRedirection.enable = true;
  services.spice-vdagentd.enable = true;

  #### environment.etc."X11/xorg.conf".source =
  #### lib.mkIf (builtins.elem "nvidia" config.services.xserver.videoDrivers) ./xorg.conf;
  environment.etc."libvirt/qemu.conf".source = ./qemu.conf;
  
# Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
