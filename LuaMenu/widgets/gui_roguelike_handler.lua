--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Roguelike Handler",
		desc      = "Embark on Adventure",
		author    = "Niarteloc",
		date      = "30 Dec 2024",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

local GALAXY_IMAGE = LUA_DIRNAME .. "images/MinimapThumbnailsRandom_Plateaus_v1.0.jpg"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Ingame interface

local BATTLE_WON_STRING = "Roguelike_BattleWon"
local BATTLE_LOST_STRING = "Roguelike_BattleLost"
local BATTLE_RESIGN_STRING = "Roguelike_BattleResign"

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:RecvLuaMsg(msg)
    if not msg then
        Spring.Echo("LUA_ERR", "Bad roguelike message", msg)
        return
    end
    if string.find(msg, BATTLE_WON_STRING) then
        Spring.Echo("msg", msg)
        local data = msg:split(" ")
        Spring.Utilities.TableEcho(data, "data")
        local battleID = tonumber(data[2])
        local battleFrames = tonumber(data[3])
        local difficulty = tonumber(data[4]) or 0
        local losses = tonumber(data[5]) or 10000000

        WG.RoguelikeData.RecordWin()
    elseif string.find(msg, BATTLE_LOST_STRING) then
        Spring.Echo("msg", msg)
        local data = msg:split(" ")
        Spring.Utilities.TableEcho(data, "data")
        local battleID = tonumber(data[2])
        local battleFrames = tonumber(data[3])
    elseif string.find(msg, BATTLE_RESIGN_STRING) then
        Spring.Echo("msg", msg)
        local data = msg:split(" ")
        Spring.Utilities.TableEcho(data, "data")
        local battleID = tonumber(data[2])
        local battleFrames = tonumber(data[3])
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- External Interface

local externalFunctions = {}

function externalFunctions.GetControl()
	local window = Control:New {
		name = "roguelikeHandler",
		x = 0,
		y = 0,
		width = "100%",
		height = "100%",
		padding = {0,0,0,0},
		OnParentPost = {
			function(obj, parent)
				

				local background = WG.Chobby.interfaceRoot.GetBackgroundHolder()
				background:SetImageOverride(GALAXY_IMAGE)
				local x, y = obj:LocalToScreen(0, 0)

				obj:UpdateClientArea()
				WG.Chobby.interfaceRoot.GetRightPanelHandler().CloseTabs()
				WG.Chobby.interfaceRoot.GetMainWindowHandler().CloseTabs()
				if WG.LibLobby.lobby and WG.LibLobby.lobby:GetMyBattleID() then
					WG.LibLobby.lobby:LeaveBattle()
				end
			end
		},
		OnOrphan = {
			function(obj)
				if not obj.disposed then -- AutoDispose
					local background = WG.Chobby.interfaceRoot.GetBackgroundHolder()
					background:RemoveOverride()
				end
			end
		},
		OnResize = {
			function(obj, xSize, ySize)
				if not obj.parent then
					return
				end
				local x, y = obj:LocalToScreen(0, 0)
			end
		},
	}
	return window
end

