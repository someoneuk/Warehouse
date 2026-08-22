<img src="logo.png" alt="RJelly logo" width="200">

# RJelly - Fast and simple ⚡
<br/>

- New version!! (v1)

## This GUI Library is under development. 👷‍♂️
<br/>

To use this GUI Library we can start by loading it using
```lua
local RJelly = loadstring(Game:HttpGet("https://raw.githubusercontent.com/someoneuk/Warehouse/refs/heads/main/Libraries/RJelly/RJellyUI.lua"))()
```
<br/>

Then we can start by making a window with
```lua
local Window = RJelly:MakeWindow("MyWindow")
```
<br/>

There! now that we got the window we can use it to create, tabs, buttons, etc
<br>
First let's try creating a tab.
```lua
local Tab = Window:MakeTab("MyTab")
```
<br>

Then we make a button that does something
```lua
Tab:MakeButton("Click me!",function()
  -- Here you can run codes
  print('do something')
end)
```
<br>

And a toggle cause why not
```lua
Tab:MakeToggle("Toggle",function(value)
  -- Here you can run codes
  -- Value is either true/false

  if value == true then
    print("Toggle on")
  else
    print("Toggle off")
  end
end)
```
<br>

Maybe a TextBox too!
```lua
Tab:MakeInput("Print ANYTHING",function(input, enterPressed)
  if enterPressed then
    print("you typed "..input.." and pressed enter!")
  else
    print("you typed "..input.." without pressing enter!")
  end
end)
```
<br>

Or a set options!
```lua
local Dropdown = Tab:MakeDropdown("Dropdown Prints")
Dropdown:AddOption("Hello",function()
  print("Hello")
end)

Dropdown:AddOption("Goodbye",function()
  print("Goodbye")
end)
```
<br>

That's all, if you're using this library then thanks for using it! 👍
<br>
you can check out my examplescript you can instantly execute here!<br>
[Example script](examplescript.lua)
