local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "MS Studio",
    Icon = "compass",
    Author = "Game Name",
    Folder = "ProjectHubConfig",
    Size = UDim2.fromOffset(560, 400),
    Transparent = true,
    Theme = "Rose",
    Resizable = true,
    SideBarWidth = 170,
    User = {
        Enabled = true,
        Anonymous = false
    }
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Anti AFK
local antiAfkConnection = nil
local function EnableAntiAFK()
    if antiAfkConnection then antiAfkConnection:Disconnect() end
    antiAfkConnection = LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
    end)
end
EnableAntiAFK()

-- Floating Toggle Button
if game:GetService("CoreGui"):FindFirstChild("WindUIToggleGui") then
    game:GetService("CoreGui").WindUIToggleGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
elseif protectgui then
    protectgui(ScreenGui)
end

ScreenGui.Name = "WindUIToggleGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

ToggleBtn.Name = "ToggleButton"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.5
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.Size = UDim2.new(0, 55, 0, 55)
ToggleBtn.Image = "rbxassetid://70798471688053"
ToggleBtn.ScaleType = Enum.ScaleType.Fit
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = ToggleBtn

UIStroke.Color = Color3.fromRGB(255, 102, 153)
UIStroke.Thickness = 2.5
UIStroke.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    if Window and Window.Toggle then
        Window:Toggle()
    end
end)

-- Core Game Services & Module Loader
local COH = ReplicatedStorage:WaitForChild("ChickenOrHero", 5)
local Movement = COH and COH:WaitForChild("Movement", 5)
local MovementProfiles = Movement and require(Movement:WaitForChild("MovementProfiles"))
local BoostInput = Movement and require(Movement:WaitForChild("BoostInput"))
local Game = COH and COH:WaitForChild("Game", 5)
local Session = Game and Game:WaitForChild("Session", 5)
local MapVoteState = Game and Game:WaitForChild("MapVoteState", 5)
local MapVoteEvent = Game and Game:WaitForChild("MapVoteEvent", 5)
local ContactCatchConfig = Game and require(Game:WaitForChild("ContactCatchConfig"))
local TacklePrediction = Game and require(Game:WaitForChild("TacklePrediction"))
local MeleeEvent = Game and Game:WaitForChild("MeleeEvent", 5)
local RescueConfig = Game and require(Game:WaitForChild("RescueConfig"))
local RESCUE_RANGE = RescueConfig and math.max(3, tonumber(RescueConfig.Range) or 6) - 0.25 or 5.75
local RESCUE_HOLD = RescueConfig and math.max(0.1, tonumber(RescueConfig.HoldSeconds) or 1.2) or 1.2
local RESCUE_FINISH_GRACE = RescueConfig and math.max(0.1, tonumber(RescueConfig.FinishGrace) or 0.5) or 0.5
local RescueEvent = Game and Game:WaitForChild("RescueEvent", 5)
local Gear = COH and COH:WaitForChild("Gear", 5)
local GearCatalog = Gear and require(Gear:WaitForChild("GearCatalog"))
local ArmoryEvent = COH and COH:WaitForChild("Weapons", 5):WaitForChild("ArmoryEvent", 5)
local SpinWheelEvent = COH and COH:WaitForChild("SpinWheelEvent", 5)
local Progression = COH and COH:WaitForChild("Progression", 5)
local JourneyConfig = Progression and require(Progression:WaitForChild("JourneyConfig"))
local JourneyEvent = Progression and Progression:WaitForChild("JourneyEvent")
local PlayerPreferences = Game and Game:WaitForChild("PlayerPreferences", 5)

