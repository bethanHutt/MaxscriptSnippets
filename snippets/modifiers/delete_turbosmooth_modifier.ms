fn removeTS loc =
(
	sel = selection as array
	scn = geometry as array

	(
		for obj in loc do
			(
				for theMod in obj.modifiers where classOf theMod == turboSmooth do
				(
					deleteModifier obj theMod
				)
			)
	)
)

removeTS scn
