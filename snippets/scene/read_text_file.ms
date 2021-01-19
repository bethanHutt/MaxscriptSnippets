(
	clearListener()
	
	objs = objects as array
	userProfile = systemTools.getEnvVariable("USERPROFILE")
	desktop = "Desktop\\script_test"
	saveUrl = substituteString(userProfile + "\\" + desktop + "\\TestTextFileCreate2.txt") "\\" "\\\\"
	flRd = openFile saveUrl mode: "r"
	nextLine = "\r"
	
	fn createObjReport =
	(
		-- A variable to hold the creation parameters of the text file to be written to:	
		
		flNw = createFile saveUrl
		
		--Open the text file for editing:
		
		flNw2 = openFile saveUrl mode: "a"
		
		-- openFile mode options:
		/*
		r - read-only text - file must exist
		rt - read-only text - file must exist
		rb - read-only binary - file must exist
		r+ - read/write text - file must exist
		a - write-only text, append writes - file must exist
		at - write-only text, append writes - file must exist
		ab - write-only binary, append writes - file must exist
		a+ - read/write text, append writes - file must exist
		w - write-only text - deletes file contents if it exists
		wt - write-only text - deletes file contents if it exists
		wb - write-only binary - deletes file contents if it exists
		w+ - read/write text - deletes file contents if it exists
		*/
		
		-- Create data to be written to the file. Could be an array, list of materials etc.
		
		for o = 1 to objs.count do
		(
			print ("Object #" + (o as string)) to: flNw2
			print ((objs[o].name) as string) to: flNw2
			print (classOf objs[o]) to: flNw2
			(
				if objs[o].material != undefined then
					(
						print "Yes" to: flNw2
					)
				else
					(
						print "No" to: flNw2
						continue
					)
			)	 
			print ((objs[o].material.name) as string) to: flNw2
			print (classOf (objs[o].material)) to: flNw2
		)
		
			
		-- Close the text file. This is important to do when you have added the text you want. VERY IMPORTANT
		close flNw2
		-- VERY IMPORTANT
		
	)
	
	
	
	fn printFile =
	(
		print ((readLine flRd))
		print ("The object is called " + (readLine flRd))
		print ("The object class is " + (readLine flRd))
		
		if (matchpattern (readLine flRd) pattern: "*Yes*" == true ) then
		(		
			print "There is a material on the object."
			print ("The material name is: " + (readLine flRd))
			print ("The material class is: " + (readLine flRd))
		)
		else
		(
			print "There is no material on this object."
		)
		
		print nextLine
	)
	
	
	createObjReport()
	(while eof flRd == false do printFile())
	close flRd
	
)