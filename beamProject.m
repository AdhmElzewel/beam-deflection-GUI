%% Beam Project
%
% function      beamProject()
%
% Author 1:     Anton Palm Folkmann             (s163800@student.dtu.dk)
% Author 2:     Pascall Qvistgaard Christensen  (s163782@student.dtu.dk)
% Date:         29/8-2017
% Course:       02631 Introduktion til programmering og databehandling F17
%               Technical University of Denmark. 
%
% Description:  PLEASE READ THIS BEFORE USING THE BEAM GUI!
%               Creates a user-friendly GUI consisting of 18 different
%               local functions. Through the different GUI windows the user
%               can choose to either manually input settings for the beam
%               and forces acting upon it or load from a .mat file from the
%               same directory folder. The current settings can also be
%               saved to a .mat file to be loaded for future use.
%               
%               The functions in this file are split into several sections,
%               the first being this text header. The structure is this:
%
%                   Main function
%                       Beam configuration
%                           Beam configuration callbacks
%                       Force configuration
%                           Manual configuration
%                               Manual configuration callbacks
%                           Load configuration from file
%                               Load configuration callbacks
%                       Calculate deflection
%                               Calculate deflection callbacks
%                       Plot beam
%                       End beam setup
%
%               A short description will be assigned to each function in
%               the written code. The user of this GUI should read all
%               function descriptions to understand usage. Furthermore,
%               this function will be moderately commented to explain most
%               steps to people who aren't too familiar with how GUI's and
%               callbacks function.               
%
%               This script utilizes global variables. Other forms of data
%               passings have been studied. None have been succesfully 
%               implemented so far, but if you have suggestions to how 
%               global variables can be avoided it would be very helpful.
%
% Contents:
%
%   Functions written by 
%               Anton Palm Folkmann            (s163800@student.dtu.dk)
%               Pascall Qvistgaard Christensen (s163782@student.dtu.dk)
%       - beamProject
%       - beamDeflection
%       - beamDeflections
%       - beamPlot
%
%   Function written by
%               Robert Cummings                 (rcumming@matpi.com)
%       - uimulticollist
%
%-------------------------------------------------------------------------
%% Main function

function beamProject()
% This function initializes the whole GUI. First it defines all variables
% and sets their default settings. Three different types of settings are
% used. 
% 1)    Beam parameters:
%       beamlength defines the length of the beam.
%       bgselect is a string containing information about beam support.
%
% 2)    Force parameters:
%       flNames is an Nx1 array containing all names of forces added. 
%       flPositions is the same length as flNames and specifies where on
%       the beam the force is applied in [m].
%       flMagnitudes is the same size but describes magnitude in [N].
%       forceList is a Nx3 cell array containing the three force
%       parameters. 
%
% 3)    Measure parameters:
%       Basically analogue to force parameters. The only majer difference
%       is the third option, deflection which replaces the magnitude. Thede
%       parameters determine where the deflection is measured and
%       calculated.
%

global bgselect beamlength
bgselect = 'Both';
beamlength = 10;

global flNames flPositions flMagnitudes forceList
flNames = 'Force name';
flPositions = 'Force position [m]';
flMagnitudes = 'Force magnitude [N]';
forceList = {flNames flPositions flMagnitudes};

global plNames plPositions plDeflections positionList
plNames = 'Position name';
plPositions = 'Measure position [m]';
plDeflections = 'Calculated deflection [m]';
positionList = {plNames plPositions plDeflections};

% This section creates the main GUI window. First the figure is created,
% and then five pushbuttons. When one of the buttons are pushed it triggers
% a new figure with more options. S functions as a structure array, and fh
% is an abbreviation for 'figure head'. This will be used consistently 
% every time a new figure is created.
% In the long term, pb is short for pushbutton, rb for radiobutton, bg for
% radiobutton group, ls for listbox and ed for edit box. The rest should be
% relatively easy to guess based on context.

S.fh = figure('units','pixels',...
              'position',[340 210 400 310],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Beamscript GUI',...
              'resize','off');
          
