(
	--script to put multisubs into an array and select them:	
	clearListener()
	
	--create arrays
	multisubs = #()
	msoNames = #()
	
	--for loop to select objects with msos
	for o in objects where (classof o.material == Multimaterial) do 
	(
		appendifunique multisubs o
	)
	select multisubs
	
	--adds names of mso shaders to array and prints them
	for i in 1 to multisubs.count do
	(
		appendifunique msoNames multisubs[i].material
	)
	print msoNames
)