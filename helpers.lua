local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiPVPConfig
local frame_name = 'KuiPVPConfig'
local L = opt:GetLocale()

-- init ########################################################################
function init()
    if KuiPVPSaved == nil then
        KuiPVPSaved = opt.env
    else
        opt.env = KuiPVPSaved
    end
end
-- helper functions ############################################################
function RegisterDebug(...)
    if opt.env.Debugger then
        print('|cff9966ffKui PVP: |r', ...)
    end
end
function ResetFrames()
    for i, f in addon:Frames() do
        if f:IsShown() then
            local unit = f.unit
            f.handler:OnHide()
            f.handler:OnUnitAdded(unit)
        end
    end
end
function IsInTable(t, val)
    for i, v in pairs(t) do
        if v == val then return true end
    end
    return false
end
function IsHealer(unit)
    for i, id in pairs(opt.healers) do
        if id == unit then
            RegisterDebug(select(6, GetPlayerInfoByGUID(unit)), 'is a healer')
            return true
        end
    end
    return false
end
-- element helpers #############################################################
local function CheckBoxOnClick(self)
    opt.env[self:GetName()] = self:GetChecked()
    if self:GetChecked() then
        PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or 856)
    else
        PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOff" or 857)
    end
    ResetFrames()
end
local function OnEnter(self)
    GameTooltip:SetOwner(self,'ANCHOR_TOPLEFT')
    GameTooltip:SetWidth(200)
    GameTooltip:AddLine(
        self.env and (L.titles[self.env] or self.env) or
                self.label and self.label:GetText()
    )

    if self.env and L.tooltips[self.env] then
        GameTooltip:AddLine(L.tooltips[self.env], 1,1,1,true)
    end

    GameTooltip:Show()
end
local function OnLeave(self)
    GameTooltip:Hide()
end
local function GenericOnShow(self)
    if self.enabled then
        if self.enabled(opt.env) then
            self:Enable()
        else
            self:Disable()
        end
    end
end

do
local function SliderOnChanged(self,v)
    -- copy value to display text
    if not v then
        v = self:GetValue()
    end
    -- round value for display to hide floating point errors
    local r_v = string.format('%.4f',v)
    r_v = string.gsub(r_v,'0+$','')
    r_v = string.gsub(r_v,'%.$','')
    self.display:SetText(r_v)
end
local function Get(self)
    if self.env and opt.env[self.env] then
        self:SetValue(opt.env[self.env])
        -- set text to correct value if outside min/max
        SliderOnChanged(self,opt.env[self.env])
    end
end
local function Set(self,v)
    if not self:IsEnabled() then return end
    if self.env and opt.env[self.env] then
        --opt.config:SetConfig(self.env,v or self:GetValue())
        opt.env[self.env] = v or self:GetValue()
    end
end
local function SliderOnShow(self)
    if not opt.env then return end
    self:Get()
    GenericOnShow(self)
end
local function SliderOnMouseUp(self)
    self:Set()
end
local function SliderOnMouseWheel(self,delta)
    if not self:IsEnabled() then return end
    if delta > 0 then
        delta = self:GetValueStep()
    else
        delta = -self:GetValueStep()
    end
    self:SetValue(self:GetValue()+delta)
    self:Set()
end
local function SliderSetMinMaxValues(self,min,max)
    self:orig_SetMinMaxValues(min,max)
    self.Low:SetText(min)
    self.High:SetText(max)
end
local function EditBox_OnFocusGained(self)
    self:HighlightText()
end
local function EditBox_OnEscapePressed(self)
    self:ClearFocus()
    self:HighlightText(0,0)

    -- revert to current value
    SliderOnShow(self:GetParent())
end
local function EditBox_OnEnterPressed(self)
    -- dumb-verify input
    local v = tonumber(self:GetText())

    if v then
        -- display change
        self:GetParent():SetValue(v)
        -- push to config
        self:GetParent():Set(v)
    else
        EditBox_OnEscapePressed(self)
    end

    -- re-grab focus
    self:SetFocus()
