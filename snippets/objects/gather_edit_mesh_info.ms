(
    clearListener()

    --decalre variables and an empty array
    totalObjects = 0
    totalFaces = 0
    totalVerts = 0
    notMesh = #()

    for obj in selection do
    (
        --append meshes
        if isKindOf obj Editable_Mesh then
        (
            totalObjects += 1
            totalFaces += obj.numFaces
            totalVerts += obj.numVerts
        )
        --filter out non meshes
        else
        (
            append notMesh obj.name
        )

    )

    --show names of non meshes in messagebox
    msg = ("The following objects are not edit meshes:" + (notMesh as string) + ".  \nThey are skipped.")
    messageBox msg

    --print all the results
    print totalObjects
    print totalFaces
    print totalVerts
    print notMesh
)
