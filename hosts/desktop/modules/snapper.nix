{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";
    configs = {
      root = {
        SUBVOLUME = "/";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "0";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
      home = {
        SUBVOLUME = "/home";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "2";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
      nix = {
        SUBVOLUME = "/nix";
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "10";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "2";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
        BACKGROUND_COMPARISON = "yes";
        NUMBER_CLEANUP = "no";
        NUMBER_MIN_AGE = "1800";
        NUMBER_LIMIT = "50";
        NUMBER_LIMIT_IMPORTANT = "10";
        EMPTY_PRE_POST_CLEANUP = "yes";
        EMPTY_PRE_POST_MIN_AGE = "1800";
      };
    };
  };

  # Script pra rodar quando ocorre criação de novas gerações do sistema
  system.activationScripts.snapperSnapshot = {
    text = ''
      # Caminho para o binário do snapper usando a variável de ambiente ou o path do nix store
      SNAPPER="${pkgs.snapper}/bin/snapper"

      # Verifica se o snapper está disponível
      if [ -x "$SNAPPER" ]; then
        # Obtém o número da geração atual que está sendo ativada
        # O link /run/current-system aponta para a geração que está se tornando ativa
        GEN=$(readlink /nix/var/nix/profiles/system | grep -oP 'system-\K[0-9]+')

        echo "NixOS: Criando snapshot Btrfs para a geração $GEN..."

        # Cria o snapshot
        $SNAPPER -c root create \
          --description "NixOS Generation $GEN" \
          --cleanup-algorithm number \
          --userdata "nixos_gen=$GEN"

        $SNAPPER -c nix create \
          --description "NixOS Generation $GEN" \
          --cleanup-algorithm number \
          --userdata "nixos_gen=$GEN"

        $SNAPPER -c home create \
          --description "NixOS Generation $GEN" \
          --cleanup-algorithm number \
          --userdata "nixos_gen=$GEN"
      else
        echo "Aviso: Executável do Snapper não encontrado. Snapshot não criado."
      fi
    '';
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nixos-snapshots" ''
      echo "Mostrando todas as snapshots do sistema"
      echo "root: "
      ${pkgs.snapper}/bin/snapper -c root list
      echo "nix: "
      ${pkgs.snapper}/bin/snapper -c nix list
      echo "home: "
      ${pkgs.snapper}/bin/snapper -c home list
    '')
  ];
}
