local professions = {
    { id = 2259,  name = "Alchemy" },
    { id = 2018,  name = "Blacksmithing" },
    { id = 7411,  name = "Enchanting" },
    { id = 4036,  name = "Engineering" },
    { id = 2366,  name = "Herbalism" },
    { id = 45357, name = "Inscription" },
    { id = 25229, name = "Jewelcrafting" },
    { id = 2108,  name = "Leatherworking" },
    { id = 2575,  name = "Mining" },
    { id = 8613,  name = "Skinning" },
    { id = 3908,  name = "Tailoring" },
}

local frame = CreateFrame("Frame", "AllProfessionsFrame", UIParent)
frame:SetSize(290, 220)
frame:SetPoint("CENTER")
frame:SetFrameStrata("DIALOG")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
frame:Hide()

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -18)
title:SetText("All Professions")

local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -5, -5)

local buttons = {}

local function UpdateButtons()
    for index, profession in ipairs(professions) do
        local button = buttons[index]
        local spellName, _, icon = GetSpellInfo(profession.id)
        local known = IsSpellKnown(profession.id)

        button.icon:SetTexture(icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        button.spellName = spellName or profession.name
        button.known = known
        button:SetAlpha(known and 1 or 0.35)
    end
end

for index, profession in ipairs(professions) do
    local button = CreateFrame("Button", nil, frame)
    button:SetSize(42, 42)
    button:SetPoint("TOPLEFT", 20 + ((index - 1) % 6) * 45, -52 - math.floor((index - 1) / 6) * 50)

    local icon = button:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    button.icon = icon

    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    border:SetAllPoints()

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetSpellByID(profession.id)
        if not self.known then
            GameTooltip:AddLine("Not learned", 1, 0.2, 0.2)
        else
            GameTooltip:AddLine("Learned", 0.2, 1, 0.2)
        end
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", GameTooltip_Hide)

    buttons[index] = button
end

local function ToggleWindow()
    UpdateButtons()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

SLASH_ALLPROFESSIONS1 = "/professions"
SLASH_ALLPROFESSIONS2 = "/allprofessions"
SlashCmdList.ALLPROFESSIONS = ToggleWindow

local minimapButton = CreateFrame("Button", "AllProfessionsMinimapButton", Minimap)
minimapButton:SetSize(31, 31)
minimapButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -8, 8)
minimapButton:SetNormalTexture("Interface\\Icons\\Trade_Engineering")
minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
minimapButton:SetScript("OnClick", ToggleWindow)
minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:AddLine("All Professions")
    GameTooltip:AddLine("Click to open", 1, 1, 1)
    GameTooltip:Show()
end)
minimapButton:SetScript("OnLeave", GameTooltip_Hide)

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_LOGIN")
events:RegisterEvent("SPELLS_CHANGED")
events:SetScript("OnEvent", UpdateButtons)
