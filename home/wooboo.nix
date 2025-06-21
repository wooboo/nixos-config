{ ... }:
{
  home.username = "wooboo";
  home.homeDirectory = "/home/wooboo";
  programs.git = {
    enable = true;
    userName = "Piotr Żabówka";
    userEmail = "wooboox@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  home.stateVersion = "25.05";
}
