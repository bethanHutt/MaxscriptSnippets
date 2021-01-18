for each in objects do
(
	if each.material != undefined do
	(
		if ((substring each.material.name 1 8) == "Material") do
		(
			selectmore each
		)
	)
)	