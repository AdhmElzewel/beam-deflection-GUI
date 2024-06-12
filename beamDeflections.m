%
% function      deflections = beamDeflections(positions,beamLength,loadPosition,loadForce,beamSupport)
%
% Author 1:     Anton Palm Folkmann (s163800@student.dtu.dk)
% Author 2:     Pascall Qvistgaard Christensen (s163782@student.dtu.dk)
% Date:         Spring 2017
% Course:       02631 Introduktion til programmering og databehandling F17
%
% function:     beamDeflections
%
% Description:  Calculates the deflection in any position wanted to be
%               measured. Here, the position, force position, and force
%               load, can be either a scalar or a vector, whereas the rest 
%               of the variables are only scalars.
%
% Parameters:   Position, force position, force load (scalar or vector),
%               the rest are scalars.
%               
% Return:       An Nx2 array with only positive force position and load
%               values.
%
%
function deflections = beamDeflections(positions,beamLength,loadPositions,loadForces,beamSupport)

%Prellocates a vector for function output 
y = zeros(1,length(positions));

%Uses the function beamDeflection to calculate deflection for multiple
%forces.
for j = 1:length(loadForces)
    y = y + beamDeflection(positions,beamLength,loadPositions(j),loadForces(j),beamSupport);
end

deflections = y;
end