% Five pushbuttons are created. They follow the structure for this file as
% shown in the header containing general information.
S.pb(1) = uicontrol('style','push',...
                    'units','pix',...
                    'position',[10 250 383 50],...
                    'string','Beam configuration',...
                    'callback',{@pb_beamConfig,S});
S.pb(2) = uicontrol('style','push',...
                    'units','pix',...
                    'position',[10 190 383 50],...
                    'string','Force configuration',...
                    'callback',{@pb_forceConfig,S});            
S.pb(3) = uicontrol('style','push',...
                    'units','pix',...
                    'position',[10 130 383 50],...
                    'string','Calculate deflection',...
                    'callback',{@pb_calcDeflec,S});
S.pb(4) = uicontrol('style','push',...
                    'units','pix',...
                    'position',[10 70 383 50],...
                    'string','Plot beam',...
                    'callback',{@pb_plotBeam,S});  
S.pb(5) = uicontrol('style','push',...
                    'units','pix',...
                    'position',[10 10 383 50],...
                    'string','End beam setup',...
                    'callback',{@pb_close,S});
end            
            
%-------------------------------------------------------------------------
%% BEAM CONFIGURATION

% Main beam config setup
function pb_beamConfig(varargin)
% Callback for beam configuration, the first button in the main function.

% The only variable that needs to be loaded right now is the support type.
global bgselect

% Get structure from the main function. 
S = varargin{3}; 

% Create new figure
T.fh = figure('units','pixels',...
              'position',[440 210 500 220],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Beam configuration',...
              'resize','off');

% Create a figure for beam support example          
T.ax = axes('units','pixels',...
            'position',[205 0 300 230]);          
beamSupportExample = imread('beamSupportExample.png');
imshow(beamSupportExample);

% Make the user choose support type
T.bg = uibuttongroup('Visible','off',...
                  'Position',[0 0 .412 1]);
% Create two radio buttons in the button group.
T.rb1 = uicontrol(T.bg,'Style',...
                  'radiobutton',...
                  'String','Both',...
                  'Position',[30 160 100 30],...
                  'callback',{@bC_rb_callback,T});
T.rb2 = uicontrol(T.bg,'Style','radiobutton',...
                  'String','Cantilever',...
                  'Position',[105 160 100 30],...
                  'callback',{@bC_rb_callback,T});
              
% Create explaining text              
T.rbed = uicontrol(T.bg,'Style','edit',...
                  'unit','pix',...
                  'position',[6 190 195 25],...
                  'string','Choose beam support type');
              
% Set the support type to match the user's choice, by default 'Both'.
if strcmp(bgselect,'Cantilever')
    set(T.bg,'SelectedObject',T.rb2);
elseif strcmp(bgselect,'Both')
    set(T.bg,'SelectedObject',T.rb1);
end

% Make sure the edit box cannot be altered.
set(T.rbed,'enable','off');
% Make the uibuttongroup visible after creating child objects.
T.bg.Visible = 'on';

%Create length setup
T.lnpb = uicontrol('style','push',...
                  'unit','pix',...
                  'position',[6 85 195 30],...
                  'string','Set beam length');
T.lned1 = uicontrol('style','edit',...
                     'unit','pix',...
                     'position',[6 120 91 30],...
                     'string','Beam length [m]:');
T.lned2 = uicontrol('style','edit',...
                     'unit','pix',...
                     'position',[101 120 99 30],...
                     'string','Positive number');
                 
% Make sure the edit box cannot be altered.                 
set(T.lned1,'enable','off');
% Set callback when the button is pushed.
set(T.lnpb,'call',{@bC_ed_callback,T});

%Create close window button
T.exit = uicontrol('style','push',...
                   'unit','pix',...
                   'position',[6 8 195 60],...
                   'string','Return to main menu',...
                   'callback',{@pb_close,T});

% When the main function is closed, this GUI will close too.               
set(S.fh,'deletefcn',{@fig_delet,T.fh})
end

%------------------------------
% Beam config callbacks

% Support type callback - button group
function bC_rb_callback(varargin)
% This callback executes when one of the two radiobuttons is clicked.

% The only variable that needs to be loaded right now is the support type.
global bgselect

% Get structure from the main configuration setup function. 
T = varargin{3};

