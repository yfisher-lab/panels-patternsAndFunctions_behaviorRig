clear all; close all;
%%

SAVE_NAME = 'Pattern_007_2pxBar-Wrap88-Straddle.mat';

LINE_WIDTH = 2;

BRIGHT_FEAT_ON_DARK = true;

MAKE_MASK = false;
maskColCoords = 65:72;

%%
numPanelsUsed = 11; % Number of panels to map the 0-10V signal to: exclude dummy panels.
numPanelsHoriz = 12; % Number of panels that comprise the 360 space: include dummies.
numPanelsVert = 4;
numDotsPerPanel = 8;
numDotsHoriz = numDotsPerPanel * numPanelsHoriz;
numDotsVert = numDotsPerPanel * numPanelsVert;

% Calculate number of scenes.
numScenesX = numPanelsUsed * numDotsPerPanel; 
numScenesY = 1 + 1; % Add extra Y-scene to be able to blank the display.

% Make panel_pattern structure.
panel_pattern.x_num = numScenesX; 
panel_pattern.y_num = numScenesY;
panel_pattern.num_panels = numPanelsHoriz * numPanelsVert;
panel_pattern.gs_val = 2; % 1, 2, 3, or 4. Typical bright bar expts are
                          % gs_val=2 but with '1' as the brightness.

panel_pattern.Panel_map = [02,04,08,01,03,06,09,12,11,05,10,07;
                           22,17,23,24,21,18,15,13,20,16,14,19;
                           34,29,35,36,33,30,27,25,32,28,26,31;
                           46,41,47,48,45,42,39,37,44,40,38,43];

if BRIGHT_FEAT_ON_DARK == true
    % Generate Pats = 4-D array (32x96x88x2 in many cases).
    Pats = zeros(numDotsVert, numDotsHoriz, numScenesX, numScenesY);
    featVal = 1;
elseif BRIGHT_FEAT_ON_DARK == false
    Pats = ones(numDotsVert, numDotsHoriz, numScenesX, numScenesY);
    featVal = 0;
end

sceneYi = 1; 
for sceneXi = 1:numScenesX-(LINE_WIDTH-1)

    % Draw the current scene in zeros or ones.
    if BRIGHT_FEAT_ON_DARK == true
        currSceneX = zeros(numDotsVert, numDotsHoriz);
    elseif BRIGHT_FEAT_ON_DARK == false
        currSceneX = ones(numDotsVert, numDotsHoriz);
    end
    
    % Make feature on scene in ones or zeros.
    xPos = sceneXi;
    currSceneX(:, xPos:(xPos+(LINE_WIDTH-1))) = featVal;
    
    % Set current scene to Pats array.
    Pats(:, :, sceneXi, sceneYi) = currSceneX;
end

% Handle wrapping.
for sceneXi = ((numScenesX-(LINE_WIDTH-1))+1):numScenesX
    
    % Draw the current scene in zeros or ones.
    if BRIGHT_FEAT_ON_DARK == true
        currSceneX = zeros(numDotsVert, numDotsHoriz);
    elseif BRIGHT_FEAT_ON_DARK == false
        currSceneX = ones(numDotsVert, numDotsHoriz);
    end

    % Make feature on scene in ones or zeros.
    xPos = sceneXi;
    currSceneX(:, xPos:numScenesX) = featVal;
    % Calculate number of columns filled.
    amountToWrap = length(xPos:numScenesX);
    % Calculate number of columns remaining = that need to be wrapped.
    amountToWrap = LINE_WIDTH - amountToWrap; 
    currSceneX(:, 1:amountToWrap) = featVal;

    % Set current scene to Pats array.
    Pats(:, :, sceneXi, sceneYi) = currSceneX;
end

% Make max Y-scene value equal to zeros (blank screen).
if BRIGHT_FEAT_ON_DARK == true
    Pats(:, :, :, panel_pattern.y_num) = 0;
elseif BRIGHT_FEAT_ON_DARK == false
    Pats(:, :, :, panel_pattern.y_num) = 1;
end


%%
if MAKE_MASK == true
    if BRIGHT_FEAT_ON_DARK == true
        Pats(:, maskColCoords, :, sceneYi) = 0;
    elseif BRIGHT_FEAT_ON_DARK == false
        Pats(:, maskColCoords, :, sceneYi) = 1;
    end
end

%%

panel_pattern.Pats = Pats;
panel_pattern.BitMapIndex = process_panel_map(panel_pattern);
panel_pattern.data = Make_pattern_vector(panel_pattern);

mainDir = 'C:\Users\fisherlab\Documents\GitHub\';
subDir = 'panels-patternsAndFunctions_behaviorRig\patterns\';
str = [mainDir subDir SAVE_NAME];
save(str, 'panel_pattern');
