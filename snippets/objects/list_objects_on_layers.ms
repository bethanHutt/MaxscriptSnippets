-- loop over all the layers
for i = 0 to LayerManager.count - 1 do
(
	-- get the layer by index
	local layer = LayerManager.getLayer i
	-- init a variable that will hold the layernodes
	local theNodes
	-- get the nodes
	layer.nodes &theNodes
	-- print to listener
	format "name: %, nodes: %\n" layer.name theNodes

)
