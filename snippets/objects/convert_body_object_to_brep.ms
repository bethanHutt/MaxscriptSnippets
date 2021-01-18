

fn convertToPwrNurb =
(
	sel = getCurrentSelection()
	
	if sel.count == 0 then
	(
		obs = objects
	)
	else
	(
		obs = sel
	)
	
	for each in obs do
	(
		if classof each == Body_Object then
		(
			select each
			disableSceneRedraw()
			StartObjectCreation Pwr_Join
			$.BrepOperation = 2
			StartObjectCreation Pwr_EditNRB
			max modify mode
			each.TwoSidedMeshesOP = off
			each.RenderViewportMeshRA = on
			enableSceneRedraw()
			CenterPivot  each
			clearselection()
		)
	)
	
)

convertToPwrNurb()