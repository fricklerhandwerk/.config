{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = "${builtins.readFile ./init.vim}";
      packages.vam = with pkgs.vimPlugins;
        let unstable = pkgs.unstable.vimPlugins; in {
        start = [
          unstable.vim-fish
          fugitive
          vim-nix
          vim-surround
          ctrlp-vim
          vim-abolish
          vim-better-whitespace
          nerdcommenter
          ultisnips
          vim-airline
          vim-airline-themes
          unstable.NeoSolarized
        ];
      };
    };
  };
}
