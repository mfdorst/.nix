{ lib, pkgs, ... }:
{
  imports = [
    ./sh.nix
    ./tailscale.nix
  ];

  users.users.me = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGRZy5DeVFgpAVGG98rYE9goW++AsHIhriELkOAWjuus me@nixos-desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGnz/RaxMk01+oDfSQVdpX2P7vHWVSpbcqhrThd9U88O me@nixos-home-server"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN6rt0HTZ0Ncov1M2rd2uvfEiKpYJmF3/x8bA6QQ+emC me@nixos-laptop"
    ];
  };

  networking.networkmanager.enable = true;

  services = {
    getty.autologinUser = "me";

    openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    printing.enable = true;
  };

  environment.systemPackages = [ pkgs.git ];

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "nvme"
      "sd_mod"
      "usbhid"
      "usb_storage"
      "xhci_pci"
    ];
    kernelModules = [ "kvm-amd" "kvm-intel" ];
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 20;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  swapDevices = lib.mkDefault [
    {
      device = "/var/lib/swapfile";
      # In megabytes
      size = 10*1024;
    }
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  time.timeZone = "America/Los_Angeles";

  hardware.enableRedistributableFirmware = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
