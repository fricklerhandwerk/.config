{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = "${builtins.readFile ./init.vim}";
    plugins =
      with pkgs;
      with vimPlugins;
      let
        unstable = pkgs.unstable.vimPlugins;
        incsearch-fuzzy = vimUtils.buildVimPlugin {
          pname = "incsearch-fuzzy";
          version = "2016-12-15";
          src = fetchGit {
            url = "https://github.com/haya14busa/incsearch-fuzzy.vim";
            ref = "master";
          };
        };
      in
      [
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
        easymotion
        incsearch-vim
        incsearch-fuzzy
        incsearch-easymotion-vim
        echodoc
        vim-jinja
        vim-airline
        vim-airline-themes
        unstable.NeoSolarized
        LanguageClient-neovim
        vim-go
      ];
  };
  home.packages = with pkgs; [
    (python3.withPackages (ps: [
       ps.pyls-mypy
       ps.pyls-isort
       ps.pyls-black
    ]))
    gotools
    go
  ];
}
