# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include home-manager
      inputs.home-manager.nixosModules.default
    ];

  # Use the grub boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.timeoutStyle = "menu";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 120;
  boot.kernelParams = [ "nohibernate" ];
  boot.tmp.cleanOnBoot = true;
 
  # Networking.
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;  

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8"; 
  console = {
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  
  # Configure display manager
  services.xserver.displayManager.lightdm.enable = true;  
  services.xserver.displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --mode 2560x1440 --rate 164.83";

  # Configure window manager
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm.override {
    patches = [
     (pkgs.fetchpatch {
       url = "https://dwm.suckless.org/patches/uselessgap/dwm-uselessgap-20211119-58414bee958f2.diff";
       hash = "sha256-cWDTOtKZXCSFpZuDfKeXb8jA9UMZ28mowlRvMA8G+us=";
     })
    ];
  };

  # Enable picom compositor.
  services.picom.enable = true;
  
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.obin = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Configure home-manager
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.obin = import ./home.nix;
  };
   
  # Enable flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    st
    git
    tldr
    rofi
    xclip
    dmenu
    dunst
    nodejs
    lazygit
    firefox
    swaycons
    xfce.thunar
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
    xorg.xinput
    polkit_gnome
    xdg-desktop-portal
    nvidia-docker
    docker-compose
    # Install unstable r2modman
    inputs.unstable.legacyPackages."${pkgs.system}".r2modman
  ];
	
  # Set default shell for all users
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  
  # Add zsh to /etc/shells
  environment.shells = [ pkgs.zsh ];

  # Configure steam
  programs.steam.enable = true;
  programs.steam.remotePlay.openFirewall = true;

  # Enable docker
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;

  # Configure XDG portal
  xdg.portal.enable = true;
  xdg.portal.config.common.default = "*";
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal ];
  
  # List services that you want to enable
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
	ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
	Restart = "on-failure";
	RestartSec = 1;
	TimeoutStopSec = 10;
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable OpenGl
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Load nvidia driver for xorg and wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable coolbits for OC
  services.xserver.deviceSection = ''
    Option "Coolbits" "8"
  '';

  # Configure nvidia
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

