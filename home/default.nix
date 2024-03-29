{ ... }:
{

  imports = [
    ./sh
    ./desktop
    ./lutris.nix
    ./nvim.nix
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
    stateVersion = "23.05";
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
}
