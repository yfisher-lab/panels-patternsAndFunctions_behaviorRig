clear all; close all;
%%

LINE_WIDTH = 4;
BRIGHT_ON_DARK = false;

%%

numPanelsHoriz = 11;
numPanelsVert = 4;
numDotsPerPanel = 8;
numDotsHoriz = numDotsPerPanel * numPanelsHoriz;
numDotsVert = numDotsPerPanel * numPanelsVert;

% Calculate number of scenes.
numScenesX = numDotsHoriz;
numScenesY = 1;

% Make panel_pattern structure.
panel_pattern.x_num = numScenesX;
panel_pattern.y_num = numScenesY + 1;
panel_pattern.num_panels = numPanelsHoriz * numPanelsVert;
panel_pattern.gs_val = 2;

panel_pattern.Panel_map = [ 2, 4, 8, 1, 3, 6, 9,12,11, 5,10;... 7;...
                           22,17,23,24,21,18,15,13,20,16,14;...19;...
                           34,29,35,36,33,30,27,25,32,28,26;...31;...
                           46,41,47,48,45,42,39,37,44,40,38]; %43];

if BRIGHT_ON_DARK == true
    % Generate Pats = 4-D array (32x96x96x2 in most cases).
    Pats = zeros(numDotsVert, numDotsHoriz,...
                 panel_pattern.x_num, panel_pattern.y_num);
    vl = 1;
elseif BRIGHT_ON_DARK == false
    Pats = ones(numDotsVert, numDotsHoriz,...
                 panel_pattern.x_num, panel_pattern.y_num);
    vl = 0;
end

sceneYi = 1;
for sceneXi = 1:numScenesX-(LINE_WIDTH-1)

    % Draw the current scene in zeros.
    if BRIGHT_ON_DARK == true
        currSceneX = zeros(numDotsVert, numDotsHoriz);
    elseif BRIGHT_ON_DARK == false
        currSceneX = ones(numDotsVert, numDotsHoriz);
    end
    
    % Make feature on scene in ones.
    xPos = sceneXi;
    currSceneX(:, xPos:(xPos+(LINE_WIDTH-1))) = vl;
    
    % Set current scene to Pats array.
    Pats(:, :, sceneXi, sceneYi) = currSceneX;
end

% Handle wrapping.
for sceneXi = ((numScenesX-(LINE_WIDTH-1))+1):numScenesX
    
    % Draw the current scene in zeros.
    if BRIGHT_ON_DARK == true
        currSceneX = zeros(numDotsVert, numDotsHoriz);
    elseif BRIGHT_ON_DARK == false
        currSceneX = ones(numDotsVert, numDotsHoriz);
    end

    % Make feature on scene in ones.
    xPos = sceneXi;
    currSceneX(:, xPos:end) = vl;
    amountToWrap = length(currSceneX(1, sceneXi:end)); % How many cols filled?
    amountToWrap = LINE_WIDTH - amountToWrap; % How many cols still left? 
    currSceneX(:, 1:amountToWrap) = vl;

    % Set current scene to Pats array.
    Pats(:, :, sceneXi, sceneYi) = currSceneX;
end

% Make max Y-scene value equal to zeros (blank screen).
Pats(:, :, :, panel_pattern.y_num) = 0;


%%


%%

panel_pattern.Pats = Pats;

panel_pattern.BitMapIndex = process_panel_map(panel_pattern);
panel_pattern.data = Make_pattern_vector(panel_pattern);

