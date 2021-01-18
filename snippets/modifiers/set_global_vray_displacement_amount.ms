DISPLACE_AMOUNT = -0.7
mods = (getClassInstances VRayDisplacementMod)
for mod in mods do
(
    mod.amount = DISPLACE_AMOUNT
)
