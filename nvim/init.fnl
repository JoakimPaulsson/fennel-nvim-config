(local lazy (require :lazy))

(local oilconf { 1 "stevearc/oil.nvim" :opts {} :dependencies ["nvim-tree/nvim-web-devicons"] })

(print oilconf)

(lazy.setup [
  :udayvir-singh/tangerine.nvim
  oilconf
]
	    {})

(local oil (require :oil))
