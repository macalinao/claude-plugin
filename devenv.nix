{ pkgs, ... }:

{
  packages = with pkgs; [ git ];

  git-hooks.hooks = {
    nixfmt-rfc-style.enable = true;
    prettier = {
      enable = true;
      types_or = [
        "json"
        "markdown"
        "yaml"
      ];
    };
  };
}