-- Global State & Settings
local SETTINGS = {
    runnerEnabled = true,
    strategy = "Hero",
    customSpeed = false,
    speedMultiplier = 1.0,
    autoGems = true,
    gemScanInterval = 0.25,
    gemMaxDistance = 220,
    gemCollectDistance = 4.5,
    autoRevive = true,
    reviveBeforeGems = true,
    reviveMaxDistance = 220,
    avoidCatchers = true,
    predictionTime = 0.65,
    avoidStrength = 2.2,
    panicDistance = 15,
    safezoneDepthRatio = 0.52,
    safezoneValidationRatio = 0.44,
    safezoneEdgeMargin = 4.5,
    edgeRayHeight = 12,
    edgeRayDepth = 52,
    edgeLookAhead = 14,
    edgeSecondLookAhead = 28,
    autoDash = true,
    dashCooldown = 0.85,
    dashDistance = 48,
    dashClosingSpeed = 10,
    smoothMovement = true,
    turnRate = 9,
    emergencySafeZone = true,
    showThreats = true,
    showGoal = true,
    corridorEnabled = true,
    corridorMinWidth = 4.25,
    corridorCenterRange = 26,
    corridorLockTime = 1.65,
    corridorPassDistance = 20,
    corridorApproachDistance = 60,
    sideGapEnabled = true,
    sideGapAngles = {18, 30, 42, 54, 68, 82},
    sideGapMinClearance = 3.5,
    sideGapCommitTime = 0.8,
    sideGapForwardBias = 6.5,
    catcherChase = true,
    catcherCustomSpeed = false,
    catcherSpeedMultiplier = 1.0,
    catcherPrediction = 0.45,
    catcherSmoothing = 6,
    smartPriority = true,
    catcherAttackPriority = "Smart",
    autoTackle = true,
    tackleRange = 12,
    tackleCooldown = 1.2,
    autoMelee = true,
    meleeRange = 9,
    meleeCooldown = 0.35,
    smoothTurn = true,
    turnRateCatcher = 14,
    followTarget = true,
    showHitboxes = true,
    showGoalUtility = true,
    showThreatUtility = false,
    showDebugUI = false,
    cameraFollow = true,
    cameraResponse = 0.25,
    autoSpinWheel = false,
    wheelSpinInterval = 6,
    wheelMinimumCredits = 1,
    wheelAnnounce = true,
    autoClaimJourneyRewards = false,
    journeyClaimAnnounce = true,
    autoMapVote = false,
    mapVoteAnnounce = true,
    mapVoteSelections = {},
    disableBuiltinAFK = false,
}

