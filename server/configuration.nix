# TODO: impermanence

{ modulesPath, pkgs, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  nixpkgs.hostPlatform = "aarch64-linux";

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
      "usbhid"
    ];
    loader.systemd-boot.enable = true;
  };

  networking = {
    hostName = "backupserver";
    hostId = "2d6343cc";
    useDHCP = true;
  };

  services.openssh.enable = true;

  # TODO: reuse common modules from main nixos-config repo?
  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    # TODO: pull from submodule?
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ46ZX6zJQrMOdffEZqJk5bbgZpTnaExEprMDS9aQUpa keith@laptop"
  ];

  system.stateVersion = "25.05";
}
