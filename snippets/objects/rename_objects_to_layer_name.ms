clearSelection()
for l = 1 to layerManager.count-1 do
(
	--store layer name
	layerName = (layerManager.getLayer l).name
	--select all objects on that layer
	(layerManager.getLayer l).select true
	--change the name of objects on that layer to a unique name based on layer name
	for obj in selection do
	(
		obj.name = uniqueName layerName
	)
	clearSelection()
)