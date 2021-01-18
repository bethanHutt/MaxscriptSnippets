fn collapse_uv_mod =
(
	if selection.count == 0 do return()

	sel = selection as array

	for obj in sel do
	(
		if obj.modifiers.count == 0 then continue

		--go backwards through the modifiers
		for m in 1 to obj.modifiers.count do
		(
			--stops when it reaches a turbosmooth or a displacement modifier
			if (classOf obj.modifiers[m] == Unwrap_UVW) do
			(
				maxOps.CollapseNodeTo obj (m) true
			)
		)
	)

)

collapse_uv_mod()
