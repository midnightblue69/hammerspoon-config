--------------------------------------------------------
--
-- moves the actice application to next/previous space
--
--------------------------------------------------------
local log = hs.logger.new('window-move', 'info')

hs.hotkey.bind({'cmd'}, 'ö', function()
    moveWindowToSpace(getPreviousSpace)
end)

hs.hotkey.bind({'cmd'}, 'ä', function()
    moveWindowToSpace(getNextSpace)
end)

function moveWindowToSpace(getSpace) 
    local focusedSpaceId = hs.spaces.focusedSpace()
    local windows = hs.spaces.windowsForSpace(focusedSpaceId)
    local application = hs.application.frontmostApplication() 
    local window = application:mainWindow() 
    local spaceId = getSpace(focusedSpaceId)

    if window:isStandard() then  -- is selected
        hs.spaces.moveWindowToSpace(window, spaceId)
        hs.spaces.gotoSpace(spaceId)
    end
end

function getPreviousSpace(currentSpaceId)
    local spaceIds = getSpaceIds()

    for i = #spaceIds, 1, -1 do
		if spaceIds[i] == currentSpaceId then
	    	if i > 1 then
	        	return spaceIds[i-1]
	    	else
	        	return currenrSpaceId
	    	end
		end
    end
end


function getNextSpace(currentSpaceId)
    local spaceIds = getSpaceIds()

    for i = 1, #spaceIds, 1 do
		if spaceIds[i] == currentSpaceId then
	    	if i < #spaceIds then
	        	return spaceIds[i+1]
	    	else
	        	return currenrSpaceId
	    	end
		end
    end
end

function getSpaceIds()
    local spaces = hs.spaces.allSpaces()
    local screenUUID = hs.screen.mainScreen():getUUID()
    return spaces[screenUUID]
end
