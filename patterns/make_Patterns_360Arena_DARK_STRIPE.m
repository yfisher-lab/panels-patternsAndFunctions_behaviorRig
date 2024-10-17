 %% VERTICAL STRIPE 2 LED wide

clear all;
numOfPanelsAcross = 12; % virtual 360 degrees repsented - 
numOfPanelsVertically = 4;% height of behavior arena
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LINE_WIDTH = 4; % number of LED dots wide

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 96 for beahvior set up
LEDdotsVertically = numOfPanelsVertically * LEDdotsPerPanel; % 32 for current set up

%Save general infomation about pattern layout
panel_pattern.x_num = LEDdotsAcross; % this variable will store where the dot is on the screen in x, last dim = 96 is blank incase needed
panel_pattern.y_num = 2; 		% Y will store where the dot is on the screen in y, last dim = 32 is blank incase needed

panel_pattern.num_panels = 48; % 12x4 = 48 including fictive panels for 360 patterns % This is the number of unique Panel IDs required.
panel_pattern.gs_val = 3; 	% This pattern gray scale value

Pats = ones(LEDdotsVertically, LEDdotsAcross, panel_pattern.x_num, panel_pattern.y_num); 	%initializes the array with zeros% Construct the dot patterns within each dimention
% zeros 0 = dark, ones 1 = light
YPOS_TODRAW = 1;

for xpos = 1: LEDdotsAcross - ( LINE_WIDTH - 1)   
    % build line for x 
    line_pattern = ones( LEDdotsVertically , LEDdotsAcross);

    %YF: this line of code was drawing a new line that was shifted to the
    %correct position
    line_pattern( : , xpos: xpos + LINE_WIDTH - 1 ) = 0; % draw vertical line
    
    % YF: this line of code was shifting that position another one column
    % over
    % Pats(:,:, xpos, YPOS_TODRAW) = ShiftMatrix (line_pattern, (xpos - 1),'r','y');

    Pats(:,:, xpos, YPOS_TODRAW) = line_pattern;
end

% For wrap around:
% Frame 94
Pats(:, 1, 94, 1) = 0;
Pats(:, 94:96, 94, 1) = 0;
% 95
Pats(:, 1:2, 95, 1) = 0;
Pats(:, 95:96, 95, 1) = 0;
% 96
Pats(:, 1:3, 96, 1) = 0;
Pats(:, 96, 96, 1) = 0;

% To Make sure whole matrix is blank when x or y is max  = 0 for a blank
% screen,
%Pats(:, : , panel_pattern.x_num, :) = 1;

panel_pattern.Pats = Pats; 		% put data in structure 

% NOTE: it seems like panel number must be continuous or it causes bugs.
% Don't skip any in the config file
panel_pattern.Panel_map = [2,4,8,1,3,6,9,12,11,5,10,7;22,17,23,24,21,18,15,13,20,16,14,19;34,29,35,36,33,30,27,25,32,28,26,31;46,41,47,48,45,42,39,37,44,40,38,43];
% panels 7, 19, 31, 43 fictive and do not actually exist on hardware (gap
% behind the fly for camera view of the ball)

panel_pattern.BitMapIndex = process_panel_map(panel_pattern);
panel_pattern.data = Make_pattern_vector(panel_pattern);


 %% SAVE pattern place to save patterns to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\fisherlab\Documents\GitHub\panels-patternsAndFunctions_behaviorRig\patterns';
 str = [directory_name '\Pattern_002_2pixelBrightBar']; 	% name must begin with ‘Pattern_’
 save(str, 'panel_pattern');
