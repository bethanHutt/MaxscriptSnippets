(
	clearListener()
	myObjs = objects as array
	if myObjs.count != 0 then
	(
		for i = 1 to myObjs.count do
		(
			print( myObjs[i].name + "\n")
			print( "class of object: " + (classOf myObjs[i] as string)  + "\n")
			print( "super class of object: " + (superClassOf myObjs[i] as string)  + "\n")
		)
	)
	else
	(
		print("There are no objects selected")
	)
)