% Get the string from the selected radiobutton and save it in the support
% type variable as either 'Both' or 'Cantilever'.
bgselect = get(get(T.bg,'SelectedObject'), 'String');

% Write selected option to the command window.
fprintf('Support beam style: %s\n',bgselect);
end

% Beam length callback - edit 
function bC_ed_callback(varargin)
% This callback executes when the pushbutton is clicked.

% Load beam length.
global beamlength

% Get structure from the main configuration setup function.
T = varargin{3};

% Import beam length string from the edit box. Then change it to number.
lengthBeam = get(T.lned2, 'String');
lengthBeam = str2double(lengthBeam);

% If beam length is numeric and positive set global variable, else error.
if isnumeric(lengthBeam)
    if lengthBeam > 0
        beamlength = lengthBeam;
        fprintf('Beamlength set to: %d [m].\n',beamlength);
    else
        fprintf('Beamlength must be a positive number.\n');
    end
else
    fprintf('Beamlength must be a positive number.\n');
end
end

%-------------------------------------------------------------------------
%% FORCE CONFIGURATION

%Force configuration setup
function pb_forceConfig(varargin)
% Callback for force configuration, the secon button on the main function.
% Serves as midway setup.

% Get structure from main function.
S = varargin{3}; 

% Create new figure with three different buttons.
T.fh = figure('units','pixels',...
              'position',[440 210 300 187],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Force configuration',...
              'resize','off');
T.pbmc = uicontrol('style','push',...
                   'units','pix',...
                   'position',[10 130 283 50],...
                   'string','Manual configuration',...
                   'callback',{@pb_fc_manCon,T});
T.pbfc = uicontrol('style','push',...
                   'units','pix',...
                   'position',[10 70 283 50],...
                   'string','Load configuration from file',...
                   'callback',{@pb_fc_loadCon,T});  
T.exit = uicontrol('style','push',...
                   'units','pix',...
                   'position',[10 10 283 50],...
                   'string','Return to main menu',...
                   'callback',{@pb_close,T});          

% Close window if main window is closed.
set(S.fh,'deletefcn',{@fig_delet,T.fh})    
end

%------------------------------
% MANUAL CONFIGURATION

% Main manual configuration setup
function pb_fc_manCon(varargin)
% Callback for manual configuration. Here the user is prompted to input
% names, positions, and magnitudes for all forces inputted. The forces are
% then showed in a listbox, here called h.

% Load forcelist defined in the main function and initialize h.
global forceList h

% Get structure from the midway function.
T = varargin{3}; 

% Create new figure. This figure serves as the window in where the
% forcelist is showed. If no forces are defined prior to the listbox is
% shown, there should only be one line visible, the forceList:
%       Force name      Force position [m]      Force magnitude [N]
U.list = figure('units','pixels',...
                'position',[330 200 400 294],...
                'menubar','none',...
                'numbertitle','off',...
                'name','Force list',...
                'resize','off');
            
h = uimulticollist('units','normalized','position',[0 0 1 1],...
                 'string',forceList,'columnColour',{'RED' 'BLUE' 'GREEN'});

% This figure hosts 6 edit boxes, and three pushbuttons. The edit boxes
% function as input and the pushbuttons as event starters. When the user
% has typed in values for a force, the 'Add force' button transfers the
% data to the listbox. The 'Delete force' button removes a force.
U.fh = figure('units','pixels',...
              'position',[740 200 206 294],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Manual configuration',...
              'resize','off');
U.lsed1 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[6 258 105 30],...
                    'string','Force name:');
U.lsed2 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[115 258 85 30],...
                    'string','Name');          
U.lsed3 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[6 220 105 30],...
                    'string','Force position [m]:');
U.lsed4 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[115 220 85 30],...
                    'string','Positive number');          
U.lsed5 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[6 182 105 30],...
                    'string','Force magnitude [N]:');
U.lsed6 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[115 182 85 30],...
                    'string','Positive number');          
set([U.lsed1,U.lsed3,U.lsed5],'enable','off');

