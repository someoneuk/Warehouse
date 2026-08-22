-- v1
local rjellyui = {}
do -- essential functions
	function AddStroke(v:Instance, col:Color3?, t:number?)
		local Stroke = Instance.new("UIStroke")
		Stroke.Parent = v
		Stroke.Color = col or Color3.new()
		Stroke.Thickness = t or 1
		Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		
		return Stroke
	end
	
	function getSizeOffset(a:Instance, axis:string) -- this is here just to save 10ms and short things out
		if string.lower(axis) == 'x' then
			return a.Size.X.Offset
		else
			return a.Size.Y.Offset
		end
	end
	
end


-- initialize
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')

local Screen = Instance.new('ScreenGui')
Screen.Name = "RJelly"..os.clock()
Screen.Parent = game:GetService('CoreGui')
Screen.IgnoreGuiInset = true

function rjellyui:MakeWindow(title:string)

	local Window = Instance.new('Frame')
	Window.Parent = Screen
	Window.BackgroundColor3 = Color3.new(1,1,1)
	Window.Name = title or "Window"
	Window.Position = UDim2.fromOffset(75,75)
	Window.Size = UDim2.fromOffset(300,300)
	AddStroke(Window)
	
	local Topbar = Instance.new('Frame')
	Topbar.Parent = Window
	Topbar.Name = "Topbar"
	Topbar.BackgroundColor3 = Color3.fromRGB(153, 11, 200)
	Topbar.Size = UDim2.new(1,0,0,25)
	AddStroke(Topbar)
	
	local WindowContent = Instance.new('Frame')
	WindowContent.Parent = Window
	WindowContent.Name = "Content"
	WindowContent.BackgroundColor3 = Color3.new(1,1,1)
	WindowContent.Size = UDim2.new(1,0,0,getSizeOffset(Window,'y') - getSizeOffset(Topbar,'y')) --!
	WindowContent.Position = UDim2.fromOffset(0,getSizeOffset(Topbar,'y'))
	AddStroke(WindowContent)
	
	
	-- DRAG SYSTEM --!
	
	local isDragging = false
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isDragging = true
			
			local originalMouse = UserInputService:GetMouseLocation()
			local originalWindowPos = Window.Position
			local renderstepped = nil
			renderstepped = RunService.RenderStepped:Connect(function()
				if not isDragging then renderstepped:Disconnect() end
				local mouse = UserInputService:GetMouseLocation()
				
				Window.Position = UDim2.fromOffset((mouse - originalMouse).X+originalWindowPos.X.Offset,
					(mouse - originalMouse).Y + originalWindowPos.Y.Offset
				)
			end)
		end
	end)
	
	local inputEndedConns = nil
	inputEndedConns = UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
			isDragging = false
		end
	end)
		
	--sub content
	
	local Topbar_Title = Instance.new('TextLabel')
	Topbar_Title.Parent = Topbar
	Topbar_Title.Name = "Title"
	Topbar_Title.Size = UDim2.new(0,150,1,0)
	Topbar_Title.Position = UDim2.fromOffset(2,0)
	Topbar_Title.BackgroundTransparency = 1
	Topbar_Title.TextScaled = true
	Topbar_Title.Text = title or "Title"
	Topbar_Title.TextXAlignment = Enum.TextXAlignment.Left
	Topbar_Title.TextColor3 = Color3.new(1,1,1)
	
	local Topbar_Close = Instance.new('TextButton')
	Topbar_Close.Parent = Topbar
	Topbar_Close.Name = "Close"
	Topbar_Close.BackgroundTransparency = 1
	Topbar_Close.AnchorPoint = Vector2.new(1,0)
	Topbar_Close.Position = UDim2.fromScale(1,0)
	Topbar_Close.Size = UDim2.new(0,75,1,0)
	Topbar_Close.Text = "Close"
	Topbar_Close.TextScaled = true
	Topbar_Close.TextColor3 = Color3.new(1,1,1)
	AddStroke(Topbar_Close)
	
	local Tabs = Instance.new('ScrollingFrame')
	Tabs.Parent = WindowContent
	Tabs.Name = "Tabs"
	Tabs.Size = UDim2.new(0,100,1,0)
	Tabs.BackgroundColor3 = Color3.new(1,1,1)
	Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Tabs.ScrollBarThickness = 3
	Tabs.ScrollingDirection = Enum.ScrollingDirection.Y
	Tabs.CanvasSize = UDim2.new()
	AddStroke(Tabs)
	
	local TabContent = Instance.new('Frame')
	TabContent.Parent = WindowContent
	TabContent.Name = "TabContent"
	TabContent.BackgroundColor3 = Color3.new(1,1,1)
	TabContent.Position = UDim2.fromOffset(getSizeOffset(Tabs,'x'),0) --!
	TabContent.Size = UDim2.new(0,getSizeOffset(Window,'x') - getSizeOffset(Tabs,'x'),1,0)
	AddStroke(TabContent)
	
	
	-- CLOSE FUNCTION
	local clicked = false
	Topbar_Close.Activated:Connect(function()
		if clicked then
			inputEndedConns:Disconnect()
			Screen:Destroy()
			return
		end
		
		Topbar_Close.Text = "Confirm?"
		clicked = true
		task.delay(5, function()
			clicked = false
			Topbar_Close.Text = "Close"
		end)
	end)
	
	-- sub-sub content :/
	
	local Tabs_UIListLayout = Instance.new('UIListLayout')
	Tabs_UIListLayout.Parent = Tabs
	Tabs_UIListLayout.FillDirection = Enum.FillDirection.Vertical
	Tabs_UIListLayout.SortOrder = Enum.SortOrder.Name
	
	local TabContent_Content = Instance.new('ScrollingFrame') --wtf why is the name confusing ?
	TabContent_Content.Parent = TabContent
	TabContent_Content.Name = "Content"
	TabContent_Content.Size = UDim2.fromScale(1,1)
	TabContent_Content.BackgroundColor3 = Color3.new(1,1,1)
	TabContent_Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabContent_Content.CanvasSize = UDim2.new()
	TabContent_Content.ScrollingDirection = Enum.ScrollingDirection.Y
	TabContent_Content.ScrollBarThickness = 4
	AddStroke(TabContent_Content)
	
	local DropdownList = Instance.new('Frame')
	DropdownList.Parent = TabContent
	DropdownList.Name = "DropdownList"
	DropdownList.AnchorPoint = Vector2.new(0,.5)
	DropdownList.BackgroundColor3 = Color3.new(1,1,1)
	DropdownList.Position = UDim2.fromScale(1,.5)
	DropdownList.Size = UDim2.fromOffset(100,200)
	AddStroke(TabContent_Content)
	
	-- sub-sub-sub content :X
	
	local DropdownList_Content = Instance.new('ScrollingFrame')
	DropdownList_Content.Parent = DropdownList
	DropdownList_Content.Name = "Content"
	DropdownList_Content.BackgroundTransparency = 1
	DropdownList_Content.Size = UDim2.fromScale(1,1)
	DropdownList_Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	DropdownList_Content.CanvasSize = UDim2.new()
	DropdownList_Content.ScrollingDirection = Enum.ScrollingDirection.Y
	DropdownList_Content.ScrollBarThickness = 4
	
	local TabContent_Content_UIListLayout = Instance.new('UIListLayout')
	TabContent_Content_UIListLayout.Parent = TabContent_Content
	TabContent_Content_UIListLayout.FillDirection = Enum.FillDirection.Vertical
	
	-- ULTRA SUB - CONTENT 0w0
	
	local DropdownList_Content_UIListLayout = Instance.new('UIListLayout')
	DropdownList_Content_UIListLayout.Parent = DropdownList_Content
	DropdownList_Content_UIListLayout.FillDirection = Enum.FillDirection.Vertical
	DropdownList_Content_UIListLayout.SortOrder = Enum.SortOrder.Name
	
	-- init window
	DropdownList.Active = false
	DropdownList.Visible = false
	
	local Window_Module = {}
	
	
	function Window_Module:MakeTab(title:string)
		local Contents = {}
		
		local Tab = Instance.new('Frame')
		Tab.Parent = Tabs
		Tab.BackgroundColor3 = Color3.new(1,1,1)
		Tab.Name = title or "Tab"
		Tab.Size = UDim2.new(1,0,0,40)
		AddStroke(Tab)
		
		local Label = Instance.new('TextLabel')
		Label.Parent = Tab
		Label.Name = "Label"
		Label.Size = UDim2.fromScale(1,1)
		Label.BackgroundTransparency = 1
		Label.TextScaled = true
		Label.TextWrapped = true
		Label.Text = title or "tab"
		
		local ClickBox = Instance.new('TextButton')
		ClickBox.Parent = Tab
		ClickBox.Name = "ClickBox"
		ClickBox.BackgroundTransparency = 1
		ClickBox.Text = ""
		ClickBox.Size = UDim2.fromScale(1,1)
		
		ClickBox.Activated:Connect(function() -- on clicked tab
			
			-- make current tab content dissappear
			for _, v in TabContent_Content:GetChildren() do
				if v:IsA('Frame') then
					v.Parent = nil
				end
			end

			-- make the tab own contents appear
			for _, v:Frame in Contents do
				v.Parent = TabContent_Content
			end
		end)
		
		local Tab_Module = {}
		
		function Tab_Module:MakeButton(title:string, callback)
			local Button = Instance.new('Frame')
			table.insert(Contents, Button)
			
			Button.BackgroundColor3 = Color3.new(1,1,1)
			Button.Size = UDim2.new(1,0,0,30)
			Button.Name = title or "Button"
			AddStroke(Button)
			
			local Label = Instance.new('TextLabel')
			Label.Parent = Button
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.fromScale(1,1)
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "Button"
			
			local ClickBox = Instance.new('TextButton')
			ClickBox.Parent = Button
			ClickBox.Name = "ClickBox"
			ClickBox.BackgroundTransparency = 1
			ClickBox.Text = ""
			ClickBox.Size = UDim2.fromScale(1,1)
			
			ClickBox.Activated:Connect(function()
				pcall(callback)
			end)
		end
		
		function Tab_Module:MakeToggle(title:string, callback)
			local Toggle = Instance.new('Frame')
			table.insert(Contents, Toggle)

			Toggle.BackgroundColor3 = Color3.new(1,0,0)
			Toggle.Size = UDim2.new(1,0,0,30)
			Toggle.Name = title or "Toggle"
			AddStroke(Toggle)
			
			local Label = Instance.new('TextLabel')
			Label.Parent = Toggle
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.fromScale(1,1)
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "Toggle"
			
			local ClickBox = Instance.new('TextButton')
			ClickBox.Parent = Toggle
			ClickBox.Name = "ClickBox"
			ClickBox.BackgroundTransparency = 1
			ClickBox.Text = ""
			ClickBox.Size = UDim2.fromScale(1,1)

			local value = false
			ClickBox.Activated:Connect(function()
				
				value = not value
				if value == true then
					Toggle.BackgroundColor3 = Color3.new(0,1,0)
				else
					Toggle.BackgroundColor3 = Color3.new(1,0,0)
				end
				
				pcall(function()
					callback(value)
				end)
				
			end)
		end
		
		function Tab_Module:MakeInput(title:string, callback)
			local TextInput = Instance.new('Frame')
			table.insert(Contents, TextInput)

			TextInput.BackgroundColor3 = Color3.new(1,1,1)
			TextInput.Size = UDim2.new(1,0,0,30)
			TextInput.Name = title or "TextInput"
			AddStroke(TextInput)
			
			local Label = Instance.new('TextLabel')
			Label.Parent = TextInput
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.fromScale(.5,1)
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "AnyInput"
			AddStroke(Label)
			
			local TextBox = Instance.new('TextBox')
			TextBox.Parent = TextInput
			TextBox.BackgroundTransparency = 1
			TextBox.Position = UDim2.fromScale(.5,0)
			TextBox.Size = UDim2.fromScale(.5,1)
			TextBox.PlaceholderText = ". . ."
			TextBox.TextScaled = true
			TextBox.TextWrapped = true
			TextBox.Text = "Input"
			TextBox.PlaceholderColor3 = Color3.fromRGB(89,89,89)
			TextBox.TextColor3 = Color3.fromRGB(40,40,40)
			TextBox.FocusLost:Connect(function(enterPressed)
				local Input = TextBox.Text
				pcall(function()
					callback(Input,enterPressed)
				end)
			end)
			
		end
		
		function Tab_Module:MakeDropdown(title:string)
			local Dropdown = Instance.new('Frame')
			table.insert(Contents, Dropdown)

			Dropdown.BackgroundColor3 = Color3.new(1,1,1)
			Dropdown.Size = UDim2.new(1,0,0,30)
			Dropdown.Name = title or "Dropdown"
			AddStroke(Dropdown)
			
			local Label = Instance.new('TextLabel')
			Label.Parent = Dropdown
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.fromScale(1,1)
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "Dropdown"
			
			local ClickBox = Instance.new('TextButton')
			ClickBox.Parent = Dropdown
			ClickBox.Name = "ClickBox"
			ClickBox.BackgroundTransparency = 1
			ClickBox.Text = ""
			ClickBox.Size = UDim2.fromScale(1,1)
			
			
			local Dropdown_Module = {}
				local Contents = {}
				function Dropdown_Module:AddOption(title:string,callback)
					local Option = Instance.new('TextButton')
					table.insert(Contents, Option)
					
					Option.Name = title or "Option"
					Option.Size = UDim2.new(1,0,0,30)
					Option.BackgroundColor3 = Color3.new(1,1,1)
					Option.TextScaled = true
					Option.TextWrapped = true
					Option.Text = title or "Option"
					AddStroke(Option)
					
					Option.Activated:Connect(function()
						pcall(function()
							callback()
						end)
					end)
				end
				
				
				ClickBox.Activated:Connect(function() -- on dropdown click
					-- make current dropdown content dissappear
					for _, v in DropdownList_Content:GetChildren() do
						if v:IsA('TextButton') then
							v.Parent = nil
						end
					end

					-- make the dropdown own contents appear
					for _, v:Frame in Contents do
						v.Parent = DropdownList_Content
					end
					
					DropdownList.Visible = not DropdownList.Visible
					DropdownList.Visible = DropdownList.Visible
				end)
				
			return Dropdown_Module
		end
		
		return Tab_Module
	end
	
	return Window_Module
	
end

return rjellyui
