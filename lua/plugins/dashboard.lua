return {
    "nvimdev/dashboard-nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VimEnter",
    keys = {
        { "<leader>ds", "<cmd>Dashboard<cr>", desc = "Open Dashboard" },
    },
    opts = function(_, opts)
        local header = os.getenv("TERM") == "xterm-kitty"
                and {
                    "██████████████████████████████████████████████████\n",
                    "█████ ████████████████████████████████████████\n",
                    "████   ███  ████████████████  █ ███████████\n",
                    "███     █     █     ██  ████ █ ███\n",
                    "██  █       ██ ██    █        ██\n",
                    "██  ███   █   ██ ██ █   █  █ █  ██\n",
                    "███████ ██    █    ███ █  █████ ██\n",
                    "██████████████████████████████████████████████████",
                }
            or {
                "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗\n",
                "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║\n",
                "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║\n",
                "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║\n",
                "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║\n",
                "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }

        local shortcut = function(icon, desc, key, action)
            local hl = {
                icon = "DashboardCenter",
                desc = "DashboardCenter",
                key = "DashboardShortCut",
            }
            local key_format = "[%s]"
            return {
                icon = icon or "",
                icon_hl = hl.icon,
                desc = desc or "",
                desc_hl = hl.desc,
                key = key,
                key_hl = hl.key,
                key_format = key_format,
                action = action,
            }
        end

        local center = {
            shortcut("󰈔", " 󰁔 New File", "n", "ene | startinsert"),
            shortcut("󰈞", " 󰁔 Find File", "f", "Telescope find_files"),
            shortcut(
                "󱋡",
                " 󰁔 Recent Files" .. string.rep(" ", 21),
                "o",
                "Telescope oldfiles"
            ),
            shortcut(
                "󱁻",
                " 󰁔 Config Files",
                "c",
                "Neotree ~/.config/nvim"
            ),
            shortcut("󰒲", " 󰁔 Lazy", "l", "Lazy"),
            shortcut("󰏓", " 󰁔 Mason", "m", "Mason"),
            shortcut("󰗼", " 󰁔 Exit Neovim", "q", "quitall"),
        }

        local footer = {
            "I think we can put our differences behind us.\n",
            "For science. You monster. - GLaDOS",
        }

        local adjust_header = function(win_height)
            local db_height = #header + (#center * 2) + #footer + 3
            local header_space = string.rep(
                "\n",
                win_height - db_height >= 1
                        and math.ceil((win_height - db_height) / 2)
                    or 0
            )
            return header_space .. table.concat(header) .. "\n\n"
        end

        opts.theme = "doom"
        opts.config = {
            header = vim.split(
                adjust_header(vim.api.nvim_win_get_height(0)),
                "\n"
            ),
            center = center,
            footer = vim.split("\n" .. table.concat(footer), "\n"),
        }
    end,
}
