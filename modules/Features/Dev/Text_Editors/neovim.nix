{ inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      
      # 1. Supply Language Servers
      runtimePkgs = [
        pkgs.nixd 
        pkgs.vscode-langservers-extracted 
      ];

      # 2. Configure Plugins via Wrapper Specs
      specs = {

	  indentSettings = {
	    data = pkgs.vimPlugins.nvim-lspconfig;
	    type = "lua";
	    config = ''
	      print("INDENT CONFIG LOADED")

	      vim.opt.tabstop = 4
	      vim.opt.softtabstop = 4
	      vim.opt.shiftwidth = 4
  	      vim.opt.expandtab = true
	    '';
	  };

      treesitter = {
        # Install nvim-treesitter alongside the specific parsers you need
          data = pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
            plugins.nix
            plugins.css
            plugins.bash
            plugins.awk
          ]);
          type = "lua";
          config = ''
            vim.api.nvim_create_autocmd("FileType", {
	      pattern = { "nix", "css", "bash", "awk" },
	      callback = function()
	        vim.treesitter.start()
	      end,
	    })
          '';
        };

        lspconfig = {
          data = pkgs.vimPlugins.nvim-lspconfig;
          type = "lua";
          config = ''
            vim.lsp.enable('nixd')
            vim.lsp.enable('cssls')
            vim.lsp.enable('bashls')
            vim.lsp.enable('awk_ls')
          '';
        };
      };
    };
  };

  # 4. Expose as a NixOS Module (Dendritic Pattern)
  flake = {
    nixosModules.myNeovim = { pkgs, ... }: {
      environment.systemPackages = [ 
        inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim 
      ];
    };
  };
}
