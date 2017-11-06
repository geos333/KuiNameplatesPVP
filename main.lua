local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local mod = addon:NewPlugin('PVP')
local opt, events = KuiPVPConfig, {}
local frame_name = 'KuiPVPConfig'

-- create ######################################################################
function mod:Show(f)
    if (opt.env.iconFaction or opt.env.iconCombat or opt.env.iconOwnFaction)  then
        f:UpdatePVPIcon(f)
    else
        f.pvpIcon:Hide()
    end
end


function mod:Create(f)
    self:CreatePVPIcon(f)
end

local function UpdatePVPIcon(f)
    if (opt.env.iconFaction) and (opt.env.iconOwnFaction) and (UnitFactionGroup(f.unit)) then
        if (UnitFactionGroup(f.unit) ~= UnitFactionGroup("player")) then
        f.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..UnitFactionGroup(f.unit));
        f.pvpIcon:SetTexCoord(0,0.62,0,0.62);
        f.pvpIcon:SetWidth(opt.env.iconSize);
        f.pvpIcon:SetHeight(opt.env.iconSize);
        f.pvpIcon:Show()
        else
            f.pvpIcon:Hide()
        end
    elseif (opt.env.iconFaction) and (UnitIsPVPFreeForAll(f.unit)) then
        f.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA");
        f.pvpIcon:SetTexCoord(0,0.62,0,0.62);
        f.pvpIcon:SetWidth(opt.env.iconSize);
        f.pvpIcon:SetHeight(opt.env.iconSize);
        f.pvpIcon:Show();
    elseif (opt.env.iconFaction) and (UnitFactionGroup(f.unit)) then
        f.pvpIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..UnitFactionGroup(f.unit));
        f.pvpIcon:SetTexCoord(0,0.62,0,0.62);
        f.pvpIcon:SetWidth(opt.env.iconSize);
        f.pvpIcon:SetHeight(opt.env.iconSize);
        f.pvpIcon:Show()
    elseif (opt.env.iconCombat) and (UnitAffectingCombat(f.unit)) then
        f.pvpIcon:SetTexture("Interface\\CharacterFrame\\UI-StateIcon");
        f.pvpIcon:SetTexCoord(0.5,1,0,0.5);
        f.pvpIcon:SetWidth(opt.env.iconSize);
        f.pvpIcon:SetHeight(opt.env.iconSize);
        f.pvpIcon:Show();
    else
        f.pvpIcon:Hide()
    end
end

function mod:CreatePVPIcon(f)
    local pvpIcon = f:CreateTexture(nil,"BACKGROUND");
    pvpIcon:SetPoint(opt.MirrorAnchors["RIGHT"],f,"RIGHT");
    f.pvpIcon = pvpIcon
    f.UpdatePVPIcon = UpdatePVPIcon

end

-- initialise ##################################################################
function mod:Initialise()
    self:RegisterMessage('Show')
    self:RegisterMessage('Create')
end
-- Event Holders ###############################################################
function events:ADDON_LOADED(addon_name)
    if addon_name == 'Kui_Nameplates_PVP' then
        init()
        local version = opt:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
        version:SetAlpha(.5)
        version:SetPoint('TOPRIGHT',-12,-10)
        version:SetText(string.format(
            opt.info.header,
            opt.info.name,
            opt.info.author,
            opt.info.version
        ))

        local icon = CreateCheckBox(opt, 'iconFaction')
        icon:SetPoint("TOP", -250, -65)
        local icon = CreateCheckBox(opt, 'iconCombat')
        icon:SetPoint("TOP", -250, -85)
        local icon = CreateCheckBox(opt, 'iconOwnFaction')
        icon:SetPoint("TOP", -250, -125)
        local icon = CreateCheckBox(opt, 'Debugger')
        icon:SetPoint("BOTTOMLEFT", 0, 0)
        local iconSize = CreateSlider(opt, 'iconSize', 24, 72)
        iconSize:SetPoint("TOP", -140, -170)


    end
end

function events:PLAYER_LOGOUT()
    KuiPVPSaved = opt.env
end

opt:SetScript('OnEvent', function(self, event, ...)
    events[event](self, ...)
end)
for k, v in pairs(events) do
    opt:RegisterEvent(k)
end