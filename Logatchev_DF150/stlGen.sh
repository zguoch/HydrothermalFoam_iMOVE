mkdir stl
gmsh gmsh/TAG.geo -2 -o stl/TAG.stl -format stl  # pretty cool! my DIY gmsh!!! see https://gitlab.com/hydrothermal-openfoam/gmsh
zip stl/stl.zip stl/TAG_Surface.stl stl/TAG_pipe.stl stl/TAG_detachment.stl