local runtime = {
    profile = nil, profileRole = nil, runnerTick = 0, runnerPlanAt = -math.huge,
    runnerPlanDirection = Vector3.zero, runnerPlanGoal = Vector3.zero, catcherTick = 0,
    utilityTick = 0, lastMove = os.clock(), lastMovePosition = nil, moveCommandAt = -math.huge,
    stuck = false, path = Vector3.zero, goal = nil, goalMode = "SafeZone", goalSide = nil,
    assistMode = nil, assistTarget = nil, assistSince = -math.huge, gemTarget = nil,
    gemIgnored = {}, gemScanAt = -math.huge, reviveTarget = nil, reviveStarted = false,
    reviveStartAt = 0, reviveInputToken = 0, catchers = {}, catcherCacheAt = 0,
    threats = {}, threatAt = 0, threatHistory = {}, dashAt = -math.huge, dashStatus = "idle",
    dashLastRequestAt = -math.huge, dashLastCount = nil, ping = 0, pingAt = 0,
    armory = {loaded = false, abilities = {}}, armoryAt = -math.huge, catcherTargets = {},
    catcherTargetAt = 0, catcherTarget = nil, edgeRisk = false, edgeDirection = Vector3.zero,
    catcherPath = Vector3.zero, catcherVelocity = {}, meleeId = 0, lastMelee = -math.huge,
    lastTackle = -math.huge, mapCacheAt = -math.huge, mapCache = nil, edgeCheckAt = -math.huge,
    edgeCheckPosition = nil, edgeCheckDirection = Vector3.zero, edgeCheckGoal = Vector3.zero,
    edgeRecoveryAt = -math.huge, edgeRecoveryDirection = Vector3.zero, edgeRecoveryUntil = -math.huge,
    stuckRecoveryUntil = -math.huge, stuckRecoveryDirection = Vector3.zero, safeCheckAt = -math.huge,
    safeCheckPosition = nil, safeCheckA = false, safeCheckB = false, routeActive = false,
    routeComplete = false, routeStartSide = nil, routeTargetSide = nil, routeCompletePosition = nil,
    routeCompleteAt = -math.huge, corridorActive = false, corridorGoal = Vector3.zero,
    corridorCenter = Vector3.zero, corridorAxis = Vector3.zero, corridorGapWidth = 0,
    corridorStartedAt = -math.huge, sideGapDirection = Vector3.zero, sideGapUntil = -math.huge,
    sideGapReason = "", wheelScanAt = -math.huge, wheelActionAt = -math.huge, wheelStatus = "disabled",
    wheelLastButton = nil, wheelSpinCount = 0, wheelCredits = 0, wheelNextFreeAt = 0,
    wheelPurchasesAvailable = false, wheelDiscountAvailable = false, wheelStateRequestAt = -math.huge,
    wheelSpinRequestAt = -math.huge, wheelEventReady = false, wheelSpinning = false,
    wheelLastStateAt = -math.huge, wheelStatusAt = -math.huge, wheelNextAttemptAt = -math.huge,
    wheelMinimumCredits = 1, afkOverrideStatus = "disabled", afkOverrideLastRequestAt = -math.huge,
    afkOverrideRequestInterval = 2.0, afkOverrideInLobby = false, afkOverrideRequestCount = 0,
    journeyScanAt = -math.huge, journeyStatus = "disabled", journeyClaimCount = 0,
    journeyLastClaimAt = -math.huge, journeyClaimedButtons = {}, journeyLoaded = false,
    journeySeasonId = nil, journeyRequestAt = -math.huge, journeyClaimInFlight = false,
    journeyLastStateAt = -math.huge, journeyTier = 1, journeyPremium = false, journeyClaims = {},
    journeyLastClaimResultAt = -math.huge, mapVoteScanAt = -math.huge, mapVoteStatus = "disabled",
    mapVoteOptions = {}, mapVoteLastActionAt = -math.huge, mapVoteOpen = false,
    mapVotePhase = "Waiting", mapVoteToken = nil, mapVoteOptionIds = {}, mapVoteLastStateAt = -math.huge,
    debugLastError = nil, debugLastErrorAt = -math.huge, debugEnabled = false, debugGui = nil,
    debugLabel = nil, debugPanelAt = -math.huge, journeyNextClaimAt = -math.huge, journeyManualPending = false,
}

local MAP_VOTE_SLOT_IDS = {"Map 1", "Map 2", "Map 3"}

local function getCharacter(player) return (player or LocalPlayer).Character end
local function getHumanoid(player) local c = getCharacter(player) return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot(player) local c = getCharacter(player) return c and c:FindFirstChild("HumanoidRootPart") end
local function getRole() return LocalPlayer:GetAttribute("GameRole") or "Lobby" end
local function getRunState() return LocalPlayer:GetAttribute("RunState") or "Idle" end

-- UI Tabs Setup
local RunnerTab = Window:Tab({Title = "Runner", Icon = "footprints"})
local CatcherTab = Window:Tab({Title = "Catcher", Icon = "crosshair"})
local WheelTab = Window:Tab({Title = "Wheel", Icon = "rotate-cw"})
local JourneyTab = Window:Tab({Title = "Journey", Icon = "gift"})
local MapVoteTab = Window:Tab({Title = "Map Vote", Icon = "map"})
local UtilitiesTab = Window:Tab({Title = "Utilities", Icon = "wrench"})

-- RUNNER TAB
local RunnerStatusParagraph = RunnerTab:Paragraph({
    Title = "Runner Status",
    Desc = "Role: Lobby\nState: Idle\nGoal: None",
})

