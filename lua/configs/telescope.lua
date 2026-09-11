local options = require "nvchad.configs.telescope"

options.defaults.layout_config = {
  horizontal = {
    prompt_position = "top",
    preview_width = 0.5,
  },
  width = 0.8,
  height = 0.3,
}

return options
