--Sphere creator rollout from tutorial

rollout SphereTool3 "Sphere Creator 3" width: 200
(
    spinner count "Number: " type:#integer range:[1,100,10]
    spinner growth "Radius growth:" range:[1,100,10]
    button create "Create Spheres"
    button del "Delete Spheres"

    local spheres = #()

    on create pressed do
        spheres = for i in 1 to count.value collect
            sphere radius: (i*growth.value) position: [i^2*growth.value,0,0]

    on del pressed do delete spheres

    on growth changed val do
        for i in 1 to spheres.count do
            (   spheres[i].radius = i * val
                spheres[i].pos = [i ^ 2 * val, 0, 0]
            )

    on count changed val do
    (
        delete spheres
        create.pressed()
    )
)

Rollout:SphereTool3
createDialog SphereTool3
