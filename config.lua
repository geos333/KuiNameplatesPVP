local folder,ns = ...
local opt = CreateFrame('FRAME','KuiPVPConfig',InterfaceOptionsFramePanelContainer)
opt.name = 'Kui |cff9966ffPVP'
InterfaceOptions_AddCategory(opt)

-- locale ######################################################################
do
    local L = {}
    function opt:Locale(region)
        assert(type(region) == 'string')
        if region == 'enGB' or region == GetLocale() then
            return L
        end
    end
    function opt:GetLocale()
        return L
    end
end

opt.info = {
    name = 'KuiNameplates: PVP',
    version = '0.1.0',
    author = 'GEOS',
    header = '%s by %s, version %s'
}
opt.titles = {
    iconFaction = 'Show Icon Faction',
    iconCombat = 'Show Icon Combat',
    --iconAnchor = 'Icon Anchor',
    iconSize = 'Change Icon Size',
    iconOwnFaction = 'Show Icon Own Faction'
}

opt.env = {
    iconFaction = true,
    iconCombat = true,
    iconAnchor = "RIGHT",
    iconSize = 24,
    iconOwnFaction = false,
    Debugger = false,
}

opt.Anchor = {
    RIGHT = "RIGHT",
    LEFT = "LEFT",
    TOP = "TOP",
    BOTTOM = "BOTTOM",
    TOPLEFT = "TOPLEFT",
    TOPRIGHT = "TOPRIGHT",
    BOTTOMLEFT = "BOTTOMLEFT",
    BOTTOMRIGHT = "BOTTOMRIGHT",
    RIGHT = "LEFT",
    CENTER = "CENTER"
}

opt.MirrorAnchors = {
    TOP = "BOTTOM",
    TOPLEFT = "TOPRIGHT",
    TOPRIGHT = "TOPLEFT",
    BOTTOM = "TOP",
    BOTTOMLEFT = "BOTTOMRIGHT",
    BOTTOMRIGHT = "BOTTOMLEFT",
    LEFT = "RIGHT",
    RIGHT = "LEFT",
    CENTER = "CENTER",
};
