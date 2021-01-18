matlibpath = "matlib" --add material library path
replacement_texture = "path" --add texture path here


--load .mat file
loadMaterialLibrary(matlibpath)
mat = currentMaterialLibrary[1]

--set to editor
mEditMaterials[1] = mat

--get bitmaps
a = #()
for i in (getClassInstances bitmaptexture target:mat ) do append a i
for i in a do (
	original_filepath = getFilenamePath i.bitmap.filename
	original_filename = filenameFromPath i.bitmap.filename

	new_path = replacement_texture
	i.filename = replacement_texture
	print new_path

	print i.bitmap.filename
)

