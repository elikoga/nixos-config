{ config, pkgs, ... }:

{
  imports =
    [
      ./cachix.nix
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  documentation.dev.enable = true;

  boot.loader.grub.gfxmodeBios = "1280x800";
  boot.loader.grub.gfxpayloadBios = "keep";
  boot.loader.grub.device = "/dev/sda";
  boot.plymouth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.exfat-nofuse
  ];
  networking.hostName = "think-fennec"; # Define your hostname.

  networking.interfaces.wlp3s0.useDHCP = true;
  networking.interfaces.enp0s25.useDHCP = true;

  networking.useDHCP = false;

  boot.kernelPackages = pkgs.linuxPackages_4_9;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_12;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
    ensureUsers = [
      {
        name = "tester";
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
    ];
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE USER tester WITH SUPERUSER PASSWORD 'tester';
      CREATE DATABASE testdb;
      GRANT ALL PRIVILEGES ON DATABASE testdb TO tester;
    '';
  };

  services.mysql.enable = false;
  services.httpd.enable = false;
  services.httpd.enablePHP = true;
  services.httpd.adminAddr = "eli_kogan@yahoo.de";
  services.mysql.package = pkgs.mysql;
  services.httpd.virtualHosts = {
    localhost = {
        documentRoot = "/srv/apacheroot";
        };
    };

  services.vnstat.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ brlaser brgenml1lpr brgenml1cupswrapper gutenprint gutenprintBin ];
  services.locate.enable = true;

  time.timeZone = "Europe/Berlin";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.package = pkgs.bluezFull;
  services.blueman.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  programs.seahorse.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.browserpass.enable = true;
  programs.dconf.enable = true;
  services.openssh.enable = true;
  services.gvfs.enable = true;

  networking.networkmanager.enable = true;

  virtualisation.libvirtd.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.zeroconf.discovery.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "us,de";
  services.xserver.xkbOptions = "caps:super,grp:shifts_toggle";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.tapping = false;
  services.thinkfan.enable = true;
  services.gnome3.glib-networking.enable = true;
  programs.adb.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  environment.pathsToLink = [ "/libexec" ];
  environment.variables.TERMINAL = "kitty";
  environment.variables._JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = false;
  system.stateVersion = "19.09"; # Did you read the comment?
  fonts.fonts = with pkgs; [
    fira-code
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    zip
    unzip
    file
    discord
    libreoffice
    pdf2svg
    pfetch
    arandr
    calibre
    lxrandr
    wget
    kitty
    dex
    neovim
    sxhkd
    pywal
    mpd
    mpc_cli
    git
    polkit_gnome
    git-lfs
    networkmanagerapplet
    xcape
    xorg.xmodmap
    pcmanfm
    firefox
    lightspark
    ranger
    zathura
    discord
    lightlocker
    killall
    rofi
    thefuck
    i3blocks
    compton
    netbeans
    tdesktop
    pulsemixer
    tigervnc
    rofi-pass
    qtpass
    pwgen
    xdotool
    thunderbird
    dunst
    maim
    libnotify
    kdeconnect
    wireshark
    brightnessctl
    (
      pass.withExtensions (
        ext: [
          ext.pass-audit
          ext.pass-genphrase
          ext.pass-import
          ext.pass-update
          ext.pass-tomb
        ]
      )
    )
    vscode
    nixpkgs-fmt
  ] ++ (
    with gnome3; [
      adwaita-icon-theme
      file-roller
      dconf-editor
    ]
  );
  virtualisation.docker.enable = true;
  users.users.coafin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "dialout" "wireshark" "libvirtd" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$6$ixcLHZOIyPAGS$bH4hWJrMQrzgzVGR.BmCRD1qxY1OLOpuOoQ3kr4RDrzsA9dISCgeliOh14c34t/e2btSzvIyI57ibqhCJtD451";
  };
  security.pam.services.coafin.enableGnomeKeyring = true;
}
