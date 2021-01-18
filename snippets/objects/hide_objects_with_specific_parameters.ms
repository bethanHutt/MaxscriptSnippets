--An example of hiding objects with specific parameters.

for obj in selection do
    if  classOf obj == Box and obj.heightsegs < 5
    then
        obj.ishidden = true
