{ config, pkgs, ... }:

{
  programs.texlive = {
    enable = true;
    package = pkgs.texliveMedium;
    extraPackages = tpkgs: {
      inherit (tpkgs) scheme-medium collection-langcyrillic latexmk xetex;
    };
  };
}
