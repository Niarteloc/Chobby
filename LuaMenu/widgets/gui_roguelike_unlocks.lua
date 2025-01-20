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
-- Reward tables

--Cloakbot
local cloakBase = {
    units = {
        "factorycloak",
        "cloakcon",
        "cloakraid"
    }
}
local cloakT1 = {
    units = {
        "cloakskirm",
        "cloakriot",
        "cloakaa"
    }
}
local cloakT2 = {
    units = {
        "cloakarty",
        "cloakassault"
    }
}
local cloakT3 = {
    units = {
        "cloaksnipe",
        "cloakheavyraid",
        "cloakbomb",
        "cloakjammer"
    }
}

--Rover
local roverBase = {
    units = {
        "factoryveh",
        "vehcon",
        "vehraid",
        "vehscout"
    }
}
local roverT1 = {
    units = {
        "vehriot",
        "vehassault",
        "vehaa"
    }
}
local roverT2 = {
    units = {
        "vehsupport",
        "veharty"
    }
}
local roverT3 = {
    units = {
        "vehcapture",
        "vehheavyarty"
    }
}

--Shieldbot

local shieldBase = {
    units = {
        "factoryshield",
        "shieldcon",
        "shieldraid"
    }
}
local shieldT1 = {
    units = {
        "shieldskirm",
        "shieldassault",
        "shieldaa"
    }
}
local shieldT2 = {
    units = {
        "shieldriot",
        "shieldfelon",
        "shieldscout"
    }
}
local shieldT3 = {
    units = {
        "shieldarty",
        "shieldshield",
        "shieldbomb"
    }
}

local cloakPath={cloakBase,cloakT1,cloakT2,cloakT3}
local shieldPath={shieldBase,shieldT1,shieldT2,shieldT3}
local roverPath={roverBase,roverT1,roverT2,roverT3}

local unlockLabel, left_pane, center_pane, right_pane, btnUnlockLeft, btnUnlockCenter, btnUnlockRight

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Intitialize

local function RefreshUnlockData()
    local progression = WG.RoguelikeData.GetRoguelikeProgression()
    local unlockPoints = WG.RoguelikeData.GetUnlockPoints()
    Spring.Echo("unlock state: "..progression[1].." "..progression[2].." "..progression[3].." "..unlockPoints)
    unlockLabel:SetCaption("Unlock Points: "..unlockPoints)
    if unlockPoints <= 0 or progression[1] > 4 then
        btnUnlockLeft:Hide()
    else
        btnUnlockLeft:Show()
    end
    if unlockPoints <= 0 or progression[2] > 4 then
        btnUnlockCenter:Hide()
    else
        btnUnlockCenter:Show()
    end
    if unlockPoints <= 0 or progression[3] > 4 then
        btnUnlockRight:Hide()
    else
        btnUnlockRight:Show()
    end
end

local function InitializeControls(parentControl)
    local Configuration = WG.Chobby.Configuration


    unlockLabel = Label:New {
        x = 20,
        right = 5,
        y = WG.TOP_LABEL_Y,
        height = 20,
        objectOverrideFont = Configuration:GetFont(3),
        caption = "Unlock Points: " .. WG.RoguelikeData.GetUnlockPoints(),
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

    left_pane = Window:New {
        classname = "main_window",
        x = "2.5%",
        y = "20%",
        width = "30%",
        height = "50%",
        resizable = false,
        draggable = false,
        padding = {0, 0, 0, 0},
        parent = parentControl

    }
    btnUnlockLeft = Button:New {
        x = "34.5%",
        width = "32%",
        bottom = WG.TOP_BUTTON_Y,
        height = WG.BUTTON_HEIGHT,
        caption = i18n("unlock"),
        objectOverrideFont = Configuration:GetButtonFont(3),
        classname = "positive_button",
        OnClick = {
            function()
                local progression = WG.RoguelikeData.GetRoguelikeProgression()
                local unlockPoints = WG.RoguelikeData.GetUnlockPoints()
                if unlockPoints > 0 and progression[1] < 5 then
                    WG.RoguelikeData.UnlockRewards(cloakPath[progression[1]])
                    progression[1] = progression[1] + 1
                    WG.RoguelikeData.UpdateProgression(progression)
                end
                RefreshUnlockData()
            end
        },
        parent = left_pane
    }


    center_pane = Window:New {
        classname = "main_window",
        x = "35%",
        y = "20%",
        width = "30%",
        height = "50%",
        resizable = false,
        draggable = false,
        padding = {0, 0, 0, 0},
        parent = parentControl

    }
    btnUnlockCenter = Button:New {
        x = "34.5%",
        width = "32%",
        bottom = WG.TOP_BUTTON_Y,
        height = WG.BUTTON_HEIGHT,
        caption = i18n("unlock"),
        objectOverrideFont = Configuration:GetButtonFont(3),
        classname = "positive_button",
        OnClick = {
            function()
                local progression = WG.RoguelikeData.GetRoguelikeProgression()
                local unlockPoints = WG.RoguelikeData.GetUnlockPoints()
                if unlockPoints > 0 and progression[2] < 5 then
                    WG.RoguelikeData.UnlockRewards(shieldPath[progression[2]])
                    progression[2] = progression[2] + 1
                    WG.RoguelikeData.UpdateProgression(progression)
                end
                RefreshUnlockData()
            end
        },
        parent = center_pane
    }


    right_pane = Window:New {
        classname = "main_window",
        x = "67.5%",
        y = "20%",
        width = "30%",
        height = "50%",
        resizable = false,
        draggable = false,
        padding = {0, 0, 0, 0},
        parent = parentControl

    }
    btnUnlockRight = Button:New {
        x = "34.5%",
        width = "32%",
        bottom = WG.TOP_BUTTON_Y,
        height = WG.BUTTON_HEIGHT,
        caption = i18n("unlock"),
        objectOverrideFont = Configuration:GetButtonFont(3),
        classname = "positive_button",
        OnClick = {
            function()
                local progression = WG.RoguelikeData.GetRoguelikeProgression()
                local unlockPoints = WG.RoguelikeData.GetUnlockPoints()
                if unlockPoints > 0 and progression[3] < 5 then
                    WG.RoguelikeData.UnlockRewards(roverPath[progression[3]])
                    progression[3] = progression[3] + 1
                    WG.RoguelikeData.UpdateProgression(progression)
                end
                RefreshUnlockData()
            end
        },
        parent = right_pane
    }

    RefreshUnlockData()
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
                else
                    RefreshUnlockData()
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