inputs: { pkgs, lib, ... }: 
let 
  pkgs-unstable = import inputs.nixpkgs-unstable { system = pkgs.system; config.allowUnfree = true; };

  mkXr = { name ? "", w, h, r }:
    let
      modeName = "${toString w}x${toString h}_${toString r}.00";
      scriptName = if lib.stringLength name == 0 then modeName else name;
    in
    pkgs.writeShellScriptBin "xr-${scriptName}" ''
      # xrandr doesn't parse the output correctly when you use $()      
      # therefore we use eval instead
      MODELINE=$(cvt ${toString w} ${toString h} ${toString r} | tail -n 1 | cut -d " " -f2-) 
      eval "xrandr --newmode $MODELINE" 
      xrandr --addmode Virtual-1 ${modeName}
      xrandr -s ${modeName}
      xrandr --dpi 192 
    '';
in
{
  # use unstable nix so we can access flakes
  nix = {
    package = pkgs-unstable.nix;
    settings = {
      sandbox = "relaxed";
      substituters = [ 
        "https://nix-community.cachix.org/" 
        "https://mitchellh-nixos-config.cachix.org" 
        "https://composable-community.cachix.org/" 
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="    
        "composable-community.cachix.org-1:GG4xJNpXJ+J97I8EyJ4qI5tRTAJ4i7h+NK2Z32I8sK8="
      ];  
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  }; 

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
    jetbrains-mono
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];

  services.tailscale.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    arc-theme
    (writeShellScriptBin "xr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
    (mkXr { name = "mbp"; w = 3024; h = 1890; r = 60; })
    (mkXr { name = "mbp-120hz"; w = 3024; h = 1890; r = 120; })
    (mkXr { name = "mbp-1.5"; w = 4536; h = 2835; r = 60; })
    (mkXr { name = "mbp-16"; w = 3456; h = 2160; r = 60; })
    (mkXr { name = "4k"; w = 3840; h = 2160; r = 60; })
    (mkXr { name = "5k"; w = 5120; h = 2880; r = 60; })
    (mkXr { name = "5k-30hz"; w = 5120; h = 2880; r = 30; })
    (mkXr { name = "5.5k"; w = 5760; h = 3240; r = 60; })
    (mkXr { name = "6k"; w = 6400; h = 3600; r = 60; })
    (mkXr { name = "square"; w = 2880; h = 2880; r = 60; })
    (mkXr { name = "vertical-studio-display"; w = 2880; h = 5120; r = 60; })
    (mkXr { name = "things-sidebar"; w = 4296; h = 2880; r = 60; })
    (mkXr { name = "4-3"; w = 3840; h = 2880; r = 60; })
  ];
  
  # required for zsh autocomplete
  environment.pathsToLink = [ "/share/zsh" ];

  users.users.kkast = {
    isNormalUser = true;
    home = "/home/kkast";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    hashedPassword = "";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAN0JRbnTsz4eEUeL6My/ew+rX3Qojawn+Y1B3buPuyC"
    ];
  };
}
