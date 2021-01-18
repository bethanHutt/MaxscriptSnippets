--Snippet to find objects with stitching map uvs on them
clearSelection()

for obj in geometry where (obj.modifiers[#Unwrap_UVW] != undefined) do selectmore obj
