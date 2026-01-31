{
  config,
  lib,
  pkgs,
  ...
}: {
  # enable nix-flatpak declarative flatpaks
  services.flatpak = {
    enable = true;
    packages = [
      "com.discordapp.Discord"
      "io.github.thetumultuousunicornofdarkness.cpu-x"
      "me.proton.Mail"
      "org.nickvision.money"
      "org.gnome.Logs"
      "org.onlyoffice.desktopeditors"
      "md.obsidian.Obsidian"
      "ch.theologeek.Manuskript"
      "com.logseq.Logseq"
      "io.anytype.anytype"
      "org.onlyoffice.desktopeditors"
      "io.github.zaedus.spider"
      "app.zen_browser.zen"
      "org.qbittorrent.qBittorrent"
      "io.github.flattool.Warehouse"
      "io.github.MakovWait.Godots"
      "com.github.marhkb.Pods"
      "org.gaphor.Gaphor"
      "rest.insomnia.Insomnia"
      "io.github.limads.Queries"
      "io.podman_desktop.PodmanDesktop"
      "com.usebruno.Bruno"
      "io.dbeaver.DBeaverCommunity"
      "com.vscodium.codium"
      "com.github.tchx84.Flatseal"
      "it.mijorus.gearlever"
      "io.github.zhrexl.thisweekinmylife"
    ];
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
  };

  systemd.services.flatpak-repo = {
    wantedBy = ["multi-user.target"];
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
