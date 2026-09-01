-- v3.1
-- solo developed (@nichunjelly) >w<
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
local TweenService = game:GetService("TweenService")

local Screen = Instance.new('ScreenGui')
Screen.Name = "RJelly"..os.clock()
Screen.Parent = game:GetService('CoreGui')or game.Players.LocalPlayer.PlayerGui
Screen.IgnoreGuiInset = true

function rjellyui:MakeWindow(title:string)

	local Window = Instance.new('Frame')
	Window.Parent = Screen
	Window.BackgroundColor3 = Color3.new(1,1,1)
	Window.Name = title or "Window"
	Window.Position = UDim2.fromOffset(75,75)
	Window.Size = UDim2.fromOffset(300,300)
	Window.BackgroundTransparency = 1
	local Topbar = Instance.new('Frame')
	Topbar.Parent = Window
	Topbar.Name = "Topbar"
	Topbar.BackgroundColor3 = Color3.fromRGB(153, 11, 200)
	Topbar.Size = UDim2.new(1,0,0,25)

	local WindowContent = Instance.new('Frame')
	WindowContent.Parent = Window
	WindowContent.Name = "Content"
	WindowContent.BackgroundColor3 = Color3.new(1,1,1)
	WindowContent.Size = UDim2.new(1,0,0,getSizeOffset(Window,'y') - getSizeOffset(Topbar,'y')) --!
	WindowContent.Position = UDim2.fromOffset(0,getSizeOffset(Topbar,'y'))
	WindowContent.BackgroundTransparency = 1
	WindowContent.BorderSizePixel = 0
	
	local Window_UICorner = Instance.new("UICorner")
	Window_UICorner.Parent = Window
	Window_UICorner.CornerRadius = UDim.new(0,8)

	-- DRAG SYSTEM --!

	local isDragging = false
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then -- touch tap counts same as mouse click now
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
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then -- lift finger = same as releasing mouse
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
	local TabsLayoutOrder = 1

	local TabContent = Instance.new('Frame')
	TabContent.Parent = WindowContent
	TabContent.Name = "TabContent"
	TabContent.BackgroundColor3 = Color3.new(1,1,1)
	TabContent.Position = UDim2.fromOffset(getSizeOffset(Tabs,'x'),0) --!
	TabContent.Size = UDim2.new(0,getSizeOffset(Window,'x') - getSizeOffset(Tabs,'x'),1,0)
	TabContent.BackgroundTransparency = 1
	TabContent.BorderSizePixel = 0


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
	Tabs_UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local TabContent_Content = Instance.new('ScrollingFrame') --wtf why is the name confusing ?
	TabContent_Content.Parent = TabContent
	TabContent_Content.Name = "Content"
	TabContent_Content.Size = UDim2.fromScale(1,1)
	TabContent_Content.BackgroundColor3 = Color3.new(1,1,1)
	TabContent_Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	TabContent_Content.CanvasSize = UDim2.new()
	TabContent_Content.ScrollingDirection = Enum.ScrollingDirection.Y
	TabContent_Content.ScrollBarThickness = 4
	TabContent_Content.BackgroundTransparency = 1
	TabContent_Content.BorderSizePixel = 0

	local DropdownList = Instance.new('Frame')
	DropdownList.Parent = TabContent
	DropdownList.Name = "DropdownList"
	DropdownList.AnchorPoint = Vector2.new(0,.5)
	DropdownList.BackgroundColor3 = Color3.new(1,1,1)
	DropdownList.Position = UDim2.fromScale(1,.5)
	DropdownList.Size = UDim2.fromOffset(100,200)
	AddStroke(DropdownList) -- was AddStroke(TabContent_Content) before, DropdownList never got its stroke, tiny fix


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
	TabContent_Content_UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- ULTRA SUB - CONTENT 0w0

	local DropdownList_Content_UIListLayout = Instance.new('UIListLayout')
	DropdownList_Content_UIListLayout.Parent = DropdownList_Content
	DropdownList_Content_UIListLayout.FillDirection = Enum.FillDirection.Vertical
	DropdownList_Content_UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- init window
	DropdownList.Active = false
	DropdownList.Visible = false


	local Window_Module = {}


	function Window_Module:MakeTab(title:string)
		local Contents = {}
		local TabContentLayoutOrder = 1

		local Tab = Instance.new('Frame')
		Tab.Parent = Tabs
		Tab.BackgroundColor3 = Color3.new(1,1,1)
		Tab.Name = title or "Tab"
		Tab.Size = UDim2.new(1,0,0,40)
		Tab.LayoutOrder = TabsLayoutOrder
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

		ClickBox.Activated:Connect(function() -- on clicked tab, Activated already fires for touch tap too so no change needed here

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

		local function AddContentLayoutOrder(obj:Frame)
			obj.LayoutOrder = TabContentLayoutOrder
			TabContentLayoutOrder += 1
		end

		local Tab_Module = {}

		function Tab_Module:MakeButton(title:string, callback)
			local Button = Instance.new('CanvasGroup')
			table.insert(Contents, Button)

			Button.BackgroundColor3 = Color3.new(1,1,1)
			Button.Size = UDim2.new(1,0,0,30)
			Button.Name = title or "Button"
			Button.BackgroundTransparency = 1
			Button.BorderSizePixel = 0
			AddContentLayoutOrder(Button)

			local Label = Instance.new('TextLabel')
			Label.Parent = Button
			Label.BackgroundTransparency = 1
			Label.AnchorPoint = Vector2.new(0,.5)
			Label.Position = UDim2.new(0,5,.5,0)
			Label.Size = UDim2.fromScale(.8,.6)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "Button"

			local ImageLabel = Instance.new('ImageLabel')
			ImageLabel.Parent = Button
			ImageLabel.AnchorPoint = Vector2.new(1,.5)
			ImageLabel.Name = "Icon"
			ImageLabel.Size = UDim2.fromScale(1,1)
			ImageLabel.Position = UDim2.fromScale(1,.5)
			ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
			ImageLabel.Image = "rbxassetid://9735358798"
			ImageLabel.BorderSizePixel = 0
			ImageLabel.BackgroundTransparency = 1

			local ClickBox = Instance.new('TextButton')
			ClickBox.Parent = Button
			ClickBox.Name = "ClickBox"
			ClickBox.Text = ""
			ClickBox.AnchorPoint = Vector2.new(.5,.5)
			ClickBox.Position = UDim2.fromScale(.5,.5)
			ClickBox.Size = UDim2.fromScale(.975,.85)
			ClickBox.BorderSizePixel = 0
			ClickBox.ZIndex = 0
			ClickBox.TextTransparency = .1
			ClickBox.BackgroundColor3 = Color3.new(1,1,1)
			ClickBox.AutoButtonColor = false
			
			local ClickBox_UICorner = Instance.new('UICorner')
			ClickBox_UICorner.Parent = ClickBox
			ClickBox_UICorner.CornerRadius = UDim.new(0,3)
			

			local function run()
				local success, result = pcall(callback)
				return result
			end
			ClickBox.Activated:Connect(run)

			local button_module = {}

			function button_module:SetTitle(title:string)
				Label.Text = title or "Button"
			end

			function button_module:Activate()
				run()
			end

			function button_module:ChangeCallback(New_callback)
				callback = New_callback
			end

			return button_module
		end

		function Tab_Module:MakeToggle(title:string, callback, default:boolean)
			local runningTween = nil
			local Toggle = Instance.new('CanvasGroup')
			table.insert(Contents, Toggle)

			Toggle.Size = UDim2.new(1,0,0,30)
			Toggle.BorderSizePixel = 0
			Toggle.BackgroundTransparency = 1
			Toggle.Name = title or "Toggle"
			AddContentLayoutOrder(Toggle)

			local Label = Instance.new('TextLabel')
			Label.Parent = Toggle
			Label.BackgroundTransparency = 1
			Label.AnchorPoint = Vector2.new(0,.5)
			Label.Position = UDim2.new(0,5,.5,0)
			Label.Size = UDim2.fromScale(.75,.6)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "Toggle"

			local ClickBox = Instance.new('TextButton')
			ClickBox.Parent = Toggle
			ClickBox.Name = "ClickBox"
			ClickBox.Text = ""
			ClickBox.AnchorPoint = Vector2.new(.5,.5)
			ClickBox.Position = UDim2.fromScale(.5,.5)
			ClickBox.Size = UDim2.fromScale(.975,.85)
			ClickBox.BorderSizePixel = 0
			ClickBox.ZIndex = 0
			ClickBox.TextTransparency = .1
			ClickBox.BackgroundColor3 = Color3.new(1,1,1)
			ClickBox.AutoButtonColor = false
			
			local ClickBox_UICorner = Instance.new('UICorner')
			ClickBox_UICorner.Parent = ClickBox
			ClickBox_UICorner.CornerRadius = UDim.new(0,3)
			
			local Background = Instance.new("CanvasGroup")
			Background.Parent = Toggle
			Background.AnchorPoint = Vector2.new(1,.5)
			Background.BackgroundColor3 = Color3.fromRGB(200,200,200)
			Background.Interactable = false
			Background.Position = UDim2.fromScale(.95,.5)
			Background.Size = UDim2.fromScale(.175,.5)
			Background.BorderSizePixel = 0
			
			local Background_UICorner = Instance.new('UICorner')
			Background_UICorner.Parent = Background
			Background_UICorner.CornerRadius = UDim.new(0,3)
			
			local Slider = Instance.new("Frame")
			Slider.Parent = Background
			Slider.BackgroundColor3 = if default then Color3.fromRGB(50,100,200) else Color3.fromRGB(200,0,0)
			Slider.BorderSizePixel = 0
			Slider.Size = UDim2.fromScale(.5,1)
			
			local Slider_UICorner = Instance.new('UICorner')
			Slider_UICorner.Parent = Slider
			Slider_UICorner.CornerRadius = UDim.new(0,3)
			
			local value = default
			local function run()
				value = not value
				if runningTween then runningTween:Disconnect() end
				
				if value then
					Slider.BackgroundColor3 = Color3.fromRGB(200,0,0)
					Slider.Position = UDim2.new()
					runningTween = TweenService:Create(
						Slider,
						TweenInfo.new(.5,Enum.EasingStyle.Circular,Enum.EasingDirection.Out),
						{Position = UDim2.fromScale(.5,0), BackgroundColor3 = Color3.fromRGB(50,100,200)}
					):Play()
				elseif not value then
					Slider.BackgroundColor3 = Color3.fromRGB(50,100,200)
					Slider.Position = UDim2.fromScale(.5,0)
					runningTween = TweenService:Create(
						Slider,
						TweenInfo.new(.5,Enum.EasingStyle.Circular,Enum.EasingDirection.Out),
						{Position = UDim2.new(), BackgroundColor3 = Color3.fromRGB(200,0,0)}
					):Play()
				end

				pcall(function()
					callback(value)
				end)

			end
			
			ClickBox.Activated:Connect(run)

			local toggle_module = {}

			function toggle_module:GetValue()
				return value
			end

			function toggle_module:SetTitle(title:string)
				Label.Text = title or 'Toggle'
			end

			function toggle_module:ChangeCallback(New_callback)
				callback = New_callback
			end

			function toggle_module:Activate()
				run()
			end

			function toggle_module:SetNextActivationValue(val:boolean)
				value = not val
			end

			function toggle_module:SetValue(val:boolean)
				value = val
			end

			return toggle_module
		end

		function Tab_Module:MakeInput(title:string, callback)
			local TextInput = Instance.new('Frame')
			table.insert(Contents, TextInput)

			TextInput.BackgroundColor3 = Color3.new(1,1,1)
			TextInput.Size = UDim2.new(1,0,0,30)
			TextInput.Name = title or "TextInput"
			TextInput.BorderSizePixel = 0
			AddContentLayoutOrder(TextInput)

			local Label = Instance.new('TextLabel')
			Label.Parent = TextInput
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.fromScale(.5,1)
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "AnyInput"

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

			local function run(Input,enterPressed)
				local success, result = pcall(function()
					callback(Input,enterPressed)
				end)
				return result
			end
			TextBox.FocusLost:Connect(run)

			local input_module = {}

			function input_module:Activate(Input,enterPressed)
				run(Input or "", enterPressed or false)
			end

			function input_module:SetInput(text:string)
				TextBox.Text = text or "Input"
			end

			function input_module:SetTitle(title:string)
				Label.Text = title or 'TextBox'
			end

			function input_module:ChangeCallback(New_callback)
				callback = New_callback
			end

			return input_module
		end

		function Tab_Module:MakeDropdown(title:string)
			local DropdownLayoutOrder = 1
			local Dropdown = Instance.new('Frame')
			table.insert(Contents, Dropdown)

			Dropdown.BackgroundColor3 = Color3.new(1,1,1)
			Dropdown.Size = UDim2.new(1,0,0,30)
			Dropdown.Name = title or "Dropdown"
			Dropdown.BorderSizePixel = 0
			AddContentLayoutOrder(Dropdown)

			local Label = Instance.new('TextLabel')
			Label.Parent = Dropdown
			Label.BackgroundTransparency = 1
			Label.AnchorPoint = Vector2.new(0,.5)
			Label.Position = UDim2.new(0,5,.5,0)
			Label.Size = UDim2.fromScale(.6,.6)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextWrapped = true
			Label.TextScaled = true
			Label.Text = title or "Dropdown"

			local Preview = Instance.new('Frame')
			Preview.Parent = Dropdown
			Preview.AnchorPoint = Vector2.new(1,.5)
			Preview.Position = UDim2.fromScale(.95,.5)
			Preview.Size = UDim2.new(0,50,.7,0)
			Preview.BorderSizePixel = 0
			Preview.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

			local PreviewLabel = Instance.new('TextLabel')
			PreviewLabel.Parent = Preview
			PreviewLabel.Size = UDim2.fromScale(1,1)
			PreviewLabel.BackgroundTransparency = 1
			PreviewLabel.TextScaled = true
			PreviewLabel.Text = ". . ."


			local ClickBox = Instance.new('TextButton')
			ClickBox.Parent = Dropdown
			ClickBox.Name = "ClickBox"
			ClickBox.BackgroundTransparency = 1
			ClickBox.Text = ""
			ClickBox.Size = UDim2.fromScale(1,1)


			local Dropdown_Module = {}
			local DropdownContents = {}
			function Dropdown_Module:AddOption(title:string,callback)
				local Option = Instance.new('TextButton')
				table.insert(DropdownContents, Option)

				Option.Name = title or "Option"
				Option.Size = UDim2.new(1,0,0,30)
				Option.BackgroundColor3 = Color3.new(1,1,1)
				Option.TextScaled = true
				Option.TextWrapped = true
				Option.Text = title or "Option"
				Option.LayoutOrder = DropdownLayoutOrder
				AddStroke(Option)


				local function run()
					local success, result = pcall(function()
						callback()
					end)
					return result
				end
				Option.Activated:Connect(run)

				local option_module = {}

				function option_module:Remove()
					local index = table.find(DropdownContents,Option)

					if index then
						table.remove(DropdownContents, index)
					end
					Option:Destroy()
				end

				function option_module:Activate()
					run()
				end

				function option_module:ChangeTitle(title:string)
					Option.Text = title or "Option"
				end

				function option_module:ChangeCallback(New_callback)
					callback = New_callback
				end
				DropdownLayoutOrder += 1
				return option_module
			end

			ClickBox.Activated:Connect(function() -- on dropdown click
				-- make current dropdown content dissappear
				for _, v in DropdownList_Content:GetChildren() do
					if v:IsA('TextButton') then
						v.Parent = nil
					end
				end

				-- make the dropdown own contents appear
				for _, v:Frame in DropdownContents do
					v.Parent = DropdownList_Content
				end

				DropdownList.Visible = not DropdownList.Visible
				DropdownList.Visible = DropdownList.Visible
			end)

			return Dropdown_Module
		end

		function Tab_Module:MakeLabel(title:string)
			local Frame = Instance.new('Frame')
			table.insert(Contents, Frame)

			Frame.BackgroundColor3 = Color3.new(1,1,1)
			Frame.Size = UDim2.new(1,0,0,30)
			Frame.Name = title or "Frame"
			Frame.BorderSizePixel = 0
			AddContentLayoutOrder(Frame)

			local Label = Instance.new('TextLabel')
			Label.Parent = Frame
			Label.BackgroundTransparency = 1
			Label.AnchorPoint = Vector2.new(0,.5)
			Label.Size = UDim2.fromScale(1,.6)
			Label.Position = UDim2.fromScale(0,.5)
			Label.Text = title or "Label"
			Label.TextScaled = true

			local label_module = {}

			function label_module:ChangeLabel(title:string)
				Label.Text = title or "Label"
			end

			return label_module
		end

		function Tab_Module:MakeSpace(px:number)
			local Frame = Instance.new('Frame')
			table.insert(Contents, Frame)

			Frame.BackgroundColor3 = Color3.new(1,1,1)
			Frame.BorderSizePixel = 0
			Frame.Name = "Space"
			Frame.Size = UDim2.new(1,0,0,px or 30)
			Frame.Name = title or "Frame"
			AddContentLayoutOrder(Frame)

			local space_module = {}

			function space_module:ChangeSize(px:number)
				Frame.Size = UDim2.new(1,px or 30)
			end

			return space_module
		end
		TabsLayoutOrder += 1
		return Tab_Module
	end

	return Window_Module

end

return rjellyui
