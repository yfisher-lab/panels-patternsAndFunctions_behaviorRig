%make_positionFunction_360Arena

%% Static function, static Zero (keeps x or y-pos at intial setting)
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
positionArray = zeros(1, POSITION_FUNCTION_LENGTH);

func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\fisherlab\Documents\GitHub\panels-patternsAndFunctions_behaviorRig\functions';
 str_x = [directory_name '\position_function_001_staticPattern_Zero']; 
 save(str_x, 'func'); % variable must be named 'func'
 
 
 %% Static function, static One (moves x or y-pos to one greater than intial setting)
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
positionArray = ones(1, POSITION_FUNCTION_LENGTH);

func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\fisherlab\Documents\GitHub\panels-patternsAndFunctions_behaviorRig\functions';
 str_x = [directory_name '\position_function_002_staticPattern_One']; 
 save(str_x, 'func'); % variable must be named 'func'

%% ~15Deg/s RIGHTWARD Motion either for Dot or Grating or bar pattern:

PANELS_FRAME_RATE = 50; %Hz
POSITION_FUNCTION_LENGTH = 1000; % this how many frames long these normally are... set by panels
numOfPanelsAcross = 12;% panels across
numOfPanelsVertically = 4;%
LEDdotsPerPanel = 8; % this shouldn't change!  LEDs are always 8 dots in x and y. 

LEDdotsAcross = numOfPanelsAcross * LEDdotsPerPanel; % 95 for behavior rig

PATTERN_SPEED_DEG_PER_SEC = 15;% deg/s  
DEGREES_PRE_PIXEL = 3; % deg THIS IS very APPROXIMATE!!

% Warning zero indexing for the position funciton!!
XDimMin = 0;% 
XDimMax = LEDdotsAcross;% 

positionArray = [];
switchingCounter = true;

pixelPerSecond = PATTERN_SPEED_DEG_PER_SEC / DEGREES_PRE_PIXEL; % corresponding LED pixel per second
%how many frames should be spent at each function position.
framesDwellPerPixel =  PANELS_FRAME_RATE / pixelPerSecond; % frames/pixel=( (frames/s) / (pixel/s) )

currFrameCounter = XDimMin;
while (length (positionArray) < POSITION_FUNCTION_LENGTH) && (currFrameCounter <= XDimMax)
    
    addToArray = currFrameCounter * ones( 1,  framesDwellPerPixel );

    positionArray = [positionArray addToArray ];
    
    currFrameCounter = currFrameCounter + 1;     
end

func = positionArray;
%% SAVE position function place to be put on the SD card:
% place to save patterns to be put on the SD card:
 directory_name = 'C:\Users\fisherlab\Documents\GitHub\panels-patternsAndFunctions_behaviorRig\functions';
 str_x = [directory_name '\position_function_003_movingRightPattern_15degS']; 
 save(str_x, 'func'); % variable must be named 'func'


