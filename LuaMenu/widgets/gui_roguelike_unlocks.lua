--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
    return {
        name      = "Roguelike Unlock Panel",
        desc      = "Panel for spending roguelike unlock points",
        author    = "Niarteloc",
        date      = "1 Jan 2025",
        license   = "GNU LGPL, v2 or later",
        layer     = 0,
        enabled   = true  --  loaded by default?
    }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Intitialize

local function InitializeControls(parentControl)
    local Configuration = WG.Chobby.Configuration

    Label:New {
        x = 20,
        right = 5,
        y = WG.TOP_LABEL_Y,
        height = 20,
        objectOverrideFont = Configuration:GetFont(3),
        caption = i18n("technology"),
        parent = parentControl
    }

    local btnClose = Button:New {
        right = 11,
        y = WG.TOP_BUTTON_Y,
        width = 80,
        height = WG.BUTTON_HEIGHT,
        caption = i18n("close"),
        objectOverrideFont = Configuration:GetButtonFont(3),
        classname = "negative_button",
        OnClick = {
            function()
                parentControl:Hide()
            end
        },
        parent = parentControl
    }

    local btnUnlock = Button:New {
        right = 101,
        y = WG.TOP_BUTTON_Y,
        width = 80,
        height = WG.BUTTON_HEIGHT,
        caption = i18n("unlock"),
        objectOverrideFont = Configuration:GetButtonFont(3),
        classname = "negative_button",
        OnClick = {
            function()
                WG.RoguelikeData.UnlockRewards({
                    units = {
                        "cloakcon",
                        "cloakriot",
                        "staticradar",
                        "turretlaser"
                    }
                })
            end
        },
        parent = parentControl
    }
end

local UnlockPanel = {}

function UnlockPanel.GetControl()
    local window = Control:New {
        name = "unlockpanel",
        x = 0,
        y = 0,
        right = 0,
        bottom = 0,
        padding = {0, 0, 0, 0},
        OnParent = {
            function(obj)
                if obj:IsEmpty() then
                    InitializeControls(obj)
                end
            end
        },
    }
    return window
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Widget Interface

function widget:Initialize()
    CHOBBY_DIR = LUA_DIRNAME .. "widgets/chobby/"
    VFS.Include(LUA_DIRNAME .. "widgets/chobby/headers/exports.lua", nil, VFS.RAW_FIRST)

    WG.UnlockPanel = UnlockPanel
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------