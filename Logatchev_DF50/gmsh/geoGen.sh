datapath=.
bathy_profile=$datapath/bathy.dat
detachment_profile=$datapath/detachment.txt
dist_offset=0 # m
path_gmsh=.
gmshfile_geo=Logatchev
xmin=`awk -v dist_offset=$dist_offset 'NR==1{printf "%.0f",$1+dist_offset}' $bathy_profile`
xmax=`awk -v dist_offset=$dist_offset 'END{printf "%.0f",$1+dist_offset}' $bathy_profile`
ymin=-9300

function writeBathyGeo
{
    geofile=$path_gmsh/$1.geo
    echo '//SetFactory("OpenCASCADE");' >$geofile
    echo '//lc=500;' >>$geofile
    echo '//z1=-100;' >>$geofile
    echo "//xmin=$xmin;" >>$geofile
    echo "//xmax=$xmax;" >>$geofile
    echo "//ymin=$ymin;" >>$geofile
    echo "//points: pts_bathy, lines: lines_bathy" >>$geofile
    awk -v dist_offset=$dist_offset '{printf "tmp=newp;Point(tmp)={%.0f, %.0f, z1, lc};pts_bathy[%d]=tmp;\n",$1+dist_offset, $2,NR-1}' $bathy_profile >>$geofile
    echo "Spline_bathy=newl;Spline(Spline_bathy)={pts_bathy[]};">>$geofile
    # delete bathymetry point
    echo "For j In {1:#pts_bathy[]-2}">>$geofile
    echo "Recursive Delete {">>$geofile
    echo "    Point{pts_bathy[j]}; ">>$geofile
    echo "    }">>$geofile
    echo "EndFor">>$geofile
    # bottom right
    echo "pts_lines[0]=pts_bathy[#pts_bathy[]-1];">>$geofile
    echo "$xmax $ymin" | awk -v dist_offset=$dist_offset '{printf "pt_BR=newp;Point(pt_BR)={%.0f, %.0f, z1, lc};pts_lines[#pts_lines[]]=pt_BR;\n",$1, $2}' >>$geofile
    echo "$xmin $ymin" | awk -v dist_offset=$dist_offset '{printf "pt_BL=newp;Point(pt_BL)={%.0f, %.0f, z1, lc};pts_lines[#pts_lines[]]=pt_BL;\n",$1, $2}' >>$geofile
    echo "pts_lines[#pts_lines[]]=pts_bathy[0];">>$geofile
    # connect to lines
    echo "lines_bathy[0]=Spline_bathy;">>$geofile
    echo "For j In {0:#pts_lines[]-2}">>$geofile
    echo "     tmp=newl;Line(tmp)={pts_lines[j],pts_lines[j+1]};lines_bathy[#lines_bathy[]]=tmp;" >>$geofile
    echo "EndFor">>$geofile
    # plane surface
    echo "s_bathy=news;" >>$geofile
    echo "Curve Loop(s_bathy) = {lines_bathy[]};">>$geofile
    echo "Plane Surface(s_bathy) = {s_bathy};">>$geofile
    
}
function writeMainGeo()
{
    geofile=$path_gmsh/$1.geo
    echo 'SetFactory("OpenCASCADE");' >$geofile
    echo 'lc=500;' >>$geofile
    echo 'z1=-100;' >>$geofile
    echo "xmin=$xmin;" >>$geofile
    echo "xmax=$xmax;" >>$geofile
    echo "ymin=$ymin;" >>$geofile
    echo "xmin_df=5908.176100628931;" >>$geofile
    echo "xmax_df=8519.98602375961;" >>$geofile
    echo "ymin_df=-8020.8159287106655;" >>$geofile
    echo "ymax_df=-2747.2152603731556;" >>$geofile
    echo "//Bathymetry points: pts_bathy, lines: lines_bathy, surface: s_bathy">>$geofile
    echo 'Include "'${gmshfile_geo}_bathy.geo'";'>>$geofile
}

# write basic geo file with bathymetry
writeBathyGeo ${gmshfile_geo}_bathy
# write main geo
# writeMainGeo $gmshfile_geo
