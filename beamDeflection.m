%
% function      deflection = beamDeflection(positions,beamLength,loadPosition,loadForce,beamSupport)
%
% Author 1:     Anton Palm Folkmann (s163800@student.dtu.dk)
% Author 2:     Pascall Qvistgaard Christensen (s163782@student.dtu.dk)
% Date:         Spring 2017
% Course:       02631 Introduktion til programmering og databehandling F17
%
% function:     beamDeflection
%
% Description:  Calculates the deflection in any position wanted to be
%               measured. Here, the position can be either a scalar or a
%               vector, whereas the rest of the variables are only scalars.
%
% Parameters:   Position (scalar or vector), the rest are scalars.
%               
% Return:       An Nx2 array with only positive force position and load
%               values.
%
%
function deflection = beamDeflection(positions,beamLength,loadPosition,loadForce,beamSupport)

%Simplyfies variables
x = positions;
a = loadPosition;
W = loadForce;
l = beamLength;
E = 200*10^9; % [N/m^2]
I = 0.001; %[m^4]

%Prellocates a vector for function output
y = zeros(1,length(positions));

%Calculates deflection
for i = 1:length(positions)
    %For support mode "both"
    if strcmp(beamSupport,'Both')
        %For force position greater than measure point
        if x(i) < a
            y(i) = -((W*(l-a)*x(i))/(6*E*I*l))*(l^2-x(i)^2-(l-a)^2);
        %For measure point equal to or greater than force position
        elseif x(i) >= a
            y(i) = -((W*(l-x(i))*a)/(6*E*I*l))*(l^2-a^2-(l-x(i))^2);
        end
        
    %For support mode "Cantilever"
    elseif strcmp(beamSupport,'Cantilever')
        %For force position greater than measure point
        if x(i) < a
            y(i) = -((W*x(i)^2)/(6*E*I))*(3*a-x(i));
        %For measure point equal to or greater than force position
        elseif x(i) >= a
            y(i) = -((W*a^2)/(6*E*I))*(3*x(i)-a);
        end
    end
end

deflection = y;
end