function externalFunctions.GetMissionControl()
    local window = Control:New {
        classname = "mission_control",
		x = 0,
		y = 0,
		width = "100%",
		height = "100%",
		resizable = false,
		padding = {0, 0, 0, 0},
        
        
    }
    local battlePanel = Window:New{
		classname = "main_window",
		parent = window,
		x = 32,
		y = 32,
		right = 32,
		bottom = 32,
		resizable = false,
		draggable = false,
		padding = {12, 7, 12, 7},
	}
    
    local startButton = Button:New{
        right = 0,
        bottom = 0,
        width = 160,
        height = 61,
        classname = "action_button",
        parent = battlePanel,
        caption = i18n("start"),
        OnClick = {
            function ()
                    WG.RoguelikeBattleHandler.StartBattle(1,{
                        gameConfig = {
                            missionStartscript = false,
                            mapName = "Living Lands 4.1",
                            playerConfig = {
                                startX = 300,
                                startZ = 3800,
                                allyTeam = 0,
                                commanderParameters = {
                                    facplop = true,
                                    defeatIfDestroyedObjectiveID = 2,
                                },
                            },
                            aiConfig = {
                                {
                                    startX = 4000,
                                    startZ = 75,
                                    aiLib = "Circuit_difficulty_autofill",
                                    humanName = "Enemy",
                                    bitDependant = true,
                                    commanderParameters = {
                                        facplop = false,
                                    },
                                    allyTeam = 1,
                                    unlocks = {
                                        "cloakraid",
                                    },
                                    difficultyDependantUnlocks = {
                                         [3] = {"staticmex","energysolar"},
                                         [4] = {"staticmex","energysolar","cloakcon"},
                                     },
                                    commanderLevel = 2,
                                    commander = {
                                        name = "Most Loyal Opposition",
                                        chassis = "engineer",
                                        decorations = {
                                          "skin_support_dark",
                                        },
                                        modules = {}
                                    },
                                    startUnits = {
                                        {
                                            name = "staticmex",
                                            x = 3630,
                                            z = 220,
                                            facing = 2,
                                            difficultyAtLeast = 2,
                                        },
                                        {
                                            name = "staticmex",
                                            x = 3880,
                                            z = 200,
                                            facing = 2,
                                            difficultyAtLeast = 3,
                                        },
                                        {
                                            name = "turretlaser",
                                            x = 3500,
                                            z = 200,
                                            facing = 3,
                                            difficultyAtLeast = 2,
                                        },
                                        {
                                            name = "turretlaser",
                                            x = 3700,
                                            z = 700,
                                            facing = 0,
                                            difficultyAtLeast = 3,
                                        },
                                        {
                                            name = "turretemp",
                                            x = 3400,
                                            z = 600,
                                            facing = 1,
                                            difficultyAtLeast = 4,
                                        },
                                        {
                                            name = "staticmex",
                                            x = 3880,
                                            z = 520,
                                            facing = 2,
                                            difficultyAtLeast = 4,
                                        },
                                        {
                                            name = "energysolar",
                                            x = 3745,
                                            z = 185,
                                            facing = 2,
                                        },
                                        {
                                            name = "energysolar",
                                            x = 3960,
                                            z = 600,
                                            facing = 2,
                                        },
                                        {
                                            name = "factorycloak",
                                            x = 3750,
                                            z = 340,
                                            facing = 4,
                                            mapMarker = {
                                                text = "Destroy",
                                                color = "red"
                                            }
                                        },
                                    
                                    }
                                },
                            },
                            defeatConditionConfig = {
                                -- Indexed by allyTeam.
                                [0] = { },
                                [1] = {
                                    -- The default behaviour, if no parameters are set, is the defeat condition of an
                                    -- ordinary game.
                                    -- If ignoreUnitLossDefeat is true then unit loss does not cause defeat.
                                    -- If at least one of vitalCommanders or vitalUnitTypes is set then losing all
                                    -- commanders (if vitalCommanders is true) as well as all the unit types in
                                    -- vitalUnitTypes (if there are any in the list) causes defeat.
                                    ignoreUnitLossDefeat = false,
                                    vitalCommanders = true,
                                    vitalUnitTypes = {
                                        "factorycloak",
                                    },
                                    loseAfterSeconds = false,
                                    allyTeamLossObjectiveID = 1,
                                },
                            },
                        }
                    })
            end
        }
    }
    
    return window
end

--------------------------------------------------------------------------------
-- Callins
--------------------------------------------------------------------------------


function widget:ViewResize(vsx, vsy)
	WG.Delay(DelayedViewResize, 0.1)
	WG.Delay(DelayedViewResize, 0.8)
end

function widget:Initialize()
	CHOBBY_DIR = "LuaMenu/widgets/chobby/"
	VFS.Include("LuaMenu/widgets/chobby/headers/exports.lua", nil, VFS.RAW_FIRST)
	

	WG.RoguelikeHandler = externalFunctions
end

function widget:Shutdown()
	WG.RoguelikeHandler = nil
end
