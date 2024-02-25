{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "obin";
  home.homeDirectory = "/home/obin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    less
    brave
    floorp
    discord
    neovim-flake
  ];

  # Configure user programs
  programs.git.enable = true;
  programs.git.userName = "obinmatt";
  programs.bat.enable = true;
  programs.bat.config.theme = "TwoDark";
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.enableAutosuggestions = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases.ls = "ls --color=auto -F";
  programs.zsh.shellAliases.ll = "ls -l";
  programs.zsh.shellAliases.nixswitch = "sudo nixos-rebuild switch --flake /etc/nixos/#default";
  programs.zsh.shellAliases.nixup = "pushd /etc/nixos; sudo nix flake update; nixswitch; popd";
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
  programs.wezterm.enable = true;
  programs.wezterm.enableZshIntegration = true;
  programs.wezterm.extraConfig = ''
    return {
        font_size = 14.0,
        color_scheme = "rose-pine",
        hide_tab_bar_if_only_one_tab = true
    }
  '';

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/obin/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    PAGER = "less";
    CLICOLOR = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
