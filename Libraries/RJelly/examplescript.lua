local RJelly = loadstring(game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Libraries/RJelly/RJellyUI.lua"))()

local Window = RJelly:MakeWindow("MyWindow")
local Tab = Window:MakeTab("MyTab")

local Button = Tab:MakeButton("Click me!",function() -- BUTTON
	-- Here you can run codes
	print('do something')
end)

local Toggle = Tab:MakeToggle("Toggle",function(value) -- TOGGLE
	-- Here you can run codes
	-- Value is either true/false

	if value == true then
		print("Toggle on")
	else
		print("Toggle off")
	end
end)

local Input = Tab:MakeInput("Print ANYTHING",function(input, enterPressed) -- TEXTBOX
	if enterPressed then
		print("you typed "..input.." and pressed enter!")
	else
		print("you typed "..input.." without pressing enter!")
	end
end)

local Dropdown = Tab:MakeDropdown("Dropdown Prints") -- DROPDOWN
Dropdown:AddOption("Hello",function()
	print("Hello")
end)

Dropdown:AddOption("Goodbye",function()
	print("Goodbye")
end)

Tab:MakeLabel("Header") -- LABEL
Tab:MakeSpace(15) -- SPACE, just a gap, doesn't need a variable

-- every element gives you back a module now, so you can control it after making it
-- here's a couple examples using the Button and Toggle we made above

Button:SetTitle("Click me again!")

if Toggle:GetValue() == false then
	Toggle:SetNextActivationValue(true) -- next time it's clicked, it'll turn on
end
