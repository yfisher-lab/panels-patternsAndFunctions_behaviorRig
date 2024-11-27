clear all; close all;
%%

SAVE_NAME = 'Pattern_011_Gradient.mat';

gsVal = 4;

%%
numPanelsUsed = 12; % Number of panels to map the 0-10V signal to: exclude dummy panels.
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
panel_pattern.gs_val = gsVal;

panel_pattern.Panel_map = [02,04,08,01,03,06,09,12,11,05,10,07;
                           22,17,23,24,21,18,15,13,20,16,14,19;
                           34,29,35,36,33,30,27,25,32,28,26,31;
                           46,41,47,48,45,42,39,37,44,40,38,43];

%%
Pats = zeros(numDotsVert, numDotsHoriz, numScenesX, numScenesY);

%% Make an initial gradient scene and set to first Pats matrix.

initXScene = zeros(numDotsVert, numDotsHoriz);
for i = 1:16
    initXScene(:,((i*3)-2):(i*3)) = i-1;
end

initXScene(:,49:96) = flip(initXScene(:,1:48),2);

Pats(:,:,1,1) = initXScene;

%% Rotate the gradient.

for i = 2:96
    prevScene = Pats(:,:,i-1,1);
    nextScene = prevScene;
    nextScene(:,1) = prevScene(:,96);
    for col = 2:length(nextScene(1,:))
        nextScene(:,col) = prevScene(:,col-1);
    end
    Pats(:,:,i,1) = nextScene;
end

%%
panel_pattern.Pats = Pats;
panel_pattern.BitMapIndex = process_panel_map(panel_pattern);
panel_pattern.data = Make_pattern_vector(panel_pattern);

mainDir = 'C:\Users\fisherlab\Documents\GitHub\';
subDir = 'panels-patternsAndFunctions_behaviorRig\patterns\';
str = [mainDir subDir SAVE_NAME];
save(str, 'panel_pattern');
