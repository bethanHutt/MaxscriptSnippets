
--toggle viewport

(
	if (viewport.GetRenderLevel() == #smooth) then	
		viewport.SetRenderLevel #Box
	else
		actionMan.executeAction 0 "550"
)