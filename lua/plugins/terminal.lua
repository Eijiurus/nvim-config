return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    -- Key to trigger the terminal
    open_mapping = [[<c-\>]], 
    
    -- styling
    direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
    float_opts = {
      border = 'curved', 
    }
  }
}
