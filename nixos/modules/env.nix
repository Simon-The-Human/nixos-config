{
  environment.sessionVariables = rec {
    TERMINAL = "alacritty";
    EDITOR = "emacs";
    VISUAL = "emacs";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };
}