RunnerTab:Section({Title = "Movement Controls"})

RunnerTab:Toggle({
    Title = "Auto Run",
    Desc = "Automatically travel between Safe Zones with threat and edge checks.",
    Value = SETTINGS.runnerEnabled,
    Callback = function(v) SETTINGS.runnerEnabled = v end,
})

RunnerTab:Toggle({
    Title = "Auto Revive Players",
    Desc = "Automatically revive downed team members.",
    Value = SETTINGS.autoRevive,
    Callback = function(v) SETTINGS.autoRevive = v end,
})

RunnerTab:Toggle({
    Title = "Runner Speed Override",
    Desc = "Enable custom runner movement speed multiplier.",
    Value = SETTINGS.customSpeed,
    Callback = function(v) SETTINGS.customSpeed = v end,
})

RunnerTab:Slider({
    Title = "Runner Speed Multiplier",
    Step = 0.05,
    Value = {Min = 1.0, Max = 2.0, Default = 1.0},
    Callback = function(v) SETTINGS.speedMultiplier = tonumber(v) end,
})

RunnerTab:Section({Title = "Collection & Safety"})

RunnerTab:Toggle({
    Title = "Auto Collect Gems",
    Desc = "Automatically collect nearby Runner Gems.",
    Value = SETTINGS.autoGems,
    Callback = function(v) SETTINGS.autoGems = v end,
})

RunnerTab:Toggle({
    Title = "Avoid Catchers",
    Desc = "Predict and avoid nearby Catcher positions.",
    Value = SETTINGS.avoidCatchers,
    Callback = function(v) SETTINGS.avoidCatchers = v end,
})

RunnerTab:Toggle({
    Title = "Auto Dash",
    Desc = "Automatically dash when catchers get close.",
    Value = SETTINGS.autoDash,
    Callback = function(v) SETTINGS.autoDash = v end,
})

-- CATCHER TAB
local CatcherStatusParagraph = CatcherTab:Paragraph({
    Title = "Catcher Status",
    Desc = "Role: Lobby\nState: Idle\nTarget: None",
})

CatcherTab:Section({Title = "Targeting & Combat"})

CatcherTab:Toggle({
    Title = "Auto Chase",
    Desc = "Automatically chase the target Runner.",
    Value = SETTINGS.catcherChase,
    Callback = function(v) SETTINGS.catcherChase = v end,
})

CatcherTab:Dropdown({
    Title = "Attack Priority",
    Values = {"Smart", "Tackle First", "Melee First"},
    Value = "Smart",
    Callback = function(v) SETTINGS.catcherAttackPriority = type(v) == "table" and v[1] or v end,
})

CatcherTab:Toggle({
    Title = "Auto Tackle",
    Desc = "Tackle automatically when target is in range.",
    Value = SETTINGS.autoTackle,
    Callback = function(v) SETTINGS.autoTackle = v end,
})

CatcherTab:Toggle({
    Title = "Auto Melee",
    Desc = "Melee attack automatically when target is in range.",
    Value = SETTINGS.autoMelee,
    Callback = function(v) SETTINGS.autoMelee = v end,
})

CatcherTab:Slider({
    Title = "Tackle Range",
    Step = 0.5,
    Value = {Min = 5, Max = 25, Default = 12},
    Callback = function(v) SETTINGS.tackleRange = tonumber(v) end,
})

CatcherTab:Slider({
    Title = "Melee Range",
    Step = 0.5,
    Value = {Min = 3, Max = 15, Default = 9},
    Callback = function(v) SETTINGS.meleeRange = tonumber(v) end,
})

-- WHEEL TAB
WheelTab:Section({Title = "Auto Spin"})

WheelTab:Toggle({
    Title = "Enable Auto Spin",
    Desc = "Automatically spin the wheel when you have credits.",
    Value = SETTINGS.autoSpinWheel,
    Callback = function(v) SETTINGS.autoSpinWheel = v end,
})