end
function CreateSlider(parent, name, min, max)
        RegisterDebug('KPVP Creating Slider:', name)
        local slider = CreateFrame('Slider',frame_name..name..'Slider',parent,'OptionsSliderTemplate')
        slider:SetWidth(190)
        slider:SetHeight(15)
        slider:SetOrientation('HORIZONTAL')
        slider:SetThumbTexture('interface/buttons/ui-sliderbar-button-horizontal')
        slider:SetObeyStepOnDrag(true)
        slider:EnableMouseWheel(true)

        -- TODO inc/dec buttons
        local label = slider:CreateFontString(slider:GetName()..'Label','ARTWORK','GameFontNormal')
        label:SetText(L.titles[name] or name or 'Slider')
        label:SetPoint('BOTTOM',slider,'TOP')

        local display = CreateFrame('EditBox',nil,slider)
        display:SetFontObject('GameFontHighlightSmall')
        display:SetSize(50,15)
        display:SetPoint('TOP',slider,'BOTTOM',0,1)
        display:SetJustifyH('CENTER')
        display:SetAutoFocus(false)
        display:SetMultiLine(true)
        display:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1
        })
        display:SetBackdropBorderColor(1,1,1,.2)
        display:SetBackdropColor(0,0,0,.5)

        display:SetScript('OnEditFocusGained',EditBox_OnFocusGained)
        display:SetScript('OnEditFocusLost',EditBox_OnEscapePressed)
        display:SetScript('OnEnterPressed',EditBox_OnEnterPressed)
        display:SetScript('OnEscapePressed',EditBox_OnEscapePressed)

        slider.orig_SetMinMaxValues = slider.SetMinMaxValues
        slider.SetMinMaxValues = SliderSetMinMaxValues

        slider.env = name
        slider.label = label
        slider.display = display

        slider:HookScript('OnEnter',OnEnter)
        slider:HookScript('OnLeave',OnLeave)
        slider:HookScript('OnShow',SliderOnShow)
        slider:HookScript('OnValueChanged',SliderOnChanged)
        slider:HookScript('OnMouseUp',SliderOnMouseUp)
        slider:HookScript('OnMouseWheel',SliderOnMouseWheel)

        slider.Get = Get
        slider.Set = Set

        slider:SetValueStep(1)
        slider:SetMinMaxValues(min or 0, max or 100)

        if name and type(parent.elements) == 'table' then
            parent.elements[name] = slider
        end
        return slider
        --[[
        local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
        slider:SetWidth(190)
        slider:SetHeight(15)
        slider:SetOrientation('HORIZONTAL')
        slider:SetThumbTexture('interface/buttons/ui-sliderbar-button-horizontal')
        slider:SetObeyStepOnDrag(true)
        slider:EnableMouseWheel(true)
        slider:SetMinMaxValues(24, 72)
        slider:SetValueStep(1)

        slider:SetScript("OnValueChanged", SliderChangeValue)

        slider.label = parent:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
        slider.label:SetText(opt.titles[name] or name or '!MissingTitle')
        slider.label:SetPoint('LEFT', slider, 'TOPLEFT',0,10)

        return slider
        --]]
    end
end
function CreateCheckBox(parent, name)
    RegisterDebug('KPVP Creating Check Box:', name)
    local check = CreateFrame('CheckButton', name, parent, 'OptionsBaseCheckButtonTemplate')

    check:SetScript('OnClick',CheckBoxOnClick)

    check.label = parent:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
    check.label:SetText(L.titles[name] or name or '!MissingTitle')
    check.label:SetPoint('LEFT', check, 'RIGHT')

    check.label:HookScript('OnEnter',OnEnter)
    check.label:HookScript('OnLeave',OnLeave)

    check:SetChecked(opt.env[name])

    return check
end


