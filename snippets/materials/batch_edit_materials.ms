--Snip to rename materials in editor and add an opacity map.

for m = 1 to meditmaterials.count do
(
	if classof meditmaterials[m] == VRayMtl do
	(
		meditmaterials[m].name = (replace meditmaterials[m].name 10 0 "embroidery")
		meditmaterials[m].texmap_opacity = meditMaterials[24]
	)
)
