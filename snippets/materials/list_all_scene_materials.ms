for aMtlType in material.classes do
(
    for aMtl in (getClassInstances aMtlType processAllAnimatables:true) do
    (
        print aMtl
        -- Does this material exist in the scene or not?
        if (findItem sceneMaterials aMtl) == 0 do (print "This material does not exist in the scene")
    )
)
