{ config, pkgs, ... }:

let 
     CurrentGPUVm = [ "ThoriumOSGPU" ];


     vmSpecificScripts = map (vmName: 
     ''
      # Copy hook files
       	mkdir -p /var/lib/libvirt/hooks/qemu.d/${vmName}/{prepare/begin,release/end}
	cp /etc/nixos/libvirtSPGpu/start.sh /var/lib/libvirt/hooks/qemu.d/${vmName}/prepare/begin/
	cp /etc/nixos/libvirtSPGpu/stop.sh  /var/lib/libvirt/hooks/qemu.d/${vmName}/release/end/
       
        chmod +x /var/lib/libvirt/hooks/qemu.d/${vmName}/prepare/begin/start.sh
        chmod +x /var/lib/libvirt/hooks/qemu.d/${vmName}/release/end/stop.sh
      ''
     ) CurrentGPUVm;
     vmGeneralScript = ''
        cp  /etc/nixos/libvirtSPGpu/qemu /var/lib/libvirt/hooks/
        chmod 755 /var/lib/libvirt/hooks
        # Make them executable
        chmod +x /var/lib/libvirt/hooks/qemu
        ${(builtins.concatStringsSep "\n" vmSpecificScripts)}
        chgrp -R libvirtd /var/lib/libvirt/hooks
     '';
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
 systemd.services.libvirtd.preStart = vmGeneralScript;

}
