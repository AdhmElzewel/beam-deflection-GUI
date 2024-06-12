%
% function      beamPlot(beamLength,loadPosition,loadForce,beamSupport)
%
% Author 1:     Anton Palm Folkmann             (s163800@student.dtu.dk)
% Author 2:     Pascall Qvistgaard Christensen  (s163782@student.dtu.dk)
% Date:         Spring 2017
% Course:       02631 Introduktion til programmering og databehandling F17
%
% function:     beamPlot
%
% Description:  A diagram is created based on the force matrix. It shows 
%               the deflection of the beam dependent on support type.
%               
% Parameters:   An Nx2 array.
%               
% Return:       One deflection plot, "both" or "cantilever".
%         
function beamPlot(beamLength,loadPosition,loadForce,beamSupport)

%Calculating the deflection every centimeter of the beam
lengthVec = 0:0.01:beamLength;
deflections = beamDeflections(lengthVec,beamLength,loadPosition,loadForce,beamSupport);

%Finds value and position of max deflection
maxDef = min(deflections);
I = maxDef == deflections;
maxDefPos = lengthVec(I);

%Converts value of beamlength and max deflection to string
beamLengthStr = num2str(beamLength);
maxDefStr = num2str(maxDef);

%Plots beam with forces, max deflection, and the neutral beam
figure;
hold on
plot(lengthVec,deflections);
plot(maxDefPos,maxDef,'b.','MarkerSize',10);
plot([0,beamLength],[0,0],'k--')

%Prellocates vector to use for force plotting
lenForces = length(loadPosition);
zeroVector = zeros(1,lenForces);

%Plots all the forces as arrows
for j = 1:lenForces
    plot(loadPosition(j),zeroVector(j),'r.','MarkerSize',10);
    str = sprintf('%s %d N','\downarrow',loadForce(j));
    text(loadPosition(j),zeroVector(j) - 0.5*maxDef,str)
end

%Sets limits on axes and names labels
xlim([-1 beamLength+1])
ylim([-0.000000001+1.5*maxDef 0.000000001+(-2.5)*maxDef])
xlabel('Length [m]');
ylabel('Deflection [m]');

%Defines and plots the legend
dim = [.2 .5 .3 .3];
str11 = 'Beam length =  [m]';
str12 = insertAfter(str11,14,beamLengthStr);
str21 = 'Maximum deflection =  [m]';
str22 = insertAfter(str21,21,maxDefStr);
str3 = 'E-module = 200*10^9 [N/m^2]';
str4 = 'Inertia moment = 0.001 [m^4]';
str = {str12,str22,str3,str4};
annotation('textbox',dim,'String',str,'FitBoxToText','on');

if strcmp(beamSupport,'Both')
    
    %Plots title and support it the support is "both"
    title('Deflection for support "both"')
    plot([0,0+beamLength],[0,0],'r^','MarkerSize',10);
    
elseif strcmp(beamSupport,'Cantilever')
    
    %Plots title and support it the support is "cantilever"
    title('Deflection for support "cantilever"')
    plot(0,0,'r>','MarkerSize',10);
     
end

end

