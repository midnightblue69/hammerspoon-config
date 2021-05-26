local tolerancePoints = 1

-- Toggle between Fullsrenn and maximum Size
hs.hotkey.bind({}, 111, function()
	local app = hs.application.frontmostApplication()
	local win = app:mainWindow()
	local fullScreen = win:isFullScreen() 
	win:toggleFullScreen()
	
	if fullScreen == true then
		win:maximize()
	end
end)		

-- Windows Sizing
hs.hotkey.bind({'cmd', 'alt'}, '1', function()
	moveWindowToUnit(hs.layout.left30)		
end)

hs.hotkey.bind({'cmd', 'alt'}, '2', function()
	moveWindowToUnit(hs.layout.left50)		
end)

hs.hotkey.bind({'cmd', 'alt'}, '3', function()
	moveWindowToUnit(hs.layout.left70)		
end)

hs.hotkey.bind({'cmd', 'alt'}, '9', function()
	moveWindowToUnit(hs.layout.right30)		
end)

hs.hotkey.bind({'cmd', 'alt'}, '8', function()
	moveWindowToUnit(hs.layout.right50)		
end)

hs.hotkey.bind({'cmd', 'alt'}, '7', function()
	moveWindowToUnit(hs.layout.right70)		
end)


function moveWindowToUnit(unit)
	local app = hs.application.frontmostApplication()
	local win = app:mainWindow()
	win:moveToUnit(unit)		
end

-- Toggel Windows Sizing
hs.hotkey.bind({'cmd', 'alt'}, 'left', function()
	moveWindowTo('left')
end)


hs.hotkey.bind({'cmd', 'alt'}, 'right', function()
	moveWindowTo('right')
end)

function moveWindowTo(direction)
	log = hs.logger.new('window', 'info')

	local layout30 = hs.layout.left30
	local layout50 = hs.layout.left50
	local layout70 = hs.layout.left70

	if direction == 'right' then
		layout30 = hs.layout.right30
		layout50 = hs.layout.right50
		layout70 = hs.layout.right70
	end

	local screenWidth = getScreenWidth()
	screenWidth30 = 0.3 * screenWidth
	screenWidth50 = 0.5 * screenWidth
    screenWidth70 = 0.7 * screenWidth

	local win = getMainWindow()
	local size = win:size()

	log.i('screen-width: ', screenWidth)
	log.i('window-width: ', size.w)

	local inRange70 = isInRange(screenWidth70, size.w)
	local inRange50 = isInRange(screenWidth50, size.w)
	local inRange30 = isInRange(screenWidth30, size.w)
	
    if (inRange30 or inRange50 or inRange70) then
		if (inRange50 or inRange70) then
			if (inRange70) then
				win:maximize()
			else
				moveWindow(win, layout70)
			end
		else
			moveWindow(win, layout50, layout70)
		end
	else
		moveWindow(win, layout30, layout50)
	end	
	
end

function getMainWindow()
	local app = hs.application.frontmostApplication()
	local win = app:mainWindow()
	return win
end

function getScreenWidth()
	local screen = hs.screen.mainScreen()
	local values = screen:currentMode()
	return values["w"]
end

function isInRange(screenWidth, width)
	return width >= screenWidth - tolerancePoints and width <= screenWidth + tolerancePoints  
end

function moveWindow(win, unit, nextUnit)
	win:moveToUnit(unit, 0) -- set to 0 to update the size immediately
	
	-- in same cases the minisize of an App is larger than the selected size
	-- to fix this the switch goes to the next size
	if widthBetweenRanges(win:size().w) then
		if nextUnit == nil then
			win:maximize()
		else
			win:moveToUnit(nextUnit, 0)
		end
	end
end

function widthBetweenRanges(width)
	return (width > screenWidth30 and width < screenWidth50) or
		   (width > screenWidth50 and witdh < screenWidth70 + tolerancePoints) or
			width > screenWidth70 - tolerancePoints
end


