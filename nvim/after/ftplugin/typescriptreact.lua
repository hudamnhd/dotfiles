vim.b.minisurround_config = {
    custom_surroundings = {
        c = {
            input = { "%{%/%*().-()%*%/%}" },
            output = { left = "{/*", right = "*/}" },
        }
    },
}
