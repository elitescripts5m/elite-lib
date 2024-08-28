local module = {}

module.showMenu = function(header, options, footer)
    if not CheckArgs(header, options) then return end
    local menu = {}
    menu[#menu + 1] = {
        disabled = header.disabled or false,
        header = header.title,
        txt = header.text,
        icon = header.icon or nil,
        params = {
            isServer = header.isServer or false,
            isAction = header.isAction or false,
            event = header.event,
            args = header.args or nil
        }
    }

    for _, v in pairs(options) do
        menu[#menu + 1] = {
            header = v.image and (v.image .. " " .. v.title) or v.title,
            txt = v.text,
            icon = v.icon or nil,
            disabled = v.disabled or false,
            params = {
                isServer = v.isServer or false,
                isAction = v.isAction or false,
                event = v.event or nil,
                args = v.args or nil
            }
        }
    end

    if footer and footer.event then
        menu[#menu + 1] = {
            disabled = footer.disabled or false,
            header = footer.title,
            txt = footer.text,
            icon = footer.icon or nil,
            params = {
                isServer = footer.isServer or false,
                isAction = footer.isAction or false,
                event = footer.event,
                args = footer.args or {}
            }
        }
    elseif footer and not footer.event then
        menu[#menu + 1] = {
            disabled = footer.disabled or false,
            header = footer.title,
            txt = footer.text,
            icon = footer.icon or nil,
            params = {
                exports["qb-menu"]:closeMenu(menu)
            }
        }
    end

    exports["qb-menu"]:openMenu(menu)
end

module.closeMenu = function()
    exports["qb-menu"]:closeMenu()
end

return module