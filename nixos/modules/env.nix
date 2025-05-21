{
  environment.sessionVariables = rec {
    TERMINAL = "alacritty";
    EDITOR = "emacsclient -nw";
    DEFAULT_EDITOR = "emacsclient -nw";
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };
}
