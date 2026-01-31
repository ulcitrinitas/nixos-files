# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/snapper.nix
    ./modules/flatpak.nix
    ./modules/virt.nix
  ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      # autoEnrollKeys.enable = true;
    };

    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings" "splash"];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
      systemd.enable = true;
      kernelModules = ["i915"];
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "vt.global_cursor_default=0"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 10;
  };

  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  # To disable installing GNOME's suite of applications
  # and only be left with GNOME shell.
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

  # Configure keymap in X11
  services.xserver.xkb.layout = "br";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.uli = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = ["wheel" "podman" "systemd-journal" "libvirtd" "vboxusers"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget

    curl

    alejandra

    doas
    doas-sudo-shim

    git
    gitui
    git-lfs

    binutils
    busybox
    toybox

    less

    which

    sbctl
    refind

    tmux

    gnumake
    libgccjit
    debugedit
    bison
    flex
    gnupatch

    bc

    unzip
    zip
    p7zip

    dosfstools
    ntfs3g

    inetutils
    usbutils
    pciutils

    acpi

    nawk

    lsof

    rsync
    netcat-openbsd

    dnsmasq
    pv
    whois
    traceroute

    xwayland-satellite

    alacritty

    xdg-user-dirs
    xdg-desktop-portal-gtk

    distrobox
    distrobox-tui

    eza
    bat
    ripgrep
    fd

    beamMinimal28Packages.erlang

    direnv
    nix-direnv

    gnome-tweaks
    gnome-browser-connector
    ptyxis
    nautilus
    sushi
    code-nautilus

    gnomeExtensions.flickernaut
    gnomeExtensions.appindicator

    rofi
    waybar
    alacritty
    fuzzel
    foot
    waybar
    dunst
    quickshell

    nwg-look
    nwg-displays
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts

    nerd-fonts.jetbrains-mono
    nerd-fonts.zed-mono
    nerd-fonts.victor-mono
    nerd-fonts.ubuntu-mono
    nerd-fonts.terminess-ttf
    nerd-fonts.symbols-only
    nerd-fonts.roboto-mono
    nerd-fonts.mononoki
    nerd-fonts.iosevka
    nerd-fonts.hurmit
    nerd-fonts.heavy-data
    nerd-fonts.hack
    nerd-fonts.hasklug
    nerd-fonts.fira-mono
    nerd-fonts.fira-code
    nerd-fonts.commit-mono
    nerd-fonts.caskaydia-mono

    inter
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.flatpak.enable = true;

  hardware.bluetooth.enable = true;

  services.thermald.enable = true;

  services.power-profiles-daemon.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 45d";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11"; # Did you read the comment?
}
