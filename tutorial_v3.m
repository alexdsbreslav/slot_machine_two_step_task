function tutorial_v3

% The tutorial for this task was initially developed for Daw et al. (2011) Neuron and
% used for other implementations of the task such as Konovalov (2016) Nature Communications.
% The original code was shared with me and I have maintained some of the basic structure
% and notation; however, I have substantially altered the tutorial and underlying code
% for my own purposes.

% Please do not share or use this code without my written permission.
% Author: Alex Stine

%clear all

Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
FlushEvents;

PsychDefaultSetup(1);
Screen('CloseAll');
Screen('Close');

%HideCursor; ALTERED FOR DEBUGGING

global rect sub stim_color_step1 ...
stim_colors_step2 stim_step2_color_select ...
stim_prac_symbol stim_symbol

% Need to define the color name
if strcmp(char(stim_color_step1(1)), 'dark_grey') == 1
    step1_color = 'dark grey';
elseif strcmp(char(stim_color_step1(1)), 'white') == 1
    step1_color = 'white';
else
    step1_color = 'grey';
end

if strcmp(char(stim_step2_color_select(1)), 'warm') == 1
    if strcmp(char(stim_colors_step2(1)), 'red_blue') == 1
        state2_color = 'red';
        state3_color = 'blue';
        a_an_2 = 'a ';
        a_an_3 = 'a ';
    elseif strcmp(char(stim_colors_step2(1)), 'orange_purple') == 1
        state2_color = 'orange';
        state3_color = 'purple';
        a_an_2 = 'an ';
        a_an_3 = 'a ';
    else
        state2_color = 'yellow';
        state3_color = 'green';
        a_an_2 = 'a ';
        a_an_3 = 'a ';
    end
else
    if strcmp(char(stim_colors_step2(1)), 'red_blue') == 1
        state2_color = 'blue';
        state3_color = 'red';
        a_an_2 = 'a '; % enables me to refer to the tokens with the proper pronouns
        a_an_3 = 'a ';
    elseif strcmp(char(stim_colors_step2(1)), 'orange_purple') == 1
        state2_color = 'purple';
        state3_color = 'orange';
        a_an_2 = 'a ';
        a_an_3 = 'an ';
    else
        state2_color = 'green';
        state3_color = 'yellow';
        a_an_2 = 'a ';
        a_an_3 = 'a ';
    end
end

doublebuffer=1;
screens = Screen('Screens'); %count the screen
whichScreen = max(screens); %select the screen ALTERED FOR DEBUGGING
[w,rect] = Screen('OpenWindow', whichScreen, 0,[], 32, ...
        doublebuffer+1,[],[],kPsychNeedFastBackingStore);

r = [0,0,400,290]; %stimuli rectangle
rc = [0,0,420,310]; %choice rectangle
slot_r = [0,0,600,480]; % slot rectangle
room_r = [0,0,620*.9,500*.9]; % room rectangle
r_spenttoken = [0,0,400*.4, 290*.4];
r_coinslot = [0,0,400*.8, 290*.8];

% Original stimuli locations
Lpoint = CenterRectOnPoint(r, rect(3)*.25, rect(4)*0.3); %drawingpoints on screen
L1point = CenterRectOnPoint(r, rect(3)*.25, rect(4)*0.2);
L2point = CenterRectOnPoint(r, rect(3)*.25, rect(4)*0.5);
Rpoint = CenterRectOnPoint(r, rect(3)*.75, rect(4)*0.3);
R1point = CenterRectOnPoint(r, rect(3)*.75, rect(4)*0.2);
R2point = CenterRectOnPoint(r, rect(3)*.75, rect(4)*0.5);
Upoint = CenterRectOnPoint(r, rect(3)*.5, rect(4)*0.3);
Mpoint = CenterRectOnPoint(r, rect(3)*.5, rect(4)*0.5);

% stimli in slot locations
slot_label_Upoint = CenterRectOnPoint(r, rect(3)*0.5, rect(4)*0.4);
slot_label_Lpoint = CenterRectOnPoint(r, rect(3)*0.2, rect(4)*0.4);
slot_label_Rpoint = CenterRectOnPoint(r, rect(3)*0.8, rect(4)*0.4);
spent_token_Mpoint = CenterRectOnPoint(r_spenttoken, rect(3)*0.5, rect(4)*0.8);

