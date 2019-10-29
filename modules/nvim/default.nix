{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = "${builtins.readFile ./init.vim}";
      packages.plugins = with pkgs.vimPlugins;
        let unstable = pkgs.unstable.vimPlugins; in {
        start = [
          unstable.vim-fish
          fugitive
          vim-nix
          vim-surround
          vim-repeat
          unstable.lexima-vim
          ctrlp-vim
          vim-abolish
          vim-better-whitespace
          nerdcommenter
          ultisnips
          vim-snippets
          deoplete-nvim
          echodoc
          vim-airline
          vim-airline-themes
          unstable.NeoSolarized
          LanguageClient-neovim
        ];
      };
    };
  };
  home.packages = with pkgs; [
    (python3.withPackages (ps: [
       ps.pyls-mypy
       ps.pyls-isort
       ps.pyls-black
    ]))
  ];
}
