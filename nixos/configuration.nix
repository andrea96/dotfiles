{ config, pkgs, lib, ... }:

let 
  user = import ./user.nix;
  sources = import ./sources.nix;
in
{
 
  imports = builtins.filter builtins.pathExists [
    sources.home-manager
    /etc/nixos/hardware-configuration.nix
  ];
  
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
 
  networking.hostName = user.hostname;
 
  nixpkgs.config = {
    allowUnfree = true;
  };

  networking.dhcpcd.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  time.timeZone = "Europe/Rome";

  fonts.fonts = with pkgs; [
    source-code-pro
    fira-code
    fira-code-symbols
  ];

  environment.systemPackages = with pkgs; [ 
    vim
    git
    xorg.xorgserver
    xorg.xf86inputevdev
    xorg.xf86videointel
  ];

  services = {
    openssh.enable = true;
    
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      
      #enable = true;
      #videoDrivers = ["intel"];
      #desktopManager.xterm.enable = false;
      #displayManager = {
        #session = [
          #{
            #manage = "desktop";
            #name = "custom";
            #start = "${pkgs.emacsWithPackagesFromUsePackage { config = builtins.readFile ../dotfiles/emacs/init.el; }}/bin/emacsclient -c";
          #}
        #];
        #lightdm.enable =true;
      #};
      #windowManager.default = "custom";
    };

    mingetty.autologinUser = user.username;
    
    emacs = {
      enable = true;
      package = import ./custom-pkgs/emacs.nix { pkgs=pkgs; };
      #package = (pkgs.emacsWithPackagesFromUsePackage {
      #  config = builtins.readFile ../dotfiles/emacs/init.el;
      #});
    };
  };
  
  users.extraUsers.${user.username} = {
    home = "/home/${user.username}";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ];
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home-manager.users.${user.username} = args: import ./home.nix (args // { inherit pkgs user; });

  nixpkgs.overlays = [
    (import sources.emacs-overlay)
    (import sources.custom-overlay)
  ];

  system.stateVersion = "20.09";

}  
