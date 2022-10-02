// ===== Info ===== //
/*
 IMPORTANT: rendering will be better for analyzing the model if fast-csg is enabled. As of writing, this feature is only available in the development builds and not the official release of OpenSCAD, but it makes rendering only take a couple seconds, even for comically large bins. Enable it in Edit > Preferences > Features > fast-csg
 the plane that is the top of the internal bin solid is d_height+h_base above z=0
 the magnet holes can have an extra cut in them to make it easier to print without supports
 tabs will automatically be disabled when gridz is less than 3, as the tabs take up too much space
 base functions can be found in "gridfinity-rebuilt-base.scad"
 examples at end of file

 BIN HEIGHT
 the original gridfinity bins had the overall height defined by 7mm increments
 a bin would be 7*u millimeters tall
 the lip at the top of the bin (3.8mm) added onto this height
 The stock bins have unit heights of 2, 3, and 6:
 Z unit 2 -> 7*2 + 3.8 -> 17.8mm
 Z unit 3 -> 7*3 + 3.8 -> 24.8mm
 Z unit 6 -> 7*6 + 3.8 -> 45.8mm

https://github.com/kennetek/gridfinity-rebuilt-openscad

*/

/**/
/* [Setup Parameters] */
$fa = 8;
$fs = 0.25;

/* [General Settings] */
// number of bases along x-axis
gridx = 2.5;  
// number of bases along y-axis   
gridy = 2;  
// bin height. See bin height information and "gridz_define" below.  
gridz = 6;   
// base unit
length = 42;

/* [Compartments] */
// DivX Number of x Divisions
divx = 1;
// DivY Number of y Divisions
divy = 1;

/* [Toggles] */
// Bottom screw/magnet holes
enable_holes = true;
// Extra cut inside magnet holes for better slicing
enable_hole_slit = true;
// Snap gridx height to nearest 7mm increment
enable_zsnap = false;
// enable upper lip for stacking other bins
enable_lip = true;
// disable the screw part of base holes
enable_screw = true; 
// internal fillet for easy part removal
scoop = true;

/* [Other] */

// determine what the variable "gridz" applies to based on your use case
gridz_define = 0; // [0:gridz is the height of bins in units of 7mm increments - Zack's method,1:gridz is the internal height in millimeters, 2:gridz is the overall external height of the bin in millimeters]
// the type of tabs
tab_style = 0; //[0:Full,1:Auto,2:Left,3:Center,4:Right,5:None]

// overrides internal block height of bin (for solid containers). Leave zero for default height. Units: mm
height_internal = 0; 

// Automatically guess the ideal base dividing values based on gridx and gridy (if they are integers, defaults to 1)
div_base_auto = true; 
// number of divisions per 1 unit of base along the X axis. For instance, a value of 3 would make 3 mini-bases per length. (default 1, only use integers)
div_base_x = 1;
// number of divisions per 1 unit of base along the Y axis. For instance, a value of 3 would make 3 mini-bases per length. (default 1, only use integers)
div_base_y = 1; 

// ===== Commands ===== //

color("tomato")
 gridfinityEqual(n_divx = divx, n_divy = divy, style_tab = tab_style, enable_scoop = scoop);

// ===== Reference Dimensions ===== //
/*[Other Miscellaneous Features]*/
// height of the base
h_base = 5;     
// outside rounded radius of bin
r_base = 4;     
// lower base chamfer "radius"
r_c1 = 0.8;     
// upper base chamfer "radius"
r_c2 = 2.4;     
// bottom thiccness of bin
h_bot = 2.2;    
// outside radii 1
r_fo1 = 8.5;    
// outside radii 2
r_fo2 = 3.2;
// outside radii 3
r_fo3 = 1.6; 

// screw hole radius
r_hole1 = 1.5;  
// magnet hole radius
r_hole2 = 3.25; 
// center-to-center distance between holes
d_hole = 26;    
// magnet hole depth
h_hole = 2.4;   

// top edge fillet radius
r_f1 = 0.6;     
// internal fillet radius
r_f2 = 2.8;     

// width of divider between compartments
d_div = 1.2;    
// minimum wall thickness
d_wall = 0.95;  
// tolerance fit factor 
d_clear = 0.25; 

// height of tab (yaxis, measured from inner wall)
d_tabh = 15.85;    
// maximum width of tab 
d_tabw = 42; 
// angle of tab   
a_tab = 36; 

// ===== Include ===== //

include <gridfinity-rebuilt-utility.scad>



// ===== Examples =====

// ALL EXAMPLES ASSUME gridx == 3 AND gridy == 3 but some may work with other settings

// 3x3 even spaced grid
//gridfinityEqual(n_divx = 3, n_divy = 3, style_tab = 0, enable_scoop = true);

// Compartments can be placed anywhere (this includes non-integer positions like 1/2 or 1/3). The grid is defined as (0,0) being the bottom left corner of the bin, with each unit being 1 base long. Each cut() module is a compartment, with the first four values defining the area that should be made into a compartment (X coord, Y coord, width, and height). These values should all be positive. t is the tab style of the compartment (0:full, 1:auto, 2:left, 3:center, 4:right, 5:none). s is a toggle for the bottom scoop. 
/*
gridfinityCustom() {
    cut(x=0, y=0, w=1.5, h=0.5, t=5, s=false);
    cut(0, 0.5, 1.5, 0.5, 5, false);
    cut(0, 1, 1.5, 0.5, 5, false);
    
    cut(0,1.5,0.5,1.5,5,false);
    cut(0.5,1.5,0.5,1.5,5,false);
    cut(1,1.5,0.5,1.5,5,false);
    
    cut(1.5, 0, 1.5, 5/3, 2);
    cut(1.5, 5/3, 1.5, 4/3, 4);
}*/

// Compartments can overlap! This allows for weirdly shaped compartments, such as this "2" bin. 
/*
gridfinityCustom() {
    cut(0,2,2,1,5,false);
    cut(1,0,1,3,5);
    cut(1,0,2,1,5);
    cut(0,0,1,2);
    cut(2,1,1,2);
}*/

// Areas without a compartment are solid material, where you can put your own cutout shapes. using the cut_move() function, you can select an area, and any child shapes will be moved from the origin to the center of that area, and subtracted from the block. For example, a pattern of three cylinderical holes.
/*
gridfinityCustom() {
    cut(x=0, y=0, w=2, h=3);
    cut(x=0, y=0, w=3, h=1, t=5);
    cut_move(x=2, y=1, w=1, h=2) 
        pattern_linear(x=1, y=3, spacing=length/2) 
            cylinder(r=5, h=10*d_height, center=true);
}*/

// You can use loops as well as the bin dimensions to make different parametric functions, such as this one, which divides the box into columns, with a small 1x1 top compartment and a long vertical compartment below

/*gridfinityCustom() {
    for(i=[0:gridx-1]) {
        cut(i,0,1,gridx-1);
        cut(i,gridx-1,1,1);
    }
}*/

// Pyramid scheme bin
/*
gridfinityCustom() {
    for (i = [0:gridx-1]) 
    for (j = [0:i])
    cut(j*gridx/(i+1),gridy-i-1,gridx/(i+1),1,0);
}*/
