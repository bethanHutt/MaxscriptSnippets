
(
	if selection.count > 0 then
	(
		for obj in selection do
		(
			if obj.modifiers.count > 0 do
			(
				for m in obj.modifiers.count to 1 by -1 do
				(
					if (classOf obj.modifiers[m] == TurboSmooth or classOf obj.modifiers[m] == VrayDisplacementMod) do
					(
						maxOps.CollapseNodeTo obj (m-1) true
					)
				)
			)
		)
	)
	else
	(
		messagebox "Please select the objects you wish to collapse first."
	)
)