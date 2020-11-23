#!/bin/sh
cd ${0%/*} || exit 1    # Run from this directory

# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions

application=`getApplication`

./clean.sh
# 1. meshing
./meshing_par.sh

# 4. set permeability
runApplication setFields
# 5. run
runApplication $application
# 6. postprocessing
# ./postProcess.sh