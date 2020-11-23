# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions


# 1 cp stl to constant/triSurface
mkdir constant/triSurface
unzip -o stl/stl.zip  # nevado/colima doesn't have DIY version of gmsh, so using .zip to track stl files
cp stl/Logatchev_Surface.stl constant/triSurface/Logatchev_Surface.stl
cp stl/Logatchev_detachment.stl constant/triSurface/Logatchev_detachment.stl
# 2. 
surfaceFeatureExtract
# 3. 
blockMesh
# parallel run
runApplication decomposePar
runParallel snappyHexMesh -parallel -overwrite
runApplication reconstructParMesh -constant -mergeTol 1e-6
rm -rf processor*

# change boundary  type
changeDictionary

# 2D
extrudeMesh