%Add force to listbox
U.lsadd = uicontrol('style','push',...
                    'unit','pix',...
                    'position',[6 124 195 50],...
                    'string','Add force to listbox',...
                    'callback',{@mC_add_callback,U});
          
%Delete selected force in listbox
U.lsdel = uicontrol('style','push',...
                    'unit','pix',...
                    'position',[6 66 195 50],...
                    'string','Delete selected force',...
                    'callback',{@mC_del_callback,U});

%Create close window button
U.exit = uicontrol('style','push',...
                   'unit','pix',...
                   'position',[6 8 195 50],...
                   'string','Return to main menu',...
                   'callback',{@pb_close,U});

% Close both figures when midway GUI is closed.
set(T.fh,'deletefcn',{@fig_delet,[U.fh,U.list]})
end

%------------------------------
% Manual config callbacks

% Adds forces to the forcelist
function mC_add_callback(varargin)
% When the user clicks the 'Add force' button, this callback adds that
% force to the forcelist and updates the forcelist GUI. 
% It also resets the measure position list, since all the previousle
% calculated deflections are incorrect as a new force acts upon the beam.

% Load all variables altered in this callback.
global beamlength h flNames flPositions flMagnitudes forceList
global plNames plPositions plDeflections positionList

% Get structure from GUI.
U = varargin{3};

% Import name, position, and magnitude the user entered.
newName = get(U.lsed2, 'String');
newPosition = str2double(get(U.lsed4,'String'));
newMagnitude = str2double(get(U.lsed6,'String'));

% Both the position and magnutide have to be numeric and positive.
if isnumeric(newPosition) && isnumeric(newMagnitude)
    if newPosition > 0 && newMagnitude > 0
        if newPosition > beamlength
            fprintf('Force position must not exceed beam length');
        else
        
        % Create new row and insert in forcelist GUI.
        newRow = {newName newPosition newMagnitude};
        uimulticollist(h,'addRow',newRow)
        
        % Update variables.
        forceList = uimulticollist(h,'string');
        flNames = forceList(:,1);
        flPositions = forceList(:,2);
        flMagnitudes = forceList(:,3);
        
        % Reset measure variables.
        plNames = 'Position name';
        plPositions = 'Measure position [m]';
        plDeflections = 'Calculated deflection [m]';
        positionList = {plNames plPositions plDeflections};
        
        fprintf('%s position set to: %d [m].\n',newName,newPosition);
        fprintf('%s magnitude set to: %d [N].\n',newName,newMagnitude);
        end
    else
        fprintf('Force position and force magnitude must be positive.\n');
    end
else
    fprintf('Force position and force magnitude must be numeric.\n');
end
end

% Deletes forces from the forcelist
function mC_del_callback(varargin)
% When a line in the forcelist has been selected and the button 'Delete
% force' has been pushed, this callback executes.

% Load necessary variables.
global h flNames flPositions flMagnitudes forceList

% Get selected row.
rowSelect = uimulticollist(h,'value');

% If the selected row is the selected, show error. If not, delete.
if rowSelect == 1
    fprintf('Header cannot be deleted\n');
else
    uimulticollist(h,'value',1);
    uimulticollist(h,'delRow',rowSelect);
    forceList = uimulticollist(h,'string');
    flNames = forceList(:,1);
    flPositions = forceList(:,2);
    flMagnitudes = forceList(:,3);
end
end

%------------------------------
% LOAD CONFIGURATION FROM FILE

% Load config Setup
function pb_fc_loadCon(varargin)
% User GUI which gives the user opportunity to either save variables to a
% file or import from file. The variables are saved to a .mat-file and
% storage saved in the the directory as this GUI file.

% Get structure from the midway setup.
T = varargin{3}; 

% Create new figure which consists of 2 edit boxes and 4 pushbuttons.
U.fh = figure('units','pixels',...
              'position',[790 200 206 256],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Load configuration setup',...
              'resize','off');
U.lsed1 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[6 160 105 30],...
                    'string','Import filename:');
U.lsed2 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[115 160 85 30],...
                    'string','filename');          
set(U.lsed1,'enable','off');

% Re-initialize start-up settings.
U.pbini = uicontrol('style','push',...
                   'unit','pix',...
                   'position',[6 198 195 50],...
                   'string','Load default settings',...
                   'callback',{@pb_lC_initialize,U});

