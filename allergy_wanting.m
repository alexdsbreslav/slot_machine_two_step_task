function allergy_wanting(initialization_struct)

  % some setups
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
FlushEvents;
%HideCursor; %ALTERED FOR DEBUGGING
PsychDefaultSetup(1);

results_file_name = [initialization_struct.data_file_path '/allergy_wanting'];

Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
FlushEvents;

% open window
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
% [exp_screen, ~] = Screen('OpenWindow', max(Screen('Screens')));
[exp_screen, ~] = Screen('OpenWindow', max(Screen('Screens')), [], [0 0 1200 800]); % for opening into a small rectangle instead
[data.width, data.height] = Screen('WindowSize',exp_screen);
data.screenRefreshRate = Screen('GetFlipInterval', exp_screen);

Screen('TextFont',exp_screen,'Arial');

% style settings
wrapat = 53;
vSpacing = 3;
bg_color = BlackIndex(exp_screen);
txt_color = WhiteIndex(exp_screen);
chosen_color= [0 220 0];
txt_size.fixCross = 60;
txt_size.blockTxt = 30;
txt_size.rateFoodName = 33;
txt_size.rateGuide = 22;
txt_size.binaryFoodName = 30;
txt_size.statusLabels = 32;

% response key set up
KbName('UnifyKeyNames');
exitKeys = KbName({'e', 'E'});
rightKey = KbName('rightarrow');
leftKey = KbName('leftarrow');
spaceKey = KbName('space');
startFirstKeys = KbName({'b', 'B'});

%ratings: set up task