%frames - white during every trial; green when chosen
Lchoice = CenterRectOnPoint(rc, rect(3)/4, rect(4)*0.3); %drawingpoints on screen
Rchoice = CenterRectOnPoint(rc, 3*rect(3)/4, rect(4)*0.3);
Uchoice = CenterRectOnPoint(rc, rect(3)/2, rect(4)*0.3);
L1frame = CenterRectOnPoint(rc, rect(3)/4, rect(4)*0.2);
L2frame = CenterRectOnPoint(rc, rect(3)/4, rect(4)*0.5);
R1frame = CenterRectOnPoint(rc, 3*rect(3)/4, rect(4)*0.2);
R2frame = CenterRectOnPoint(rc, 3*rect(3)/4, rect(4)*0.5);
Mframe = CenterRectOnPoint(rc, rect(3)/2, rect(4)*0.5);
slot_label_Uframe = CenterRectOnPoint(rc, rect(3)*0.5, rect(4)*0.4);
slot_label_Lframe = CenterRectOnPoint(rc, rect(3)*0.2, rect(4)*0.4);
slot_label_Rframe = CenterRectOnPoint(rc, rect(3)*0.8, rect(4)*0.4);

% slot machine locations
slot_Upoint = CenterRectOnPoint(slot_r, rect(3)*0.5, rect(4)*0.375);
slot_Lpoint = CenterRectOnPoint(slot_r, rect(3)*0.2, rect(4)*0.375);
slot_Rpoint = CenterRectOnPoint(slot_r, rect(3)*0.8, rect(4)*0.375);

% coin slot locations
coinslot_Lpoint = CenterRectOnPoint(r_coinslot, rect(3)*0.2, rect(4)*0.8);
coinslot_Rpoint = CenterRectOnPoint(r_coinslot, rect(3)*0.8, rect(4)*0.8);

% room locations
room_Upoint = CenterRectOnPoint(room_r, rect(3)*.5, rect(4)*0.3);
room_Lpoint = CenterRectOnPoint(room_r, rect(3)*.25, rect(4)*0.3);
room_Rpoint = CenterRectOnPoint(room_r, 3*rect(3)*.25, rect(4)*0.3);

%basic stimuli
A1 = imread(['stimuli/practice/' char(stim_color_step1(1)) '/' ...
  char(stim_prac_symbol(1)) '.png'],'png');
B1 = imread(['stimuli/practice/' char(stim_color_step1(1)) '/' ...
  char(stim_prac_symbol(2)) '.png'],'png');

A2 = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/' ...
  char(stim_prac_symbol(3)) '.png'],'png');
B2 = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/' ...
  char(stim_prac_symbol(4)) '.png'],'png');

A3 = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/' ...
  char(stim_prac_symbol(5)) '.png'],'png');
B3 = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/' ...
  char(stim_prac_symbol(6)) '.png'],'png');

% tokens
state2_token = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/' ...
   'token.png'],'png');
state3_token = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/' ...
  'token.png'],'png');
spent_token = imread(['stimuli/practice/spent token.png'],'png');

% token bags
A1_blank_token_bag = imread(['stimuli/practice/blank token bags/' char(stim_prac_symbol(1)) '.png'],'png');
B1_blank_token_bag = imread(['stimuli/practice/blank token bags/' char(stim_prac_symbol(2)) '.png'],'png');

A1_S2_token_bag = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/' ...
  char(stim_prac_symbol(1)) '_token bag.png'],'png');
A1_S3_token_bag = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/' ...
  char(stim_prac_symbol(1)) '_token bag.png'],'png');
B1_S2_token_bag = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/' ...
  char(stim_prac_symbol(2)) '_token bag.png'],'png');
B1_S3_token_bag = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/' ...
  char(stim_prac_symbol(2)) '_token bag.png'],'png');

%win/lose token bags
win_lose_anim = struct;
for i=1:4
  tmp_dir = dir(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(ceil(i/2))) '/win/' ...
  char(stim_prac_symbol(i+2)) '*.png']);

  for f=1:3
    file{f} = strcat(tmp_dir(f).folder,'/',tmp_dir(f).name);
  end

  for f=1:3
    img{f} = imread(file{f});
  end

  win_lose_anim.win{i} = img;

  tmp_dir = dir(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(ceil(i/2))) '/lose/' ...
  char(stim_prac_symbol(i+2)) '*.png']);

  for f=1:3
    file{f} = strcat(tmp_dir(f).folder,'/',tmp_dir(f).name);
  end

  for f=1:3
    img{f} = imread(file{f});
  end

  win_lose_anim.lose{i} = img;
end

A2_win = win_lose_anim.win{1};
B2_win = win_lose_anim.win{2};
A3_win = win_lose_anim.win{3};
B3_win = win_lose_anim.win{4};
A2_lose = win_lose_anim.lose{1};
B2_lose = win_lose_anim.lose{2};
A3_lose = win_lose_anim.lose{3};
B3_lose = win_lose_anim.lose{4};

% slot machines
step1_slot_L = imread(['stimuli/practice/' char(stim_color_step1(1)) '/Slot Machine_L.png'],'png');
state2_slot_L = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/Slot Machine_L.png'],'png');
state3_slot_L = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/Slot Machine_L.png'],'png');

