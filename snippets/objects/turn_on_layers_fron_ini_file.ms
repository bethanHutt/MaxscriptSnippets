(
	clearListener()
	
	--choose file to read
	saveUrl = getOpenFileName caption:"Choose an ini file to import:" types:"Ini(*.ini)|*.ini|Text(*.txt)|*.txt|"
	flRd = openFile saveUrl mode: "r"

	--first turn off all layers
	for x=0 to LayerManager.count-1 do (LayerManager.getLayer x).on=false

	--create temporary array to store layers
	tempArray = #()
	
	--function to populate array with layer names	
	fn getLayerName =
	(
		curLine = ((readLine flRd))
		splitPoint = (findString curLine "=")
		if splitPoint != undefined do
		(
			editedLine = (substring curLine (splitPoint+1) -1)
			append tempArray editedLine
		)
		
	)
	
	--run above function until you reach the end of the file
	(while eof flRd == false do getLayerName())
	close flRd
		
	--for each entry in the 
	for o = 1 to tempArray.count do
	(
		--if layer isn't in scene print and ignore it:
		if (LayerManager.getLayerFromName tempArray[o]) == undefined then
		(
			print (tempArray[o] + " does not exist in the scene.  Ignoring.")
		)
		--otherwise, if it does exist, turn it on
		else
		(
			(LayerManager.getLayerFromName tempArray[o]).on = true
		)
	)
		
)