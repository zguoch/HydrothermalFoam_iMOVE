SetFactory("OpenCASCADE");
lc=150;
z1=-0.5;
z2=0.5;
xmin=2124;
xmax=9948;
ymin=-9300;
width_df = 10;
height_df = 8000;
xmin_df=5908.176100628931;
xmax_df=8519.98602375961;
ymin_df=-8020.8159287106655;
ymax_df=-2747.2152603731556;
//Bathymetry points: pts_bathy, lines: lines_bathy, surface: s_bathy
Include "Logatchev_bathy.geo";

theta=Atan2(ymax_df - ymin_df, xmax_df - xmin_df);
Printf("Angle of detachment fault: %g deg.", theta/Pi*180);
s_df = news;
Rectangle(s_df) = {xmin_df-width_df/2.0, ymin_df, z1, width_df, height_df, 0};
Rotate {{0,0,1}, {xmin_df, ymin_df, z1}, -Pi/2.0+theta} { Surface{s_df}; }

surfaces_df_merge[]=BooleanIntersection{ Surface{s_bathy};}{ Surface{s_df}; Delete;};
Printf("DF: %g", surfaces_df_merge[0]);
s_df = surfaces_df_merge[0];
s_crust=s_bathy;
// make intersection unique
s() = BooleanFragments{ Surface{s_df}; Delete; }{ Surface{s_crust};Delete; };//+
s_df = s[0];
s_crust = s[1];

// ===============mesh refinment of detachment fault region ==============
pt1=newp; Point(pt1) = {xmin_df, ymin_df, z1, lc};
pt2=newp; Point(pt2) = {xmin_df, ymin_df+height_df, z1, lc};
// help line
l_refine = newl; Line(l_refine)={pt1,pt2};
Rotate {{0,0,1}, {xmin_df, ymin_df, z1}, -Pi/2.0+theta} { Line{l_refine}; }
Field[1] = Attractor;
Field[1].NNodesByEdge = 400;
Field[1].EdgesList = {l_refine};
Field[2] = Threshold;
Field[2].IField = 1;
Field[2].LcMin = 2; // minimum cell size is 2m
Field[2].LcMax = lc;
Field[2].DistMin = width_df*1.5;
Field[2].DistMax = width_df*2;
Field[7] = Min;
Field[7].FieldsList = {2};
Background Field = 7;
// =======================================================================

// 2d to 3D
ss[]=Extrude {0, 0, z2-z1} {
    Surface{s_crust,s_df};
    Layers{1};
    Recombine;
};

v_crust=1;
v_df=2;

Physical Volume("crust") = {v_crust};
Physical Volume("detachment") = {v_df};
s_back={s_df,s_crust};
s_front={16, 18};
s_left=8;
s_right=10;
s_bottom=9;
s_seafloor={15, 17, 11};

s()=Unique(Abs(Boundary{ Volume{1:2}; }));
l() = Unique(Abs(Boundary{ Surface{s()}; }));
p[] = Unique(Abs(Boundary{ Line{l()}; }));
Characteristic Length{p()} = lc;

Physical Surface("front") = {s_front[]};
Physical Surface("back") = {s_back[]};
Physical Surface("sidewalls") = {s_left, s_right};
Physical Surface("seafloor") = {s_seafloor[]};
Physical Surface("bottom") = {s_bottom[]};

Color Grey{Surface{s_back[],s_front[]};}
Color Pink{Surface{s_bottom[]};}
Color Green{Surface{s_left,s_right};}
Color Blue{Surface{s_seafloor[]};}

Color Yellow{Volume{v_crust[]};}
Color Purple{Volume{v_df};}