%Make_Pattern_360Arena
%% LIGHT ON dots 2 LED wide at each location on the screen
%   The dot location is encoded as combinations of x dim and y dim
%   xpos = 96 and y pos = 32 are the full screen dark. 

clear all;
numOfPanelsAcross = 12; % virtual 360 degrees repsented - 
numOfPanelsVertically = 4;% height of behavior arena
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

DOT_WIDTH = 2; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 96 for beahvior set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel;% 32 for yvette's current set up

%Save general infomation about pattern layout
pattern.x_num = LEDdotsAcross; % this variable will store where the dot is on the screen in x, last dim = 96 is blank incase needed
pattern.y_num = LEDdotsVertically; 		% Y will store where the dot is on the screen in y, last dim = 32 is blank incase needed

pattern.num_panels = 48; % 12x4 = 48 including fictive panels for 360 patterns % This is the number of unique Panel IDs required.
pattern.gs_val = 2; 	% This pattern gray scale value

Pats = zeros(LEDdotsVertically, LEDdotsAcross, pattern.x_num, pattern.y_num); 	%initializes the array with zeros

% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light

for ypos = 1: LEDdotsVertically - ( DOT_WIDTH - 1)   
    % build intial dot pattern for this y position
    dot_pattern = zeros( LEDdotsVertically , LEDdotsAcross);
    dot_pattern( ypos: ypos + DOT_WIDTH - 1 , 1 : DOT_WIDTH ) = 1; % draw light dot into matrix
    

    for xpos = 1: LEDdotsAcross - ( DOT_WIDTH - 1)
        
        % shift dot_pattern to each different location depending on current
        % x pos
        Pats(:, :, xpos , ypos) = ShiftMatrix (dot_pattern, (xpos - 1),'r','y'); % place 
       
    end
end

% To Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
Pats(:, : , pattern.x_num, pattern.y_num) = 0;

pattern.Pats = Pats; 		% put data in structure 

% NOTE: it seems like panel number must be continuous or it causes bugs.
% Don't skip any in the config file
pattern.Panel_map = [2,4,8,1,3,6,9,12,11,5,10,7;22,17,23,24,21,18,15,13,20,16,14,19;34,29,35,36,33,30,27,25,32,28,26,31;46,41,47,48,45,42,39,37,44,40,38,43];
% panels 7, 19, 31, 43 fictive and do not actually exist on hardware (gap
% behind the fly for camera view of the ball)

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);
 
 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\fisherlab\Documents\GitHub\panels-patternsAndFunctions_behaviorRig\patterns';
 str = [directory_name '\Pattern_001_2pixelBrightDot']; 	% name must begin with ‘Pattern_’
 save(str, 'pattern');
