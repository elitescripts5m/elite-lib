local module = {}

module.showMenu = function(header, options, footer)
    if not CheckArgs(header, options) then return end
end

module.closeMenu = function()

end

return module