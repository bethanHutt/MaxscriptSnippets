TILING_VAL = 1
textures = (getClassInstances bitmapTexture)
for texture in textures do
(
	texture.coords.u_tiling = TILING_VAL
	texture.coords.v_tiling = TILING_VAL
)