% retrieve image names from directory
tmp = dir('food_images/*.bmp');
data.image_names = {tmp(1:length(tmp)).name}';
tmp = dir('food_images/*.jpg');
data.image_names = [data.image_names; {tmp(1:length(tmp)).name}'];

data.nTrials = length(data.image_names);

% randomize order of foods and order of ratings
data.ind = randperm(length(data.image_names))'; % food presentation order

% timing
data.feedbackSecs = .2; % feedback duration

% ITI
tmp = repmat([.2 .3 .4 .5], 1, ceil(data.nTrials/4))';
tmp = tmp(1:data.nTrials);
data.reset_screen = sortrows([rand(data.nTrials,1), tmp]);
data.reset_screen = data.reset_screen(:,2);

% location of text keyboard guide:
data.guideLocs = linspace(.15,.96,6) * data.width;
data.yesno_guideLocs = {data.guideLocs(2), data.guideLocs(4)};

% response key guides
data.resp_keys = {'c' 'v' 'b' 'n' 'm'};
data.yesno_resp_keys = {'c', 'm'};
data.resp_key_codes = KbName(data.resp_keys);
data.yesno_resp_key_codes = KbName(data.yesno_resp_keys);
data.keyguide = 'cvbnm'; % set key labels
data.yesno_keyguide = {'Press c', 'Press m'};
data.guide = {'I really do no want to eat it right now', 'I do not want to eat it right now', 'I do not know', 'I want to eat it right now', 'I really want to eat it right now'};
data.yesno_guide = {'Yes', 'No'};
data.guideTwo = {'I really do not\nwant to eat\nit right now', 'I do not want to\neat it right now', 'I do not know', 'I want to eat\nit right now', 'I really want to\neat it right now'};
data.choicevalence_guide = repmat(-2:2,1,1);
data.yesnovalence_guide = {1,0};


% randomly set the left-right scale direction on a participant-by-participant basis
data.scaleFlip = randi(2)-1; % 1=flip it, 0=don't
% flip scale if necessary
if data.scaleFlip
    data.guide = fliplr(data.guide);
    data.guideTwo = fliplr(data.guideTwo);
    data.choicevalence_guide = fliplr(data.choicevalence_guide);
end

% preallocate
data.anyfoodallergies = cell(1,1); % yes or no, have ANY food allergies
data.allergic = cell(data.nTrials,1); % if yes, ask about specific foods
data.choice = cell(data.nTrials, 1); % letter pressed
data.choicetxt = cell(data.nTrials, 1); % text of response
data.choicevalence = NaN(data.nTrials, 1); % number of response
data.RT = NaN(data.nTrials, 1); % RT
data.stimOn = NaN(data.nTrials, 1); % time stamp
data.RT = NaN(data.nTrials, 1); % time stamp
data.feedbackOn = NaN(data.nTrials, 1); % time stamp

tic;
count=1;
% intro
Screen('TextSize', exp_screen, txt_size.blockTxt);
Screen(exp_screen, 'FillRect', bg_color);
DrawFormattedText(exp_screen,[
    'The purpose of this section is to ensure that you can complete the' '\n'...
    'Strategy Game for Food and Money study.' '\n\n' ...
    'We will ask you a few questions about ten foods.' '\n\n' ...
    'Press any key to continue.' ...
    ], 'center', 'center' ,txt_color,[],[],[],1.6);
Screen('Flip', exp_screen);
KbWait([], 2)

%% Any food allergies?

DrawFormattedText(exp_screen,[
    'During the study, we will ask you to eat certain foods.' '\n\n' ...
    'Do you have any known food allergies?' ...
    ], 'center', 'center',txt_color,[],[],[],1.6);

Screen('TextSize', exp_screen, txt_size.blockTxt);
for n = 1:2
    DrawFormattedText(exp_screen,data.yesno_keyguide{n},...
        data.yesno_guideLocs{n},data.height*.8,txt_color,wrapat,[],[],vSpacing);
    DrawFormattedText(exp_screen,char(data.yesno_guide(n)),...
        data.yesno_guideLocs{n}+25,data.height*.75,txt_color,wrapat,[],[],1);
end

Screen('Flip', exp_screen);
WaitSecs(.5) %force .5 sesconds on the screen so people wont hold down the key


% listen for response
while 1
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && any(keyCode(data.yesno_resp_key_codes)) && length(KbName(keyCode)) == 1

        data.allergies_keyCode = KbName(keyCode); % letter code

        data.allergies_text = data.yesno_guide{data.allergies_keyCode ...
            ==cell2mat(data.yesno_resp_keys)}; % string

        data.anyfoodallergies = data.yesnovalence_guide{data.allergies_keyCode ...
            ==cell2mat(data.yesno_resp_keys)}; % number code

        break
    elseif keyIsDown && any(keyCode(exitKeys)) && length(KbName(keyCode)) == 1
        sca; return;
    end
end
save(results_file_name,'data');

% --- show their response
% show the image:
Screen(exp_screen, 'FillRect', bg_color);

% show ratings scale
Screen('TextSize', exp_screen, txt_size.blockTxt);
for n = 1:2
    if strcmp(data.allergies_text, char(data.yesno_guide{n}))
        DrawFormattedText(exp_screen,data.yesno_keyguide{n},...
            data.yesno_guideLocs{n},data.height*.8,chosen_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(data.yesno_guide(n)),...
            data.yesno_guideLocs{n}+25,data.height*.75,chosen_color,wrapat,[],[],1);
    else
        DrawFormattedText(exp_screen,data.yesno_keyguide{n},...
            data.yesno_guideLocs{n},data.height*.8,txt_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(data.yesno_guide(n)),...
            data.yesno_guideLocs{n}+25,data.height*.75,txt_color,wrapat,[],[],1);
    end
end
Screen('Flip', exp_screen);
Screen('Close');
WaitSecs(data.feedbackSecs);

%% Wanting ratings

% show ratings instructions & key guide
Screen('TextSize', exp_screen, txt_size.blockTxt);
Screen(exp_screen, 'FillRect', bg_color);
DrawFormattedText(exp_screen,['Please rate the following foods ' '\n' ...
    'based on how much you want to eat them right now, using the keys and the scale below.'],...
    'center',data.height*.2,txt_color,wrapat,[],[],1.6);

Screen('TextSize', exp_screen, txt_size.rateGuide);
for n = 1:length(data.keyguide)
    DrawFormattedText(exp_screen,data.keyguide(n),...
        data.guideLocs(n),data.height*.5,txt_color,wrapat,[],[],vSpacing);
    DrawFormattedText(exp_screen,char(data.guideTwo(n)),data.guideLocs(n)-60,data.height*.58,txt_color,wrapat,[],[],1);
end

Screen('TextSize', exp_screen, txt_size.blockTxt);
DrawFormattedText(exp_screen,'Press the spacebar to begin!',...
    'center', data.height*.8, txt_color, wrapat, [], [], vSpacing);
Screen(exp_screen, 'Flip');
WaitSecs(.2); KbEventFlush;
% wait for spacebar to begin
while 1
    [keyIsDown, ~, keyCode] = KbCheck;
    if keyIsDown && keyCode(spaceKey)
        break
    elseif any(keyCode(exitKeys))
        sca; return
    end
end
%%

for trial = data.ind' % run trials in the pre-determined randomized order

    % display stimuli
    % get the food image
    imgfile = imread(['food_images/' data.image_names{trial}]);
    img = Screen(exp_screen, 'MakeTexture', imgfile);
    % show the image
    Screen(exp_screen, 'FillRect', bg_color);
    Screen('DrawTexture', exp_screen, img, [], ...
        [data.width*.5-200 data.height*.5-200 ...
        data.width*.5+200 data.height*.5+200]);
    % show ratings scale
    Screen('TextSize', exp_screen, txt_size.rateGuide);
    for n = 1:length(data.keyguide)
        DrawFormattedText(exp_screen,data.keyguide(n),...
            data.guideLocs(n),data.height*.8,txt_color,wrapat,[],[],vSpacing);
        DrawFormattedText(exp_screen,char(data.guideTwo(n)),...
            data.guideLocs(n)-60,data.height*.88,txt_color,wrapat,[],[],1);
    end
    Screen('Flip', exp_screen);
    data.stimOn(trial) = GetSecs;

    WaitSecs(.5) %force .5 sesconds on the screen so people wont hold down the key

    % listen for response
    while 1
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && any(keyCode(data.resp_key_codes)) && length(KbName(keyCode)) == 1

            data.RT(trial) = GetSecs;
            data.RT(trial) = data.RT(trial) ...
                - data.stimOn(trial);

            data.choice{trial} = KbName(keyCode); % letter code

            data.choicetxt{trial} = data.guide{data.choice{trial} ...
                ==cell2mat(data.resp_keys)}; % string

            data.choicevalence(trial) = ... % -2 to 2
                data.choicevalence_guide(data.choice{trial} == ...
                cell2mat(data.resp_keys));

            break
        elseif keyIsDown && any(keyCode(exitKeys)) && length(KbName(keyCode)) == 1
            sca; return;
        end
    end
    save(results_file_name,'data');

    % --- show their response
    % show the image:
    Screen(exp_screen, 'FillRect', bg_color);
    Screen('DrawTexture', exp_screen, img, [], ...
        [data.width*.5-200 data.height*.5-200 ...
        data.width*.5+200 data.height*.5+200]);
    % show ratings scale
    Screen('TextSize', exp_screen, txt_size.rateGuide);
    for n = 1:length(data.keyguide)
        if strcmp(data.choicetxt{trial}, char(data.guide{n}))
            DrawFormattedText(exp_screen,data.keyguide(n),...
                data.guideLocs(n),data.height*.8,chosen_color,wrapat,[],[],vSpacing);
            DrawFormattedText(exp_screen,char(data.guideTwo(n)),...
                data.guideLocs(n)-60,data.height*.88,chosen_color,wrapat,[],[],1);
        else
            DrawFormattedText(exp_screen,data.keyguide(n),...
                data.guideLocs(n),data.height*.8,txt_color,wrapat,[],[],vSpacing);
            DrawFormattedText(exp_screen,char(data.guideTwo(n)),...
                data.guideLocs(n)-60,data.height*.88,txt_color,wrapat,[],[],1);
        end
    end
    Screen('Flip', exp_screen);
    data.feedbackOn(trial) = GetSecs;
    Screen('Close', img);
    WaitSecs(data.feedbackSecs);
    %imwrite(Screen('GetImage', exp_screen), sprintf('%d_%d.png',nB,trial))

end


count=count+1;
data.taskDur(2) = toc;

Screen('CloseAll');
FlushEvents;
end
