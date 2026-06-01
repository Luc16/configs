require('remote-sshfs').setup({
  connections = {
    ssh_configs = {
      vim.fn.expand "$HOME" .. "/.ssh/config",
      sshfs_args = {
        "-o", "ServerAliveInterval=15",
        "-o", "ServerAliveCountMax=3",
        "-o", "ConnectTimeout=10",
      }
    },
  },
  mounts = {
    base_dir = vim.fn.expand "$HOME" .. "/.remote-sshfs/",
    unmount_on_exit = true,
  },
  handlers = {
    on_connect = {
      change_dir = true, -- First, move into the new mount
    },
  },
  ui = {
    confirm = {
      connect = false, -- No need to Confirm before connecting
    },
  }
})

-- Register the callback using the .add() method
require("remote-sshfs").callback.on_connect_success:add(function(host, mount_dir)
  -- Normalize the path to avoid trailing slash issues
  local mount_path = mount_dir

  vim.defer_fn(function()
    -- 1. Ensure Neovim's CWD is definitely the mount path
    vim.api.nvim_set_current_dir(mount_path)

    -- 2. Trigger AutoSession's directory-based restore
    -- This mimics you manually running :AutoSession restore
    require("auto-session").restore_session(mount_path)

    print("󱘖 Connected to " .. mount_path .. " and restored session.")
  end, 500)
end)

-- Keybindings for easy access
vim.keymap.set('n', '<leader>rc', ':RemoteSSHFSConnect<CR>', { desc = 'Connect to Remote' })
vim.keymap.set('n', '<leader>rd', ':RemoteSSHFSDisconnect<CR>', { desc = 'Disconnect' })
