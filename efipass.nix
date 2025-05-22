{ config, pkgs, ... }:

let 
     CurrentGPUVm = "PuppyLinux";

in 
{

  boot.kernelModules = [ 
  "vfio_pci"
  "vfio"
  "vfio_iommu_type1"
  "vfio_virqfd"

  "nvidia"
  "nvidia_modeset"
  "nvidia_uvm"
  "nvidia_drm"
];


 # virtualisation.libvirtd.hooks.qemu = {};
 
 systemd.services.libvirtd = {
    path = let
             env = pkgs.buildEnv {
               name = "qemu-hook-env";
               paths = with pkgs; [
                 bash
                 libvirt
                 kmod
                 systemd
                 libvirt
                 ripgrep
		 sd
               ];
             };
           in
           [ env ];

}; 
 systemd.services.libvirtd.preStart = ''
   # Copy hook files
   cp -rf /etc/nixos/libvirtSPGpu/${CurrentGPUVm} /var/lib/libvirt/hooks/qemu.d
   cp     /etc/nixos/libvirtSPGpu/qemu /var/lib/libvirt/hooks/
   chmod 755 /var/lib/libvirt/hooks

   # Make them executable
   chmod +x /var/lib/libvirt/hooks/qemu
   chmod +x /var/lib/libvirt/hooks/qemu.d/${CurrentGPUVm}/prepare/begin/start.sh
   chmod +x /var/lib/libvirt/hooks/qemu.d/${CurrentGPUVm}/release/end/stop.sh

   # Change their groups
   chgrp -R libvirtd /var/lib/libvirt/hooks
'';

}
