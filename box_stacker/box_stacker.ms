(
		
	global boxTreeStackerMain
	try (destroyDialog boxTreeStackerMain) 
	catch()
	
	clearListener()
	
	--arrays
	createdBoxes = #()
	
	--variables
	boxZPos = 0
	scaleValue = 0
	myChoice = ()
	randomColor =  random [0,0,0] [255,255,255]
	parentToggle = ()
		
	--createBox function
	fn createBoxes boxCount boxHeight boxLength boxWidth boxGrowth boxRotate wireColorChoice =
	(
		
		--empty array at start of process
		createdBoxes = #()
		
		--for loop to make specified number of boxes
		for c = 1 to boxCount do
		(
			--specify random colour
			randomColor =  random [0,0,0] [255,255,255]
			
			--make box
			b = box pos: [0,0, boxZPos] height: boxHeight length: boxLength width: boxWidth name: ("Stack Box " + (c as string)) wirecolor: wireColorChoice
			
			--rotation of new boxes
			rotAngle = eulerangles 0 0 ((c-1)*boxRotate)
			rotate b rotAngle
				
			--adjust z position for next box 
			boxZPos = (boxZPos + boxHeight)
			
			--adjust box scale for next box	
			scaleValue = (((boxGrowth)+100)*0.01)
			boxHeight = (boxHeight * ((scaleValue)))
			boxLength = (boxLength * ((scaleValue)))
			boxWidth = (boxWidth * ((scaleValue)))
			
			--add boxes to array for easy deletion
			append createdBoxes b
				
			--parent boxes
			if parentToggle == 1 do
			(
				if c > 1 do
				(
					createdBoxes[c].parent = createdBoxes[(c-1)]
				)
			)
				
		)
		
		--reset height
		boxZPos = 0
	
	)
	
	--create master rollout and define subrollouts within it
	rollout boxTreeStackerMain "Box Tree Stacker"
	(
		subrollout boxUserOptions "Options"
		subrollout boxUserInfo "Info"
	)
	
	--primary rollout
	rollout boxTreeOptions "Box Tree Stacker" 
	(
		
		--controls
		
		group "Choose Box Stats"
		(
			
			spinner boxCount "Num. of Boxes" type: #integer range: [1,100,5] 		
			checkbox boxParent "Parent Boxes" tooltip: "Do you want the boxes to be parented to each other?" checked: False align: #right
			spinner boxHeight "Starting Height" tooltip: "Choose the height of the first box." type: #integer range: [1, 100, 10]
			spinner boxWidth "Starting Width" tooltip: "Choose the width of the boxes." type: #integer range: [1, 100, 10]
			spinner boxLength "Starting Length" tooltip: "Choose the length of the boxes." type: #integer range: [1, 100, 10]
			spinner boxGrowth "Size % Increase/Decrease" type: #integer tooltip: "Enter a percentage by which you wish the box height to scale." range: [-100, 100, 10]
			spinner boxRotate "Rotation" tooltip: "Choose how much z-axis roation you want." type: #integer range: [-360, 360, 0]
			colorpicker wirecolorPicker "Wireframe Colour:" color: [0,0,0] across: 2
			checkbox randomColorCheck "Random Wirecolors" tooltip: "Random wirecolors" checked: False
		)
		group "Create Box Tree Stack"
		(
			button boxCreate "Create" width: 100
		)
		
		--event handlers
		
		on boxCreate pressed do 
			(
				--delete existing boxes if they have not already been deleted (eg. are valid nodes)
				
				if createdBoxes.count != 0 do
				(
					for i = 1 to createdBoxes.count where (isValidNode createdBoxes[i] == true) do 
					(
						delete createdBoxes
					)
				)
			
				--if random colours is ticked, use random colours
				if randomColorCheck.checked == true then
				(
					myChoice = randomColor
				)
				else
				(
					myChoice = wirecolorPicker.color
				)
				
				--if parent box is ticked:
				if boxParent.checked == true then
				(
					parentToggle = 1
				)
				else
				(
					parentToggle = 0
				)
				
				--call create boxes function
				createBoxes boxCount.value boxHeight.value boxLength.value boxWidth.value boxGrowth.value boxRotate.value myChoice				
			)
	)
	
	--secondary rollout containing user info
	rollout boxTreeHelp "User Help" rolledup: True 
	(
		edittext helpText text:"Choose the settings you want and hit create.  \nPressing create again will remove existing boxes.  \nYou may toggle on and off random wirecolours \nor choose one yourself.  \nParent toggle controls if boxes are parented \n the previous box." height: 75 readonly: True
	)
	
	
	--create the dialogs
	
	createDialog boxTreeStackerMain height: 440 width: 350
	
	--add subrollouts
	AddSubRollout boxTreeStackerMain.boxUserOptions boxTreeOptions
	AddSubRollout boxTreeStackerMain.boxUserInfo boxTreeHelp
	
	--position first rollout
	boxTreeStackerMain.boxUserOptions.height += 275
	
	--position second rollout
	boxTreeStackerMain.boxUserInfo.pos += [0, 275] 
	boxTreeStackerMain.boxUserInfo.height += 110         

	)