fn delete_empty_selsets = 
(
	for idx = selectionSets.count to 1 by -1 do
	(
		selset = selectionSets[idx]
		if selset.count != 0 then continue
		if isDeleted(selset) then continue
		deleteItem selectionSets selset
	)
)

delete_empty_selsets()