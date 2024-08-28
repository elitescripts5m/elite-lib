local module = {}

module.showMenu = function(header, options, footer)
    if not CheckArgs(header, options) then return end
    local menu = {}
    menu[#menu + 1] = {
        title = header.title,
        description = header.text,
        icon = header.icon or nil,
        disabled = header.disabled or false,
        args = header.args or nil
    }
    if header.isServer then
        menu[#menu].serverEvent = header.event or nil
    elseif header.isAction then
        menu[#menu].onSelect = header.event or nil
    elseif not header.isServer and not header.isAction then
        menu[#menu].event = header.event or nil
    end

    for _, v in pairs(options) do
        menu[#menu + 1] = {
            title = v.title,
            description = v.text,
            icon = v.icon or nil,
            image = v.image or nil,
            disabled = v.disabled or false,
            event = v.event,
            args = v.args or nil
        }
        if v.isServer then
            menu[#menu].serverEvent = v.event or nil
        elseif v.isAction then
            menu[#menu].onSelect = v.event or nil
        elseif not v.isServer and not v.isAction then
            menu[#menu].event = v.event or nil
        end
    end

    if footer and footer.event then
        menu[#menu + 1] = {
            title = footer.title,
            description = footer.text,
            icon = footer.icon or nil,
            disabled = footer.disabled or false,
            args = footer.args or nil
        }
        if footer.isServer then
            menu[#menu].serverEvent = footer.event or nil
        elseif footer.isAction then
            menu[#menu].onSelect = footer.event or nil
        elseif not footer.isServer and not footer.isAction then
            menu[#menu].event = footer.event or nil
        end
    else
        menu[#menu + 1] = {
            title = footer.title,
            description = footer.text,
            icon = footer.icon or nil,
            disabled = footer.disabled or false,
            event = "close"
        }
    end

    exports.ox_lib:registerContext({
        id = "elite-lib-menu",
        title = header.title,
        options = menu
    })
    exports.ox_lib:showContext("elite-lib-menu")
end

module.closeMenu = function()
    exports.ox_lib:hideContext("elite-lib-menu")
end

return module