--------------------------------------------------------------------
--
--  Launcher - launches App in new Space
--
--------------------------------------------------------------------

local startSpace = 1

local log = hs.logger.new('launcher', 'info')

-- /System/Library/CoreServices/Finder.app
local predefinedChoises = {{ ["text"] = "Finder.app" }}

local excludeChoises = { "Utilities" }

local searchPath = "/Applications"

hs.hotkey.bind({'option'}, 'space', function()
    local chooser = hs.chooser.new(handleChoise)
  
    local choises = buildChoises()
    chooser:choices(choises)

    chooser:show()	
end)

function handleChoise(choise)
    if choise == nil then return end
		
    local application = choise["text"]
    hs.application.enableSpotlightForNameSearches(true)

    local applicationName = getApplicationName(application)

	local runningApp = hs.appfinder.appFromName(applicationName) 

    if runningApp ~= nil then -- app alredystarted
		runningApp:activate()
		return
    end

    local focusedSpaceId = hs.spaces.focusedSpace()
    local windows = hs.spaces.windowsForSpace(focusedSpaceId) 

    if #windows <= 2 then -- no app started in space
        hs.application.launchOrFocus(application)
		return
    end

    local freeSpaceId = findFreeSpace() 
    if freeSpaceId ~= -1 then
		hs.spaces.gotoSpace(freeSpaceId)
    end
        
    hs.application.launchOrFocus(application)
end

function getApplicationName(application)
	local name = application:gsub(".app", "")
	if name == "iTerm" then
		return "iTerm2"
	end
	return name
end

function buildChoises() 
    local choises = {}
   
    for i, value in ipairs(predefinedChoises) do
      	choises[i] = predefinedChoises[i] 
    end

    local index = #choises + 1

    for file in hs.fs.dir(searchPath) do
		if file:sub(1, 1) ~= "." then			
	    	if containsExcludeChoises(file) == false then
                choises[index] = {
                    ["text"] = file
                }
                index = index + 1
	    	end
        end
    end
    return choises
end

function containsExcludeChoises(choise)
    for i, value in ipairs(excludeChoises) do
        if value == choise then
	    	return true
        end
    end
    return false
end

function findFreeSpace()
    local screenUUID = hs.screen.mainScreen():getUUID()

    local freeSpaceId = findFreeSpaceByScreen(screenUUID) 

    if freeSpaceId == -1 then 
        hs.spaces.addSpaceToScreen(hs.screen.mainScreen():id())
        freeSpaceId = findFreeSpaceByScreen(screenUUID) 
    end
    return freeSpaceId
end

function findFreeSpaceByScreen(screenUUID)
    local spaces = hs.spaces.allSpaces()
    local spaceIds = spaces[screenUUID]

    for i=startSpace, #spaceIds do
		local spaceId = spaceIds[i]
    	local windowIds = hs.spaces.windowsForSpace(spaceId)

		if #windowIds <= 2 then -- allways up to 2 windows, app starts third window
	    	return spaceId
		end
    end
    return -1
end