% Load beam configuration from filename written in edit box.
U.pbimp = uicontrol('style','push',...
                    'unit','pix',...
                    'position',[6 122 195 30],...
                    'string','Load settings from .mat-file',...
                    'callback',{@pb_lC_import,U});

% Export beam configuration to .mat-file.
U.pbexp = uicontrol('style','push',...
                    'unit','pix',...
                    'position',[6 66 195 50],...
                    'string','Export settings to .mat-file',...
                    'callback',{@pb_lC_export,U});

% Create close window button.
U.exit = uicontrol('style','push',...
                   'unit','pix',...
                   'position',[6 8 195 50],...
                   'string','Return to main menu',...
                   'callback',{@pb_close,U});

% When midway setup closes, close this figure.
set(T.fh,'deletefcn',{@fig_delet,U.fh})
end

%------------------------------
% Load config callbacks

function pb_lC_initialize(varargin)
% Resets all variables to startup settings.

global bgselect beamlength
bgselect = 'Both';
beamlength = 10;

global flNames flPositions flMagnitudes forceList
flNames = 'Force name';
flPositions = 'Force position [m]';
flMagnitudes = 'Force magnitude [N]';
forceList = {flNames flPositions flMagnitudes};

global plNames plPositions plDeflections positionList
plNames = 'Position name';
plPositions = 'Measure position [m]';
plDeflections = 'Calculated deflection [m]';
positionList = {plNames plPositions plDeflections};
end


function pb_lC_import(varargin)
% This callback function imports data from data .mat-file and overwrites
% variables which are loaded below.

global beamlength bgselect
global flNames flPositions flMagnitudes forceList
global plNames plPositions plDeflections positionList

% Get structure from GUI.
U = varargin{3};

% Import user's chosen filename.
filename = get(U.lsed2,'String');

% Checks if .mat-file exists in directory.
if ~exist(filename,'file')
    fprintf('Error: file not in directory\n');
else
    % If it exists, overwrite global variables.
    load(filename);
    
    beamlength = beam.length;
    bgselect = beam.support;
    
    flNames = beam.forcenames;
    flPositions = beam.forcepos;
    flMagnitudes = beam.forcemag;
    forceList = {flNames flPositions flMagnitudes};
    
    plNames = beam.measurenames;
    plPositions = beam.measurepos;
    plDeflections = beam.measuredef;
    positionList = {plNames plPositions plDeflections};
end
end


function pb_lC_export(varargin)
% Load varibales and then save them into .mat-file named expSet.mat.

global bgselect beamlength
global flNames flPositions flMagnitudes
global plNames plPositions plDeflections 

beam.length = beamlength;
beam.support = bgselect;

beam.forcenames = flNames;
beam.forcepos = flPositions;
beam.forcemag = flMagnitudes;

beam.measurenames = plNames;
beam.measurepos = plPositions;
beam.measuredef = plDeflections;

save expSet.mat beam
end

%-------------------------------------------------------------------------
%% CALCULATE DEFLECTION

function pb_calcDeflec(varargin)
% Callback for deflection calculation. This GUI mirrors the manual force
% configuration GUI almost exactly. The only differences are changed
% variable names.

% Position list instead of forcelist. g instead of h.
global positionList g

% Get structure from GUI.
S = varargin{3}; 

% Create positionlist.
T.list = figure('units','pixels',...
                'position',[330 200 450 254],...
                'menubar','none',...
                'numbertitle','off',...
                'name','Force list',...
                'resize','off');

g = uimulticollist('units','normalized','position',[0 0 1 1],...
                   'string',positionList,...
                   'columnColour',{'RED' 'BLUE' 'GREEN'});

% Create new figure where the user can input variables.
T.fh = figure('units','pixels',...
              'position',[790 200 206 254],...
              'menubar','none',...
              'numbertitle','off',...
              'name','Calculate Deflection',...
              'resize','off');
T.lsed1 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[6 218 105 30],...
                    'string','Position name:');
T.lsed2 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[115 218 85 30],...
                    'string','Name');          
