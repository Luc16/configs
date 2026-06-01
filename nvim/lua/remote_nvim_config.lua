require("remote-nvim").setup({
  -- How the remote session should be launched
  devpod = {
    binary = "devpod",
  },
  -- SSH configuration
  ssh_config = {
    ssh_binary = "ssh",
    scp_binary = "scp",
  },
  -- This is the "magic" part: it tells the remote server 
  -- how to handle your local workspace
  remote = {
    copy_dirs = {
      config = {
        base = vim.fn.stdpath("config"), -- Dynamically finds your local nvim path
        dirs = "*",                      -- Copies everything (init.lua, lua/, etc.)
        compression = {
          enabled = true,                -- Recommended: makes the transfer faster
        },
      },
    },
  },
  -- Configuration for the floating window UI
  client_callback = function(port, _)
    require("remote-nvim").display_menu({
      "Select how to connect:",
      { "Local Terminal", "terminal" },
      { "External Terminal", "external" },
    })
  end,
})
