{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-files#nixos";
    };
    profileExtra = ''

      export PATH="$HOME/.local/bin:$PATH"

    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza";
      ll = "eza --long -bF";
      la = "eza -l -a --group-directories-first";
      lx = "eza -l -a --group-directories-first --extended";
      lt = "eza --tree --long";

      rebuild = "sudo nixos-rebuild switch --flake ~/nix-files#nixos";
      update = "sudo nixos-rebuild switch --flake ~/nix-files#nixos --upgrade";

      cls = "clear";
      rn = "reset";

      e = "emacsclient -c -a 'emacs'"; # Abre o Emacs no modo gráfico (frame) conectando ao daemon
      et = "emacsclient -t -a 'emacs'"; # Abre o Emacs dentro do próprio terminal (útil para edições rápidas via ssh ou tty)
      ekill = "emacsclient -e '(kill-emacs)'"; # Mata o daemon caso precise recarregar configurações travadas
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "pkill *" "cp *"];

    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "wushenrong/zsh-eza";}
        {name = "zsh-users/zsh-syntax-highlighting";}
      ];
    };

    initContent = ''
      eval "$(starship init zsh)"
      # eval "$(mise activate zsh)"
    '';
  };
}