step1_slot_R = imread(['stimuli/practice/' char(stim_color_step1(1)) '/Slot Machine_R.png'],'png');
state2_slot_R = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/Slot Machine_R.png'],'png');
state3_slot_R = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/Slot Machine_R.png'],'png');

% coin slots
state2_coin_slot = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/coin slot.png'],'png');
state3_coin_slot = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/coin slot.png'],'png');

% rooms
token_room = imread(['stimuli/practice/' char(stim_color_step1(1)) '/token room.png'],'png');
prize_room = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/prize room.png'],'png');

% win/lose
win = imread(['stimuli/practice/win_lose/win.png'],'png');
win1 = imread(['stimuli/practice/win_lose/win1.png'],'png');
win2 = imread(['stimuli/practice/win_lose/win2.png'],'png');
win3 = imread(['stimuli/practice/win_lose/win3.png'],'png');
lose = imread(['stimuli/practice/win_lose/lose.png'],'png');
lose1 = imread(['stimuli/practice/win_lose/lose1.png'],'png');
lose2 = imread(['stimuli/practice/win_lose/lose2.png'],'png');
lose3 = imread(['stimuli/practice/win_lose/lose3.png'],'png');

% original stimuli
A1 = Screen('MakeTexture', w, A1);
B1 = Screen('MakeTexture', w, B1);
A2 = Screen('MakeTexture', w, A2);
B2 = Screen('MakeTexture', w, B2);
A3 = Screen('MakeTexture', w, A3);
B3 = Screen('MakeTexture', w, B3);

% tokens
state2_token = Screen('MakeTexture', w, state2_token);
state3_token = Screen('MakeTexture', w, state3_token);
spent_token = Screen('MakeTexture', w, spent_token);

% token bag
A1_blank_token_bag = Screen('MakeTexture', w, A1_blank_token_bag);
B1_blank_token_bag = Screen('MakeTexture', w, B1_blank_token_bag);
A1_S2_token_bag = Screen('MakeTexture', w, A1_S2_token_bag);
A1_S3_token_bag = Screen('MakeTexture', w, A1_S3_token_bag);
B1_S2_token_bag = Screen('MakeTexture', w, B1_S2_token_bag);
B1_S3_token_bag = Screen('MakeTexture', w, B1_S3_token_bag);

% slot machines
step1_slot_L = Screen('MakeTexture', w, step1_slot_L);
state2_slot_L = Screen('MakeTexture', w, state2_slot_L);
state3_slot_L = Screen('MakeTexture', w, state3_slot_L);

step1_slot_R = Screen('MakeTexture', w, step1_slot_R);
state2_slot_R = Screen('MakeTexture', w, state2_slot_R);
state3_slot_R = Screen('MakeTexture', w, state3_slot_R);

% coin slots
state2_coin_slot = Screen('MakeTexture', w, state2_coin_slot);
state3_coin_slot = Screen('MakeTexture', w, state3_coin_slot);

% rooms
token_room = Screen('MakeTexture', w, token_room);
prize_room = Screen('MakeTexture', w, prize_room);

% win/lose
win = Screen('MakeTexture', w, win);
win1 = Screen('MakeTexture', w, win1);
win2 = Screen('MakeTexture', w, win2);
win3 = Screen('MakeTexture', w, win3);
lose = Screen('MakeTexture', w, lose);
lose1 = Screen('MakeTexture', w, lose1);
lose2 = Screen('MakeTexture', w, lose2);
lose3 = Screen('MakeTexture', w, lose3);

% Keyboard
KbName('UnifyKeyNames');
L = KbName('LeftArrow');
R = KbName('RightArrow');

white = [255 255 255];
black = [0 0 0];
green = [0 220 0];

Screen('FillRect', w, [0 0 0]);
Screen('TextSize', w, 40);
Screen('TextColor',w,[255 255 255]);
Screen('TextFont',w,'Helvetica');

