{ config, lib, pkgs, ... }: {
  imports = [
    ./arch.nix
    ./cinnamon.nix
    ./gnome.nix
    ./hyprland.nix
    ./minecraft.nix
    ./mysql.nix
    ./nextcloud-server.nix
    ./nvidia.nix
    ./plasma5.nix
    ./sound.nix
    ./steam.nix
    ./tailscale.nix
  ];

  options.my = { sops = lib.my.mkEnableOption false; };

  config = lib.mkMerge [
    {
      users.users.me = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        openssh.authorizedKeys.keys = import ../common/ssh-keys.nix;
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

      programs.zsh.enable = true;
      users.defaultUserShell = pkgs.zsh;
      environment.binsh = "${pkgs.dash}/bin/dash";

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
        kernelModules = [ "kvm-${config.my.cpu}" ];
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 20;
          };
          efi.canTouchEfiVariables = true;
        };
      };

      swapDevices = lib.mkDefault [{
        device = "/var/lib/swapfile";
        # In megabytes
        size = 10 * 1024;
      }];

      hardware = {
        enableRedistributableFirmware = true;
        cpu."${config.my.cpu}".updateMicrocode = true;
      };

      nixpkgs = {
        config.allowUnfree = true;
        hostPlatform = config.my.arch;
      };

      time.timeZone = "America/Los_Angeles";

      nix.settings.experimental-features = [ "nix-command" "flakes" ];
    }
    (lib.mkIf config.my.sops.enable {
      environment.systemPackages = with pkgs; [ age sops ];
      sops.age.keyFile = "/home/me/.config/sops/age/keys.txt";
    })
  ];
}
