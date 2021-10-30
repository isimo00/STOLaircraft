clc,clear,close all

%% INPUT DATA
% WEIGHTS OBTAINED FROM PREVIOUS CALCULATIONS
MPL = 4125;
MFW = 4524;
FWr = 0.158127483; %fuel-weight ratio for the whole mission

%GEOMETRY
ar = 8;

%% WEIGHT COMPUTATION
[MTOW,OEW,FW] = weights(MPL,FWr);

%% RANGE
[R_MPL,R_MTOW,R_max] = Range(MTOW,OEW,MPL,FW,MFW);

%% DESIGN POINT
[S,P] = design(MTOW,ar);

%% CG
[xCoM_0,xCG] = centering(FW);

%% LOADING
loadGraph();