% % screen 1
% DrawFormattedText(w,[
%     'Please read the instructions carefully.' '\n\n' ...
%     'You will not be able to return to the previous screens.' '\n\n' ...
%     'Press any key to continue on to the next page.' ...
%     ], 'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 2
% DrawFormattedText(w,[
%     'This is part one of the study.' '\n\n' ...
%     'This tutorial teaches you the rules of the strategy game.' ...
%     ], 'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 3
% DrawFormattedText(w,[
%     'If you have any questions, at any point,' '\n' ...
%     'please do not hesitate to ask the experimenter.' '\n\n' ...
%     'Press any key to start the tutorial.' ...
%     ],'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);

% screen 4
Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
Screen('FrameRect',w,white,slot_label_Uframe,10);
DrawFormattedText(w,[
    'In this strategy game, there are six slot machines' ...
    ],'center', rect(4)*0.75, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% % screen 5
% Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
% Screen('FrameRect',w,white,slot_label_Uframe,10);
% DrawFormattedText(w,[
%     'During the game, you''ll play these slot' '\n' ...
%     'machines many times to try to win prizes.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 6
% Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
% Screen('FrameRect',w,white,slot_label_Uframe,10);
% DrawFormattedText(w,[
%     'The goal of the game is to find the best slot machine.' '\n' ...
%     'The best slot machine is the one that wins the most!' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 7
% Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
% Screen('FrameRect',w,white,slot_label_Uframe,10);
% DrawFormattedText(w,[
%     'To win prizes in this strategy game, you''ll need to pay close' '\n' ...
%     'attention. The slot machines are set up in a special way.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% screen 8
Screen('DrawTexture', w, token_room, [], room_Lpoint);
Screen('DrawTexture', w, prize_room, [], room_Rpoint);
DrawFormattedText(w,[
     'The six slot machines are split up into two rooms.' ...
     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);
%
% % screen 9.1
% Screen('DrawTexture', w, token_room, [], room_Upoint);
% DrawFormattedText(w,[
%     'In the TOKEN ROOM,' '\n' ...
%     'there are TWO SLOT MACHINES...' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);

% % screen 9.2
% Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'These slot machines are ' step1_color '.'...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);

% % screen 10.1
% Screen('DrawTexture', w, prize_room, [], room_Upoint);
% DrawFormattedText(w,[
%     'In the PRIZE ROOM,' '\n' ...
%     'there are FOUR SLOT MACHINES...' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 10.2
% Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'Two of these slot' '\n' ...
%     'machines are ' state2_color '...' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 10.3
% Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B3, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'and two slot machines are ' state3_color '.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 11.1
% Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'Each slot machine is labeled by its color and symbol.' '\n' ...
%     'Let''s look at the slots in each room again.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 11.2
% Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
% Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'The TOKEN ROOM has:' '\n' ...
%     'Two ' step1_color ' slot machines, with two different symbols'
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 11.3
% Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
% Screen('DrawTexture', w, A3, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'The PRIZE ROOM has:' '\n' ...
%     'Two ' state3_color ' slot machines, with two different symbols, and...'
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 11.4
% Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
% Screen('DrawTexture', w, A2, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'two ' state2_color ' slot machines, with two more different symbols.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 12.1
% Screen('DrawTexture', w, token_room, [], room_Upoint);
% DrawFormattedText(w,[
%     'You will start each round in the TOKEN ROOM...' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 12.2
% Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'In the TOKEN ROOM, you will choose to play' '\n' ...
%     'one of the two slot machines.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 13.1
% Screen('DrawTexture', w, state2_token, [], Lpoint);
% Screen('DrawTexture', w, state3_token, [], Rpoint);
% DrawFormattedText(w,[
%     'Every time you play a slot machine in the TOKEN ROOM,' '\n' ...
%     'you will win ' a_an_2 state2_color ' token' ' or ' a_an_3 state3_color ' token...'
%     ],'center',rect(4)*0.6, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 13.2
% Screen('DrawTexture', w, state2_token, [], Lpoint);
% Screen('DrawTexture', w, state3_token, [], Rpoint);
% DrawFormattedText(w,[
%     'If you win ' a_an_2 state2_color ' token, you''ll get one chance to play' '\n' ...
%     a_an_2 state2_color ' slot machine in the PRIZE ROOM...'
%     ],'center',rect(4)*0.6, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 13.3
% Screen('DrawTexture', w, state2_token, [], Lpoint);
% Screen('DrawTexture', w, state3_token, [], Rpoint);
% DrawFormattedText(w,[
%     'If you win ' a_an_3 state3_color ' token, you''ll get one chance to play' '\n' ...
%      a_an_3 state3_color ' slot machine in the PRIZE ROOM.'
%     ],'center',rect(4)*0.6, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 14.1
% Screen('DrawTexture', w, state2_token, [], Upoint);
% DrawFormattedText(w,[
%     'Let''s pretend that you won ' a_an_2 state2_color ' token...' ...
%     ],'center',rect(4)*0.6, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 14.2
% Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'so we will take you to the ' state2_color '\n' ...
%     'slot machines in the PRIZE ROOM.'
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 15
% Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'As the name suggests, you can win prizes at' '\n' ...
%     'all of the slot machines in the PRIZE ROOM!' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 16
% Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
% Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
% Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
% Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
% Screen('FrameRect',w,white,slot_label_Lframe,10);
% Screen('FrameRect',w,white,slot_label_Rframe,10);
% DrawFormattedText(w,[
%     'In the PRIZE ROOM, you will choose to play one of the' '\n' ...
%     'slot machines that matches the color of your token.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);

% screen 17
DrawFormattedText(w,[
    'Let''s walk through a round together to' '\n' ...
    'get the hang of it.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% screen 18
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'To choose the slot machine on the left, click the left arrow.' '\n' ...
    'To choose the slot machine on the right, click the right arrow.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Wait for the selection of either the left or right box
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
 while key_code(L) == 0 && key_code(R) == 0
         [key_is_down, secs, key_code] = KbCheck;
 end
down_key = find(key_code,1);

if down_key == L
      Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
      Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
      Screen('FrameRect',w,green,slot_label_Lframe,10);
      Screen('FrameRect',w,white,slot_label_Rframe,10);
      Screen('Flip',w);
      WaitSecs(1);
elseif down_key == R
      Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
      Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
      Screen('FrameRect',w,white,slot_label_Lframe,10);
      Screen('FrameRect',w,green,slot_label_Rframe,10);
      Screen('Flip',w);
      WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
end

% payoff screen
Screen('DrawTexture', w, state2_token, [], Mpoint);
Screen('Flip',w);
WaitSecs(1);

% payoff explanation
Screen('DrawTexture', w, state2_token, [], Mpoint);
DrawFormattedText(w,[
'You won ' a_an_2 state2_color ' token, so we will take you ' '\n' ...
'to the ' state2_color ' slot machines in the PRIZE ROOM.' '\n\n' ...
'Press any key to continue.' ...
],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2)

% % screen 19.1
% Screen(w, 'FillRect', black);
% Screen('TextSize', w, 60);
% DrawFormattedText(w, '+', 'center', 'center', white);
% Screen('TextSize', w, 40);
% DrawFormattedText(w,[
%     'Before you enter each room, this symbol will show' '\n' ...
%     'up in the middle of the screen...' ...
%     ],'center',rect(4)*0.6, [], [], [], [], 1.6);
% Screen(w, 'Flip');
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % screen 19.2
% Screen(w, 'FillRect', black);
% Screen('TextSize', w, 60);
% DrawFormattedText(w, '+', 'center', 'center', white);
% Screen('TextSize', w, 40);
% DrawFormattedText(w,[
%     'Each time this shows up, focus on that middle point.' '\n'...
%     'Your focus is very important for the eyetracker!'
%     ],'center',rect(4)*0.6, [], [], [], [], 1.6);
% Screen(w, 'Flip');
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);

% screen 20
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('DrawTexture', w, state2_token, [], spent_token_Mpoint);
Screen('Flip',w);
KbWait([],2);

% Wait for the selection of either the left or right box
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
 while key_code(L) == 0 && key_code(R) == 0
         [key_is_down, secs, key_code] = KbCheck;
 end
down_key = find(key_code,1);

if down_key == L
      Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
      Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
      Screen('FrameRect',w,green,slot_label_Lframe,10);
      Screen('FrameRect',w,white,slot_label_Rframe,10);
      Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
      Screen('DrawTexture', w, state2_coin_slot, [], coinslot_Lpoint);
      Screen('Flip',w);
      WaitSecs(1);

      % payoff explanation
      Screen('DrawTexture', w, A2, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Win!' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)

elseif down_key == R
      Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
      Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
      Screen('FrameRect',w,white,slot_label_Lframe,10);
      Screen('FrameRect',w,green,slot_label_Rframe,10);
      Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
      Screen('DrawTexture', w, state2_coin_slot, [], coinslot_Rpoint);
      Screen('Flip',w);
      WaitSecs(1) %force respondents to spend at least 1 seconds on each screen

      % payoff explanation
      Screen('DrawTexture', w, B2, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Win!' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)
end

% % screen 21.1
% DrawFormattedText(w,[
%     'Let''s try playing another round.' ...
%     ],'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% screen 21.2
DrawFormattedText(w,[
    'To speed things up, we will not show you the' '\n' ...
    'color of the token that you won. We will just take' '\n' ...
    'you to the correct slot machines in the PRIZE ROOM.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% screen 22
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
Screen(w, 'Flip');
WaitSecs(.5)

% screen 23
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);

Screen('Flip',w);
KbWait([],2);

% Wait for the selection of either the left or right box
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
 while key_code(L) == 0 && key_code(R) == 0
         [key_is_down, secs, key_code] = KbCheck;
 end
down_key = find(key_code,1);

if down_key == L
      Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
      Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
      Screen('FrameRect',w,green,slot_label_Lframe,10);
      Screen('FrameRect',w,white,slot_label_Rframe,10);
      Screen('Flip',w);
      WaitSecs(1)

elseif down_key == R
      Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
      Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
      Screen('FrameRect',w,white,slot_label_Lframe,10);
      Screen('FrameRect',w,green,slot_label_Rframe,10);
      Screen('Flip',w);
      WaitSecs(1)
end

% screen 24
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
Screen(w, 'Flip');
WaitSecs(.5)

% screen 25
Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('DrawTexture', w, A3, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('DrawTexture', w, state3_token, [], spent_token_Mpoint);
Screen('Flip',w);
KbWait([],2);

% Wait for the selection of either the left or right box
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
 while key_code(L) == 0 && key_code(R) == 0
         [key_is_down, secs, key_code] = KbCheck;
 end
down_key = find(key_code,1);

if down_key == L
      Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
      Screen('DrawTexture', w, A3, [], slot_label_Rpoint);
      Screen('FrameRect',w,green,slot_label_Lframe,10);
      Screen('FrameRect',w,white,slot_label_Rframe,10);
      Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
      Screen('DrawTexture', w, state3_coin_slot, [], coinslot_Lpoint);
      Screen('Flip',w);
      WaitSecs(1);

      % payoff explanation
      Screen('DrawTexture', w, B3, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Lose' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)

elseif down_key == R
      Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
      Screen('DrawTexture', w, A3, [], slot_label_Rpoint);
      Screen('FrameRect',w,white,slot_label_Lframe,10);
      Screen('FrameRect',w,green,slot_label_Rframe,10);
      Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
      Screen('DrawTexture', w, state3_coin_slot, [], coinslot_Rpoint);
      Screen('Flip',w);
      WaitSecs(1) %force respondents to spend at least 1 seconds on each screen

      % payoff explanation
      Screen('DrawTexture', w, A3, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Lose' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)
end

% % Screen 26
% DrawFormattedText(w,[
%     'Let''s pause for just a moment.' '\n\n' ...
%     'If you have any questions at all about the strategy game,' '\n' ...
%     'this is a great time to ask the experimenter.' '\n\n' ...
%     'Once the experimenter has answered all of your questions,' '\n' ...
%     'press any key to continue.' ...
%     ],'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % Screen 27
% DrawFormattedText(w,[
%     'In order for you to win the most,' '\n' ...
%     'you will need to know how we' '\n' ...
%     'programmed the slot machines.' ...
%     ],'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % Screen 28
% Screen('DrawTexture', w, token_room, [], room_Upoint);
% DrawFormattedText(w,[
%     'Let''s start in the TOKEN ROOM.' ...
%     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% Screen 29
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'The slot machines in the TOKEN ROOM' '\n' ...
    'were programmed in a simple way.' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 30.1.1
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);

DrawFormattedText(w,[
    'To best understand how they were programmed,' '\n' ...
    'imagine that we have four big token bags.' '\n' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 30.1.2
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_blank_token_bag, [], R1point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R2point);

DrawFormattedText(w,[
    'There are two bags for each slot machine...'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)

% Screen 30.1.3
Screen('DrawTexture', w, A1_blank_token_bag, [], L1point);
Screen('DrawTexture', w, A1_blank_token_bag, [], L2point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R1point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R2point);

DrawFormattedText(w,[
    'There are two bags for each slot machine...'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 30.2
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, A1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, A1_blank_token_bag, [], R2point);
DrawFormattedText(w,[
    'For the first slot machine, we filled the top bag with a' '\n' ...
    'large, random, number of ' state2_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 30.3
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, A1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, A1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And the bottom bag with a large,' '\n' ...
    'random, number of ' state3_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 30.4
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, A1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, A1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And then we dumped them in the slot machine!'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 31.1
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R2point);
DrawFormattedText(w,[
    'For the second slot machine, we filled the top bag with a' '\n' ...
    'large, random, number of ' state2_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 31.2
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, B1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And the bottom bag with a large,' '\n' ...
    'random, number of ' state3_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 31.3
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, B1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And then we dumped them into the slot machine!'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 30.4
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);

DrawFormattedText(w,[
    'This means that at each slot machine, you have' '\n' ...
    'a different, unknown, chance of winning each color token.'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 32.1
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);

DrawFormattedText(w,[
    'Each time you win a token, we''ll put it back' '\n' ...
    'in the slot machine that it came from...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 32.2
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);

DrawFormattedText(w,[
    'This means that your chance of winning' '\n' ...
    'each color token will not change.' '\n'...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 33
DrawFormattedText(w,[
    'Let''s pause for just a moment.' '\n\n' ...
    'If you have any questions about how the slot machines,' '\n' ...
    'in the TOKEN ROOM were programmed, this is a great time ' '\n' ...
    'to ask the experimenter. Once the experimenter has answered' '\n' ...
    'all of your questions, press any key to continue.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 34
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Let''s move to the PRIZE ROOM.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 35.1
i = 0;
for loop=1:9
  if i < 3
    i = i+1;
  else
    i = 1;
  end
  Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
  Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
  Screen('FrameRect',w,white,slot_label_Lframe,10);
  DrawFormattedText(w,[
      'For the first slot machine, imagine that we filled' '\n' ...
      'the top bag with a LARGE, random, number of wins...' ...
      ],'center',rect(4)*0.8, [], [], [], [], 1.6);
  img = Screen('MakeTexture', w, A2_win{i});
  Screen('DrawTexture', w, img, [], R1point);
  Screen('Flip', w);
  WaitSecs(0.4)
end
KbWait([],2)

% Screen 35.2
i = 0;
for loop=1:9
  if i < 3
    i = i+1;
  else
    i = 1;
  end
  Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
  Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
  Screen('FrameRect',w,white,slot_label_Lframe,10);
  DrawFormattedText(w,[
      'and the bottom bag with a,' '\n' ...
      'LARGE, random, number of losses...' ...
      ],'center',rect(4)*0.8, [], [], [], [], 1.6);
  img1 = Screen('MakeTexture', w, A2_win{3});
  Screen('DrawTexture', w, img1, [], R1point);
  img2 = Screen('MakeTexture', w, A2_lose{i});
  Screen('DrawTexture', w, img2, [], R2point);
  Screen('Flip',w);
  WaitSecs(0.4) %force respondents to spend at least 1 seconds on each screen
end
KbWait([],2)

% Screen 35.3
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
img1 = Screen('MakeTexture', w, A2_win{3});
Screen('DrawTexture', w, img1, [], R1point);
img2 = Screen('MakeTexture', w, A2_lose{3});
Screen('DrawTexture', w, img2, [], R2point);
DrawFormattedText(w,[
    'And then we dumped them into the slot machine!' '\n' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 35.4
Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
img1 = Screen('MakeTexture', w, A3_win{3});
Screen('DrawTexture', w, img1, [], R1point);
img2 = Screen('MakeTexture', w, A3_lose{3});
Screen('DrawTexture', w, img2, [], R2point);
DrawFormattedText(w,[
    'We then repeat this for the other three' '\n' ...
    'slot machines in the PRIZE ROOM...'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2)

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
img1 = Screen('MakeTexture', w, B2_win{3});
Screen('DrawTexture', w, img1, [], R1point);
img2 = Screen('MakeTexture', w, B2_lose{3});
Screen('DrawTexture', w, img2, [], R2point);
DrawFormattedText(w,[
    'We then repeat this for the other three' '\n' ...
    'slot machines in the PRIZE ROOM...'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)

Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
img1 = Screen('MakeTexture', w, B3_win{3});
Screen('DrawTexture', w, img1, [], R1point);
img2 = Screen('MakeTexture', w, B3_lose{3});
Screen('DrawTexture', w, img2, [], R2point);
DrawFormattedText(w,[
    'We then repeat this for the other three' '\n' ...
    'slot machines in the PRIZE ROOM...'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)

Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
img1 = Screen('MakeTexture', w, B3_win{3});
Screen('DrawTexture', w, img1, [], R1point);
img2 = Screen('MakeTexture', w, B3_lose{3});
Screen('DrawTexture', w, img2, [], R2point);
DrawFormattedText(w,[
    'Press any key to continue.'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('Flip',w);
KbWait([],2);

% Screen 36
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'This means that at each slot machine, you have' '\n' ...
    'a different, unknown, chance of winning.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 37
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'So far, everything in the TOKEN ROOM and the PRIZE' '\n' ...
    'ROOM has been the same; however, there is a key' '\n' ...
    'difference between the two rooms.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 38
Screen('DrawTexture', w, token_room, [], room_Upoint);
DrawFormattedText(w,[
    'Remember: in the TOKEN ROOM your chance of' '\n' ...
    'winning each color token will not change.' '\n'...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 39
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'In the PRIZE ROOM your chance of winning' '\n' ...
    'at any one slot machine, WILL CHANGE!' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 40
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Each time you spin any slot machine in the' '\n' ...
    'PRIZE ROOM, we will put a SMALL, random, number of' '\n' ...
    'wins and losses in ALL FOUR slot machines.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 41
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture',w,win1,[], R1point)
Screen('DrawTexture',w,lose3,[], R2point)
DrawFormattedText(w,[
    'Imagine that after your first spin, we put' '\n' ...
    'one win and three losses into this slot machine...' '\n' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture',w,win2,[], R1point)
Screen('DrawTexture',w,lose1,[], R2point)
DrawFormattedText(w,[
    'two wins and 1 loss into this slot machine...' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(0.5) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture',w,win2,[], R1point)
Screen('DrawTexture',w,lose2,[], R2point)
DrawFormattedText(w,[
    'two wins and two losses into this slot machine...' '\n' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(0.5) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);


Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture',w,win1,[], R1point)
Screen('DrawTexture',w,lose1,[], R2point)
DrawFormattedText(w,[
    'and one win and one loss into the last slot machine!'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(0.5) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture',w,win1,[], R1point)
Screen('DrawTexture',w,lose1,[], R2point)
DrawFormattedText(w,[
    'This means that your chances of winning at each slot machine' '\n' ...
    'are slightly different the next time you enter the PRIZE ROOM.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
KbWait([], 2)

% Screen 42
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, win, [], CenterRectOnPoint([0,0,533*.6,387*.6], 3*rect(3)/4, rect(4)*0.3));
Screen('DrawTexture', w, lose, [], CenterRectOnPoint([0,0,533*.4,387*.4], 3*rect(3)/4, rect(4)*0.5));
DrawFormattedText(w,[
    'Over the course of the game, the chance of' '\n' ...
    'winning at each slot machine will change SLOWLY.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

% Screen 43
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, win, [], CenterRectOnPoint([0,0,533*.6,387*.6], 3*rect(3)/4, rect(4)*0.3));
Screen('DrawTexture', w, lose, [], CenterRectOnPoint([0,0,533*.4,387*.4], 3*rect(3)/4, rect(4)*0.5));
DrawFormattedText(w,['Round: 1'], rect(3)*.7, rect(4)*0.2, [], [], [], [], 1.6);
DrawFormattedText(w,[
    'Here is an example. Watch how your chance of winning at this' '\n' ...
    'slot machine can slowly change over 75 rounds of the game.' '\n\n'...
    'Press any key to start.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);

trial_num = 1:75;
for trial = trial_num
    size_prob(1) = .6;
    size_prob(trial+1) = size_prob(trial) + 0.025*randn;
    if (size_prob(trial+1) < 0.25) || (size_prob(trial+1) > 0.75)
        size_prob(trial+1) = size_prob(trial);
    end

    Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
    Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
    Screen('FrameRect',w,white,slot_label_Lframe,10);

    Screen('DrawTexture', w, win, [], CenterRectOnPoint([0,0,533*size_prob(trial),387*size_prob(trial)], 3*rect(3)/4, rect(4)*0.3));
    Screen('DrawTexture', w, lose, [], CenterRectOnPoint([0,0,533*(1-size_prob(trial)),387*(1-size_prob(trial))], 3*rect(3)/4, rect(4)*0.5));
    DrawFormattedText(w,['Trial: ' num2str(trial_num(trial))], rect(3)*.7, rect(4)*0.2, [], [], [], [], 1.6);
    Screen('Flip',w);
    WaitSecs(.05)
end

% Screen 44
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);

Screen('DrawTexture', w, win, [], CenterRectOnPoint([0,0,533*size_prob(75),387*size_prob(75)], 3*rect(3)/4, rect(4)*0.3));
Screen('DrawTexture', w, lose, [], CenterRectOnPoint([0,0,533*(1-size_prob(75)),387*(1-size_prob(75))], 3*rect(3)/4, rect(4)*0.5));
DrawFormattedText(w,['Trial: ' num2str(trial_num(75))], rect(3)*.7, rect(4)*0.2, [], [], [], [], 1.6);

DrawFormattedText(w,[
    'Now, halfway through the game, your chance' '\n' ...
    'of winning at this slot machine is very low.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
KbWait([],2);
%
% % Screen 45
% Screen('DrawTexture', w, prize_room, [], room_Upoint);
% DrawFormattedText(w,[
%     'This means that you will have to pay close attention to' '\n' ...
%     'figure out which slot machine in the PRIZE ROOM is the best!' ...
%     ],'center',rect(4)*0.7, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % Screen 46
% Screen('DrawTexture', w, prize_room, [], room_Upoint);
% DrawFormattedText(w,[
%     'During the game, which slot machine in' '\n' ...
%     'the PRIZE ROOM is the best may change!' ...
%     ],'center',rect(4)*0.7, [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % Screen 38.1
% DrawFormattedText(w,[
%     'Now we''ve gone over all of the rules and programming,' '\n' ...
%     'but there were a lot of things to keep track of!' '\n' ...
%     ],'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);
%
% % Screen 38.2
% DrawFormattedText(w,[
%     'If we explained anything poorly in our tutorial,' '\n' ...
%     'this is a great time to ask for clarification.' '\n\n' ...
%     'After all of your questions have been answered,' '\n' ...
%     'you will play 15 practice trials.'
%     ],'center','center', [], [], [], [], 1.6);
% Screen('Flip',w);
% WaitSecs(1) %force respondents to spend at least 1 seconds on each screen
% KbWait([],2);

ShowCursor; %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?
Screen('Close',w); %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?
Screen('Close'); %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?

%jheapcl; ALTERED FOR DEBUGGING

end