WheelTab:Slider({
    Title = "Minimum Credits",
    Step = 1,
    Value = {Min = 1, Max = 50, Default = 1},
    Callback = function(v) SETTINGS.wheelMinimumCredits = tonumber(v) end,
})

-- JOURNEY TAB
JourneyTab:Section({Title = "Auto Claim"})

JourneyTab:Toggle({
    Title = "Auto Claim Rewards",
    Desc = "Automatically claim unlocked Journey rewards in lobby.",
    Value = SETTINGS.autoClaimJourneyRewards,
    Callback = function(v) SETTINGS.autoClaimJourneyRewards = v end,
})

-- MAP VOTE TAB
MapVoteTab:Section({Title = "Voting Options"})

MapVoteTab:Dropdown({
    Title = "Preferred Map",
    Values = MAP_VOTE_SLOT_IDS,
    Value = MAP_VOTE_SLOT_IDS[1],
    Callback = function(v) SETTINGS.mapVoteSelections = {type(v) == "table" and v[1] or v} end,
})

MapVoteTab:Toggle({
    Title = "Auto Vote",
    Desc = "Automatically vote for selected map slot when vote phase starts.",
    Value = SETTINGS.autoMapVote,
    Callback = function(v) SETTINGS.autoMapVote = v end,
})

-- UTILITIES TAB
UtilitiesTab:Section({Title = "Visual & Camera"})

UtilitiesTab:Toggle({
    Title = "Follow Target Camera",
    Desc = "Smoothly lock camera onto target.",
    Value = SETTINGS.followTarget,
    Callback = function(v) SETTINGS.followTarget = v end,
})

UtilitiesTab:Toggle({
    Title = "Show Goal",
    Desc = "Display visual marker on current goal position.",
    Value = SETTINGS.showGoal,
    Callback = function(v) SETTINGS.showGoal = v end,
})

UtilitiesTab:Toggle({
    Title = "Show Threats",
    Desc = "Highlight danger zones predicted by the algorithm.",
    Value = SETTINGS.showThreats,
    Callback = function(v) SETTINGS.showThreats = v end,
})

UtilitiesTab:Toggle({
    Title = "Show Hitboxes",
    Desc = "Display player interaction hitboxes.",
    Value = SETTINGS.showHitboxes,
    Callback = function(v) SETTINGS.showHitboxes = v end,
})

-- Background Heartbeat Engine
RunService.RenderStepped:Connect(function(dt)
    local character = getCharacter()
    local hum = getHumanoid()
    local root = getRoot()

    if not character or not hum or hum.Health <= 0 or not root then return end

    local role = getRole()
    local nativeOutput = tonumber(character:GetAttribute("MovementSpeed")) or 16
    if role == "Runner" and SETTINGS.customSpeed then
        hum.WalkSpeed = nativeOutput * math.clamp(SETTINGS.speedMultiplier, 1, 2)
    elseif role == "Catcher" and SETTINGS.catcherCustomSpeed then
        hum.WalkSpeed = nativeOutput * math.clamp(SETTINGS.catcherSpeedMultiplier, 1, 2)
    end

    RunnerStatusParagraph:SetTitle("Runner: " .. tostring(role))
    RunnerStatusParagraph:SetDesc(string.format("State: %s\nGoal: %s", tostring(getRunState()), tostring(runtime.goalMode)))
    
    CatcherStatusParagraph:SetTitle("Catcher: " .. tostring(role))
    CatcherStatusParagraph:SetDesc(string.format("State: %s\nTarget: %s", tostring(getRunState()), runtime.catcherTarget and runtime.catcherTarget.Name or "None"))
end)

WindUI:Notify({
    Title = "MS Studio Hub",
    Content = "Script loaded successfully!",
    Duration = 4,
    Icon = "check"
})
