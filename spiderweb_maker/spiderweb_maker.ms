(
	global spiderWebMakerMain
	try(destroyDialog spiderWebMakerMain)
	catch()
		
	
	--cleanup
	clearListener()

	--initial variables
	webArray = #()
	pointsArray = #()
	advSpokeArray = #()
	lenArray = #()
	revArray = #()
	currentCentralPoint = [0,0,0]
	
	--bitmaps
	script_path = getThisScriptFilename()
	basic_path = substituteString script_path "\spiderweb_maker.ms" "\bitmaps\basic_web_v01.jpg"
	advanced_path = substituteString script_path "\spiderweb_maker.ms" "\bitmaps\advanced_web_v01.jpg"

	local basicPic = openBitMap(basic_path)
	local advancedPic = openBitMap(advanced_path)
	
	--starting values
	rotAngle = 0
	centrePoint = currentCentralPoint


	--basic spoke function	
	fn makeBasicSpoke webSize numSpokes numSegs distortValue extendWeb =
	(
		--initial calculations
		webSize = (webSize as float)
		numSegs = (numSegs as float)

		rotStep = ((360.0/numSpokes) as float)
		segSpace = ((webSize/(numSegs)) as float)
				
		--make initial spoke
		sS = SplineShape pos: [0,0,0]
		addNewSpline sS
		
		--for loop to add divisions to the spokes for each segment
		for i = 0.0 to (webSize+0.1) by segSpace do
		(
			addknot sS 1 #corner #line [0, i, 0]
		)
		
		addknot ss 1 #corner #line [0, (webSize + extendWeb), 0]
		updateShape ss
		
		--rotate spoke for the next iteration
		rotate sS (angleaxis rotAngle [0,0,1])
		
		--add spoke to array
		append webArray sS
		
		--update rot angle for next phase
		rotAngle = rotAngle + rotStep
	)
	  
	--basic segment function
	fn makeBasicSegs webSize numSpokes numSegs distortValue = 
	(
		--for loop to make segments between the spokes
		for seg = 1 to numSegs do
		(
			--calculation to invert the inputted distory value, so high values result in more distortion and vice versa
			if distortValue == 0 then
			(
				newDistortValue = 0
			)
			else
			(
				newDistortValue = (21 - distortValue)
			)
			
			--set location of first point
			initSegLoc = (getKnotPoint webArray[1] 1 (seg+1))

			--make line
			segLine = SplineShape pos: initSegLoc
			addNewSpline segLine
			addknot segLine 1 #bezier #curve initSegLoc (initSegLoc - (initSegLoc/newDistortValue)) (initSegLoc - (initSegLoc/newDistortValue))
			
			--for loop to make the other segments
			for spoke = 1 to numSpokes do
			(
				segLoc = (getKnotPoint webArray[spoke] 1 (seg+1)) 
				addKnot segLine 1 #bezier #curve segLoc (segLoc - (segLoc/newDistortValue)) (segLoc - (segLoc/newDistortValue))
			)
			
			--close the web at the end
			close segLine 1
			updateShape segLine
			--add to array for easy deleting/updating
			append webArray segLine
		)
	)
	
	--advanced spoke function
	fn makeAdvancedSpoke webDir = 
	(
		--centrepoint loc
		centrePoint = currentCentralPoint
	
		--for loop to make a spoke from the centre to each point
		for i = 1 to pointsArray.count do
		(
			
			spokeLength = (distance centrePoint pointsArray[i].pos)
			append lenArray spokeLength
			
			advS = SplineShape pos: centrePoint
			addNewSpline advS
			addknot advS 1 #corner #line centrePoint
			addknot advS 1 #corner #line pointsArray[i].pos
			updateShape advS
			
			append advSpokeArray advS
		)
		
		--if statement to reorganise array if coutnerclockwise is selected
		if webDir == 2 then
		(
			--empty reversed array
			revArray = #()
			
			--for loop to append (by -1, that's the important bit) to reversed array
			for i = advSpokeArray.count to 1 by -1 do
			(
				append revArray advSpokeArray[i]
			)
			
			--empty original array
			advSpokeArray = #()
			
			--add reversed array to original array
			join advSpokeArray revArray
		)
		
	)
	
	--function to add knots to the spokes if web is logarthithmic
	fn makeLogKnots logScaleChoice maxNumSegs = 
	(
		logScaleValue = (logScaleChoice*0.1)
		
		--initial variables for making fibonacci sequence
		firstNum = 1
		secondNum = 1
		
		maxLength = (amax lenArray)
		minLength = (amin lenArray)
		
		for turn = 1 to maxNumSegs do
		(
			for k = 1 to advSpokeArray.count do
			(
				--define the length of the currently selected sploke and the division ratio for calculating knot pos.
				curLength = (lenArray[k])
				divisionRatio = (maxLength/curLength)
				
				--calculate where the next knot should go
				knotPos = (interpCurve3D advSpokeArray[k] 1 (divisionRatio*(firstNum*0.01)) truepathParam:False )
					
				--add knots until the knot point is further away from the central point than the end of the line
				if ((distance centrePoint knotPos) < curLength) then
				(
					addKnot advSpokeArray[k] 1 #corner #line knotPos (turn + 1)
				)

				--update shape to stop crashes
				updateShape advSpokeArray[k]
				
				--homemade fibonacci, bitches
				firstNum = (firstNum + secondNum)
				secondNum = ((firstNum - secondNum)*logScaleValue)
				
			)
		)
	)
	
	--function to add knots to the spokes if web is arithmetic
	fn makeArithKnots logScaleChoice maxNumSegs = 
	(
		logScaleValue = logScaleChoice
		
		maxLength = (amax lenArray)
		minLength = (amin lenArray)
		
		for turn = 1 to maxNumSegs do
		(
			for k = 1 to advSpokeArray.count do
			(
				--define the length of the currently selected sploke and the division ratio for calculating knot pos.
				curLength = (lenArray[k])
				divisionRatio = (maxLength/curLength)
				
				--calculate where the next knot should go
				knotPos = (interpCurve3D advSpokeArray[k] 1 (divisionRatio*(logScaleValue*0.01)) truepathParam:False )
					
				--add knots until the knot point is further away from the central point than the end of the line
				if ((distance centrePoint knotPos) < curLength) then
				(
					addKnot advSpokeArray[k] 1 #corner #line knotPos (turn + 1)
				)

				--update shape to stop crashes
				updateShape advSpokeArray[k]
				
				logScaleValue = (logScaleChoice + logScaleValue)
				
			)
		)
	)
	
	--generic function to add a line that connects the knots on the spokes
	fn makeGenSegments = 
	(
		
		--make line
		segLogLine = SplineShape pos: centrePoint
		addNewSpline segLogLine
		
		--add first point
		addknot segLogLine 1 #corner #line centrePoint
		
		--work out numbers of points
		local knotMax = #()
		for a = 1 to advSpokeArray.count do
		(
			append knotMax (numKnots advSpokeArray[a])
		)
		
		--for loop to keep maing points until you reach the last knot on a spoke.
		for k = 1 to (amax knotMax) do
		(
			for s = 1 to advSpokeArray.count while ((numKnots advSpokeArray[s]) > (k+1)) do
				(
					--print ("turn: " + (k as string) + "spoke: " + (s as string))
					addKnot segLogLine 1 #corner #line (getKnotPoint advSpokeArray[s] 1 (k+1))
					continue
				)
		)
		
		--update the web at the end to avoid crashing
		updateShape segLogLine
		
		--add to array for easy deleting/updating
		append advSpokeArray segLogLine
		
	)
	

	
	
	--main rollout
	rollout spiderWebMakerMain "Spider Web Maker"
	(
		subrollout webRolloutBasic "Basic"
		subrollout webRolloutAdvanced "Advanced"
		subrollout webRolloutHelp "Help"
	)
	
	--subrollout 1 - basic web maker
	rollout spiderWebBasic "Basic Web Shape"
	(
		group "Basic Web Options" 
		(
			bitmap imgLogo "logo" tooltip:"Basic Web Style" bitmap: basicPic align:#left height:100 width: 100 across: 2
			spinner basicWebSize "Size:" tooltip: "Initial web size" type: #integer align:#right width: 100 range: [1,1000,100] 
			spinner basicWebSpokes "Spokes:" tooltip: "Choose how many spokes you want." type: #integer align:#right width: 100 range: [3,60,12] pos: [247, 47]
			spinner basicWebSegments "Segments:" tooltip: "Choose how many segments do you want the web to contain." type: #integer align:#right width: 100 range: [1,60,5]
			spinner basicWebDistortion "Distortion:" tooltip: "Choose how much you wish the web segments to distort." type: #integer align:#right width: 100 range: [0,20, 10]
			spinner basicWebExtension "Web Extension:" tooltip: "Choose how much furhter you wish the spokes to extend beyond the web." type: #integer align: #right width: 100 range: [0,500,0]
			checkbox basicMeshCreate "Mesh" tooltip: "Select if you want the splines to have a mesh." checked: True align: #right
			button createBasic "Create" across: 2
			button deleteBasic "Delete" 
			
			on createBasic pressed do
			(
				clearListener()
				
				--reset rot angle for subsequent create button presses
				rotAngle = 0
				
				--delete existing webs (with isvalidnode to stop max trying to delete already deleted objects)
				if webArray.count != 0 do
				(
					for i = 1 to webArray.count where (isValidNode webArray[i] == true) do 
					(
						delete webArray[i]
					)
				)
				
				--reset webArray
				webArray = #()
		
				--initial spoke creation
				while (rotAngle < 360) and (webArray.count < basicWebSpokes.value) do
				(
					makeBasicSpoke basicWebSize.value basicWebSpokes.value basicWebSegments.value basicWebDistortion.value basicWebExtension.value
				)
				
				--segment creation
				makeBasicSegs basicWebSize.value basicWebSpokes.value basicWebSegments.value basicWebDistortion.value
				
				--toggle for mesh on/off	
				if basicMeshCreate.checked == True then
				(
					for w = 1 to webArray.count do
					(
						webArray[w].render_renderable = True
						webArray[w].render_displayRenderMesh  = True
					)
				)
				else
				(
					for w = 1 to webArray.count do
					(
						webArray[w].render_renderable = False
						webArray[w].render_displayRenderMesh  = False
					)
				)

			)
			
			on deleteBasic pressed do
			(
				if webArray.count != 0 do
				(
					for i = 1 to webArray.count where (isValidNode webArray[i] == true) do 
					(
						delete webArray[i]
					)
				)
			)
			
		)

	)
	
	--subrollout 2 - advanced web maker
	rollout spiderWebAdvanced "Advanced Web Shape"
	(
		fn pointFilt obj = classof obj == Point
			
		group "Advanced Web Settings"
		(
			
			bitmap imgLogo "logo" tooltip:"Advanced Web Style" bitmap: advancedPic align:#left height:100 width: 100 across: 2
			radiobuttons webType "Web type:" labels: #("Logarithmic", "Arithmetic")  pos: [170,25]
			radiobuttons webDirChoice "Direction:" labels: #("Clockwise", "Counter Clockwise") pos: [170,60]
			spinner advGrowth "Growth: " pos: [258,110] width: 90 align: #right tooltip: "Choose a factor for the web to grow by." range: [1,10,2] type: #integer
			spinner maxWebSegs "Max Segments" width: 100 align: #right tooltip: "Choose the maximum number of segments." range: [1,30,10] type: #integer
			checkbox advMeshCreate "Mesh" tooltip: "Select if you want the splines to have a mesh." checked: True align: #right
			label cntrlPointLabel "Web central point:" align: #left pos: [15, 170] across: 2
			pickButton cntrPoint_pick "Choose" message: "Choose a point market to act as the central point of the web:" filter: pointFilt pos: [130, 165]
			
			listbox otherPointsBox "Points that make up the web:" items: (for p in pointsArray collect p.name) selection: 0 height: 7 across: 2 width: 250 pos:[15,200] readonly: true 
			
			button updateSelection "Add/Update" tooltip: "Add selected points to web." pos: [273, 225]
			button createAdvanced "Create" across: 2 pos: [130,330]
			button deleteAdvanced "Delete" pos: [190,330]
			
			--choose central point of web
			on cntrPoint_pick picked obj do
			(
				if (classOf obj == point) do
				(
					--record point position
					currentCentralPoint = obj.pos
					--places point name in the box
					cntrPoint_pick.text = obj.name
				)
			)
			
			--update points that make up the web based on selection
			on updateSelection pressed do
			(
				if selection.count > 0 then
				(
					--if there are pre-existing points, this should remove them
					if pointsArray.count != 0 do
						(
							pointsArray = #()
						)
					
					--add points in selection to points array
					for w = 1 to selection.count where classOf selection[w] == point do
					(
						if selection[w].name != cntrPoint_pick.text do
						(
							append pointsArray selection[w]
						)
					)
					
					--function to compare string names, called later by qsort
					fn compareNames str1 str2 = stricmp str1.name str2.name
					
					--sort array by name - user will have to place points in the order they want to use them - will make clear in help
					qSort pointsArray compareNames
	
					--updates list in rollout with selected points
					otherPointsBox.items = (for p in pointsArray collect p.name)
					
				)
				--if no points selected, messagebox appears
				else
				(
					messagebox "Please select the points you wish to use and hit add." beep: False
				)
			)
			
			--create advanced web
			on createAdvanced pressed do
			(
				--delete existing webs (with isvalidnode to stop max trying to delete already deleted objects)
				if advSpokeArray.count != 0 do
				(
					for i = 1 to advSpokeArray.count where (isValidNode advSpokeArray[i] == true) do 
					(
						delete advSpokeArray[i]
					)
				)
				
				--reset webArray
				advSpokeArray = #()
				
				--function to make spokes
				makeAdvancedSpoke webDirChoice.state
				
				--type of web to be made determined by radio button in UI
				if webType.state == 1 then
				(
					--functions to make logarithmic web
					makeLogKnots advGrowth.value maxWebSegs.value 
					makeGenSegments ()
				)
				else
				(
					makeArithKnots advGrowth.value maxWebSegs.value
					makeGenSegments ()
				)
				
				--toggle for mesh on/off	
				if advMeshCreate.checked == True then
				(
					for w = 1 to advSpokeArray.count do
					(
						advSpokeArray[w].render_renderable = True
						advSpokeArray[w].render_displayRenderMesh  = True
					)
				)
				else
				(
					for w = 1 to advSpokeArray.count do
					(
						advSpokeArray[w].render_renderable = False
						advSpokeArray[w].render_displayRenderMesh  = False
					)
				)
			)
			
			--delete existing web
			on deleteAdvanced pressed do
			(
				if advSpokeArray.count != 0 do
				(
					for i = 1 to advSpokeArray.count where (isValidNode advSpokeArray[i] == true) do 
					(
						delete advSpokeArray[i]
					)
				)
			)
		
		)
	)
	
	--subrollout 3 - User help
	rollout spiderWebHelp "Web Creator Help" rolledup: True
	(
		group "Basic Web Help"
		(
			edittext basicHelpText text:"Choose the settings you want and hit create.  \nPressing create again will remove an existing web.  \nYou may toggle on and off mesh.  \nDistortion changes how stretched/deformed the segments are." height: 65 readonly: True
		)
		
		group "Advanced Web Help"
		(
			edittext advHelpText text: "First, place points to act as locators for the spokes \nand a central point where it all meets. \nDraw the points in the order you want them.\nThen use the tools to select your central point \nand add the rest to the list. \nYou can control the growth value and a maximum number \nof segments as well as direction and mesh." height: 100 readonly: True
		)
		
		--placeholder for an expression to change the size of the rollout??
		--on spiderWebHelp rolledUp == False do <expr>
	)
	
	

	--create main rollout
	createDialog spiderWebMakerMain height: 750 width: 400
	
	--add subrollouts
	AddSubRollout spiderWebMakerMain.webRolloutBasic spiderWebBasic
	AddSubRollout spiderWebMakerMain.webRolloutAdvanced spiderWebAdvanced
	AddSubRollout spiderWebMakerMain.webRolloutHelp spiderWebHelp
	
	--position first rollout
	spiderWebMakerMain.webRolloutBasic.height += 200
	
	
	--position second rollout
	spiderWebMakerMain.webRolloutAdvanced.pos += [0, 200] 
	spiderWebMakerMain.webRolloutAdvanced.height += 380         
	
	
	--position third rollout
	spiderWebMakerMain.webRolloutHelp.pos += [0, 580]
	spiderWebMakerMain.webRolloutHelp.height += 100
)

  
