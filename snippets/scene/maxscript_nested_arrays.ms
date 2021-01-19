/*

array1 = #()
array2 = #()
array3 = #()

append array1 1
append array2 2
append array3 3

mymultiarray =#((array1),(array2),(array3))

*/

--Script to assign object names, classes, and material names to a multdimensional array.

(

clearListener()
	
--make empty arrays	
obname = #()
obclass = #()
obmatname = #()	
objdetails =#((obname),(obclass),(obmatname))

--append details to arrays
for obj in selection do
	(
		append obname obj.name
		append obclass (classOf obj)
		append obmatname obj.material.name
	)

--print array contents
for i in 1 to selection.count do
	(
		for a in 1 to objdetails.count do
		(
			print objdetails[a][i]
		)
	)
)