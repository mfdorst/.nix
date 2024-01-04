{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      firefox
      gimp
      transmission-gtk
    ];

    file = {
      ".config/kitty/kitty.conf".source = ./kitty.conf;
    };
  };

  programs.browserpass.enable = true;

  services.gpg-agent.pinentryFlavor = "qt";
}