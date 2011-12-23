function [x0,y0,x1,y1]=convert_shape_deg(sx,sy,vd,xpx,ypx,xpos,ypos,xdeg,ydeg)
disp(nargchk(0, 9, nargin))

 
% SCREEN characteristics
% sx: screen x in pixels
% sy: screen y in pixels
% vd: viewing distance in cm
% xpx: screen size x in cm
% ypx: screen size y in cm

 
% SHAPE characteristics 
% xposs: postion of centre on x
% ypos: position of centre on y
% xdeg: total width in degrees
% ydeg: total height in degrees

 
% example usgae: 
% [shape.x0,shape.y0,shape.x1,shape.y1]=convert_shape_deg(800,600,10,10,10,0,0,4,4)

 
%% description
% this code takes shape characterists in degrees and returns a shape
% compatible with psychtoolbox x0,y0,x1,y1 definition.  To do this it must
% know the screen size and distance viewed from

 
%% variables
% globally define shape
shape_spec=[]
global shape
global shape_spec

 

 
%% calculations to create shape variables
x0=((sx/2)+(tand(xpos)*vd - 0.5*tand(xdeg)*vd))/sx*xpx;  
y0=((sy/2)+(tand(-1*ypos)*vd + 0.5*tand(-1*ydeg)*vd))/sy*ypx;
x1=((sx/2)+(tand(xpos)*vd + 0.5*tand(xdeg)*vd))/sx*xpx;
y1=((sy/2)+(tand(-1*ypos)*vd - 0.5*tand(-1*ydeg)*vd))/sy*ypx;

 
%shape_spec=[shape.x0 shape.y0 shape.x1 shape.y1]
