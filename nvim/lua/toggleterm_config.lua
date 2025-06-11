local toggleterm = require("toggleterm")

toggleterm.setup({
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
  -- This makes it so the terminal opens and you can start typing immediately
  start_in_insert = true,
  -- This makes it so that when you press Esc, you leave terminal mode and
  -- can use normal Vim commands.
  insert_mappings = true,
})
