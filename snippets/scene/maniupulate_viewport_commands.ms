--first, reset all views
viewport.ResetAllViews()

--store position matrix
defaultPos = (viewport.getTM())

--change angle to default
(viewport.setTM (matrix3 [0.707107,0.353553,-0.612372] [-0.707107,0.353553,-0.612372] [0,0.866025,0.5] [0,0,-250]))

--set to single view
viewport.setLayout #layout_1

--set viewport to shaded
viewport.SetRenderLevel #smooth

-- set to persp
viewport.setType #view_persp_user

--set view to left
viewport.setType #view_front

--set view to front
viewport.setType #view_right

-- toggle grid
max grid toggle

--zoom to selection
max tool zoomextents
