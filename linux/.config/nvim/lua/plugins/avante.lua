return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "copilot",
      behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = false,
      },
      windows = {
        position = "right",
        width = 35,
        sidebar_header = {
          enabled = true,
          align = "center",
          rounded = true,
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
      "hrsh7th/nvim-cmp",
      {
        "zbirenbaum/copilot.lua",
        opts = {
          copilot_node_command = vim.fn.expand("~/.nvm/versions/node/v22.22.3/bin/node"),
        },
      },
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
          checkbox = {
            custom = {
              forwarded = { raw = "[>]", rendered = "", highlight = "RenderMarkdownRightArrow" },
              cancelled = { raw = "[~]", rendered = "", highlight = "RenderMarkdownTilde" },
              in_progress = { raw = "[/]", rendered = "󰿠", highlight = "RenderMarkdownInProgress" },
            },
          },
        },
        ft = { "markdown", "Avante" },
        config = function(_, opts)
          require("render-markdown").setup(opts)
          vim.api.nvim_set_hl(0, "RenderMarkdownRightArrow", { bold = true, fg = "#f78c6c" })
          vim.api.nvim_set_hl(0, "RenderMarkdownTilde", { bold = true, fg = "#ff5370" })
          vim.api.nvim_set_hl(0, "RenderMarkdownInProgress", { bold = true, fg = "#89ddff" })
        end,
      },
    },
  },
}
