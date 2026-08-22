local RJelly = loadstring(Game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Libraries/RJelly/RJellyUI.lua"))()

local Window = RJelly:MakeWindow("MyWindow")
local Tab = Window:MakeTab("MyTab")

Tab:MakeButton("Click me!",function() -- BUTTON
  -- Here you can run codes
  print('do something')
end)

Tab:MakeToggle("Toggle",function(value) -- TOGGLE
  -- Here you can run codes
  -- Value is either true/false

  if value == true then
    print("Toggle on")
  else
    print("Toggle off")
  end
end)

Tab:MakeInput("Print ANYTHING",function(input, enterPressed) -- TEXTBOX
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