T.lsed3 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[6 220-41 105 30],...
                    'string','Measure position [m]:');
T.lsed4 = uicontrol('style','edit',...
                    'unit','pix',...
                    'position',[115 220-41 85 30],...
                    'string','Positive number');          
set([T.lsed1,T.lsed3],'enable','off');

%Add measure position to listbox
T.lsadd = uicontrol('style','push',...
                    'unit','pix',...
                    'position',[6 124 195 50],...
                    'string','Add measure position to listbox',...
                    'callback',{@cD_add_callback,T});
          
%Delete selected measure position in listbox
T.lsdel = uicontrol('style','push',...
                    'unit','pix',...
                    'position',[6 66 195 50],...
                    'string','Delete selected measure position',...
                    'callback',{@cD_del_callback,T});

%Create close window button.
T.exit = uicontrol('style','push',...
                   'unit','pix',...
                   'position',[6 8 195 50],...
                   'string','Return to main menu',...
                   'callback',{@pb_close,T});
set(S.fh,'deletefcn',{@fig_delet,[T.fh,T.list]})
end

%------------------------------
% Calculate deflection callback

% Adds positions to the positionlist
function cD_add_callback(varargin)
% Mirrors the callback for 'Add force'.

% Load variables.
global g plNames plPositions plDeflections positionList
global flPositions flMagnitudes beamlength bgselect

% Get structure from GUI.
T = varargin{3};

% Get name and position.
newName = get(T.lsed2, 'String');
newPosition = str2double(get(T.lsed4,'String'));

% Position must be numeric, positive.
if isnumeric(newPosition)
    if newPosition > 0
        if newPosition > beamlength
            fprintf('Measure position must not exceed beam length');
        else
            % If there are no forces acting on beam, no deflection.
            [r,~] = size(flPositions);
            if r < 2
                newDeflection = 0;
                fprintf('No forces applied. No deflection.\n');
            else 
                % get variables and calculate deflection.
                loadPositions = str2double(flPositions(2:end));
                loadForces = str2double(flMagnitudes(2:end));
                newDeflection = beamDeflections(newPosition,beamlength,...
                loadPositions,loadForces,bgselect);
            end
        
        % Create new row and add it to position list.
        newRow = {newName newPosition newDeflection};
        uimulticollist(g,'addRow',newRow)
        
        % Update position list.
        positionList = uimulticollist(g,'string');
        plNames = positionList(:,1);
        plPositions = positionList(:,2);
        plDeflections = positionList(:,3);
               
        fprintf('%s position set to: %d [m].\n',newName,newPosition);
        fprintf('%s deflection set to: %d [m].\n',newName,newDeflection);
        end
    else
        fprintf('Measure position must be positive.\n');
    end
else
    fprintf('Measure position must be numeric.\n');
end
end

% Deletes forces from the forcelist
function cD_del_callback(varargin)
% Delete selected position from position list.

% Load necessary variables.
global g plNames plPositions plDeflections positionList

% Get selected row.
rowSelect = uimulticollist(g,'value');

% Delete row if not header.
if rowSelect == 1
    fprintf('Header cannot be deleted\n');
else
    uimulticollist(g,'value',1);
    uimulticollist(g,'delRow',rowSelect);
    positionList = uimulticollist(g,'string');
    plNames = positionList(:,1);
    plPositions = positionList(:,2);
    plDeflections = positionList(:,3);
end

end

%-------------------------------------------------------------------------
%% PLOT BEAM
function pb_plotBeam(varargin)
% Callback for beam plotting

% Load variables necessary to plot beam.
global bgselect beamlength flPositions flMagnitudes

% Get all forces and their positions.
loadPositions = str2double(flPositions(2:end));
loadForces = str2double(flMagnitudes(2:end));

% Plot beam.
beamPlot(beamlength,loadPositions,loadForces,bgselect)
end

%-------------------------------------------------------------------------
%% END BEAM SETUP

function pb_close(varargin)
% Close secondary GUI.
close(gcbf)  
end

function fig_delet(varargin)
% Executes when user closes the main function.
try
    delete(varargin{3})
catch
    % Do nothing.
end
end
