## Quick run

```
./run.sh
```

## Step-by-step run

- Mesh generation using [gmsh](https://gmsh.info): `gmsh gmsh/Logatchev.geo -3 -o gmsh/Logatchev.msh -format msh22`

- Convert gmsh (.msh) to OpenFOAM mesh format (polyMesh): `gmshToFoam gmsh/Logatchev.msh`

- Change front and back patches to `empty` because we want to run a 2D simulation. Using OpenFOAM build-in utility of `changeDictionary` to do so.

- Set permeability field of the simulation domain: `setFields`. The related dictionary file is the in `system` folder.

- Run the simulation: `HydrothermalSinglePhaseDarcyFoam`

## Clean the case 

```
./clean.sh
```