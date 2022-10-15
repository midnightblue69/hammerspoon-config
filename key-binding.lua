hs.hotkey.bind({'ctrl'}, 'v', nil, function()
	hs.eventtap.keyStroke({'cmd'}, 'v') 
end)

ctrlCBinding = hs.hotkey.bind({'ctrl'}, 'c', nil, function()
	hs.eventtap.keyStroke({'cmd'}, 'c')
end)

local wf = hs.window.filter
local kitty = wf.new("kitty")

kitty:subscribe(wf.windowFocused, function()
  ctrlCBinding:disable()
end):subscribe(wf.windowUnfocused, function()
  ctrlCBinding:enable()
end)

hs.hotkey.bind({'ctrl'}, 'x', nil, function()
	hs.eventtap.keyStroke({'cmd'},'x')	
end)

