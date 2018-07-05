function tutorial_v4

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
r_next_arrow = [0,0,150,108.75];

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

% next arrow location
next_arrow_loc = CenterRectOnPoint(r_next_arrow, rect(3)*0.9, rect(4)*0.9);

% read basic stimuli files
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

% read token files
state2_token = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/' ...
   'token.png'],'png');
state3_token = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/' ...
  'token.png'],'png');
spent_token = imread(['stimuli/practice/spent token.png'],'png');

% read token bag files
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

% read slot machine files
step1_slot_L = imread(['stimuli/practice/' char(stim_color_step1(1)) '/Slot Machine_L.png'],'png');
state2_slot_L = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/Slot Machine_L.png'],'png');
state3_slot_L = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/Slot Machine_L.png'],'png');

step1_slot_R = imread(['stimuli/practice/' char(stim_color_step1(1)) '/Slot Machine_R.png'],'png');
state2_slot_R = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/Slot Machine_R.png'],'png');
state3_slot_R = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/Slot Machine_R.png'],'png');

% read coin slot files
state2_coin_slot = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(1)) '/coin slot.png'],'png');
state3_coin_slot = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/' char(stim_step2_color_select(2)) '/coin slot.png'],'png');

% read room files
token_room = imread(['stimuli/practice/' char(stim_color_step1(1)) '/token room.png'],'png');
prize_room = imread(['stimuli/practice/' char(stim_colors_step2(1)) '/prize room.png'],'png');

% read win/lose files
win = imread(['stimuli/practice/win_lose/win.png'],'png');
lose = imread(['stimuli/practice/win_lose/lose.png'],'png');

% read next arrow
next_arrow = imread(['stimuli/practice/next arrow.png'],'png');

% create original stimuli
A1 = Screen('MakeTexture', w, A1);
B1 = Screen('MakeTexture', w, B1);
A2 = Screen('MakeTexture', w, A2);
B2 = Screen('MakeTexture', w, B2);
A3 = Screen('MakeTexture', w, A3);
B3 = Screen('MakeTexture', w, B3);

% create tokens
state2_token = Screen('MakeTexture', w, state2_token);
state3_token = Screen('MakeTexture', w, state3_token);
spent_token = Screen('MakeTexture', w, spent_token);

% create token bag
A1_blank_token_bag = Screen('MakeTexture', w, A1_blank_token_bag);
B1_blank_token_bag = Screen('MakeTexture', w, B1_blank_token_bag);
A1_S2_token_bag = Screen('MakeTexture', w, A1_S2_token_bag);
A1_S3_token_bag = Screen('MakeTexture', w, A1_S3_token_bag);
B1_S2_token_bag = Screen('MakeTexture', w, B1_S2_token_bag);
B1_S3_token_bag = Screen('MakeTexture', w, B1_S3_token_bag);

% create slot machines
step1_slot_L = Screen('MakeTexture', w, step1_slot_L);
state2_slot_L = Screen('MakeTexture', w, state2_slot_L);
state3_slot_L = Screen('MakeTexture', w, state3_slot_L);

step1_slot_R = Screen('MakeTexture', w, step1_slot_R);
state2_slot_R = Screen('MakeTexture', w, state2_slot_R);
state3_slot_R = Screen('MakeTexture', w, state3_slot_R);

% create coin slots
state2_coin_slot = Screen('MakeTexture', w, state2_coin_slot);
state3_coin_slot = Screen('MakeTexture', w, state3_coin_slot);

% create rooms
token_room = Screen('MakeTexture', w, token_room);
prize_room = Screen('MakeTexture', w, prize_room);

% create win/lose
win = Screen('MakeTexture', w, win);
lose = Screen('MakeTexture', w, lose);

% create next arrow
next_arrow = Screen('MakeTexture', w, next_arrow);

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

% -----------------------------------------------------------------------------
% 1 - Intro

DrawFormattedText(w,[
    'Please read the instructions carefully.' '\n\n' ...
    'You will not be able to return to the previous screens.' ...
    ], 'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

DrawFormattedText(w,[
    'This is part one of the study.' '\n\n' ...
    'This tutorial teaches you the rules of the strategy game.' ...
    ], 'center','center', [], [], [], [], 1.6);
Screen('Flip',w, [], 1);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
KbWait([],2);

DrawFormattedText(w,[
    'If you have any questions, at any point,' '\n' ...
    'please do not hesitate to ask the experimenter.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);
% -----------------------------------------------------------------------------
% 2 - Game structure

Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
Screen('FrameRect',w,white,slot_label_Uframe,10);
DrawFormattedText(w,[
    'In this strategy game, there are six slot machines' ...
    ],'center', rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
Screen('FrameRect',w,white,slot_label_Uframe,10);
DrawFormattedText(w,[
    'During the game, you''ll play these slot' '\n' ...
    'machines many times to try to win prizes.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('Flip',w, [], 1);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);WaitSecs(1)


Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
Screen('FrameRect',w,white,slot_label_Uframe,10);
DrawFormattedText(w,[
    'The goal of the game is to find the best slot machine.' '\n' ...
    'The best slot machine is the one that wins the most!' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Upoint);
Screen('FrameRect',w,white,slot_label_Uframe,10);
DrawFormattedText(w,[
    'To win prizes in this strategy game, you''ll need to pay close' '\n' ...
    'attention. The slot machines are set up in a special way.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% -----------------------------------------------------------------------------
% 3 - Slot Layout
% ---- Token room

Screen('DrawTexture', w, token_room, [], room_Lpoint);
Screen('DrawTexture', w, prize_room, [], room_Rpoint);
DrawFormattedText(w,[
     'The six slot machines are split up into two rooms.' ...
     ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, token_room, [], room_Upoint);
DrawFormattedText(w,[
    'In the TOKEN ROOM,' '\n' ...
    'there are TWO SLOT MACHINES...' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'These slot machines are ' step1_color '.'...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Prize room
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'In the PRIZE ROOM,' '\n' ...
    'there are FOUR SLOT MACHINES...' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'Two of these slot' '\n' ...
    'machines are ' state2_color '...' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
Screen('DrawTexture', w, B3, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'and two slot machines are ' state3_color '.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Recap
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'Each slot machine is labeled by its color and symbol.' '\n' ...
    'Let''s look at the slots in each room again.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'The TOKEN ROOM has:' '\n' ...
    'Two ' step1_color ' slot machines, with two different symbols'
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('DrawTexture', w, A3, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'The PRIZE ROOM has:' '\n' ...
    'Two ' state3_color ' slot machines, with two different symbols, and...'
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('DrawTexture', w, A2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'two ' state2_color ' slot machines, with two more different symbols.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% -----------------------------------------------------------------------------
% 4 - Game progression

Screen('DrawTexture', w, token_room, [], room_Upoint);
DrawFormattedText(w,[
    'You will start each round in the TOKEN ROOM...' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'In the TOKEN ROOM, you will choose to play' '\n' ...
    'one of the two slot machines.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_token, [], Lpoint);
Screen('DrawTexture', w, state3_token, [], Rpoint);
DrawFormattedText(w,[
    'Every time you play a slot machine in the TOKEN ROOM,' '\n' ...
    'you will win ' a_an_2 state2_color ' token' ' or ' a_an_3 state3_color ' token...'
    ],'center',rect(4)*0.6, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_token, [], Lpoint);
Screen('DrawTexture', w, state3_token, [], Rpoint);
DrawFormattedText(w,[
    'If you win ' a_an_2 state2_color ' token, you''ll get one chance to play' '\n' ...
    a_an_2 state2_color ' slot machine in the PRIZE ROOM...'
    ],'center',rect(4)*0.6, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_token, [], Lpoint);
Screen('DrawTexture', w, state3_token, [], Rpoint);
DrawFormattedText(w,[
    'If you win ' a_an_3 state3_color ' token, you''ll get one chance to play' '\n' ...
     a_an_3 state3_color ' slot machine in the PRIZE ROOM.'
    ],'center',rect(4)*0.6, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_token, [], Upoint);
DrawFormattedText(w,[
    'Let''s pretend that you won ' a_an_2 state2_color ' token...' ...
    ],'center',rect(4)*0.6, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'so we will take you to the ' state2_color '\n' ...
    'slot machines in the PRIZE ROOM.'
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'As the name suggests, you can win prizes at' '\n' ...
    'all of the slot machines in the PRIZE ROOM!' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
DrawFormattedText(w,[
    'In the PRIZE ROOM, you will choose to play one of the' '\n' ...
    'slot machines that matches the color of your token.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% -----------------------------------------------------------------------------
% 5 - Walk through #1

DrawFormattedText(w,[
    'Let''s walk through a round together to' '\n' ...
    'get the hang of it.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% --- token room choice
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
WaitSecs(1)
KbWait([],2);

% ---- Wait for token room selection
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
      WaitSecs(1)
end

% ---- payoff screen, token room
Screen('DrawTexture', w, state2_token, [], Mpoint);
Screen('Flip',w);
WaitSecs(1);

% ---- payoff explanation, token room
Screen('DrawTexture', w, state2_token, [], Mpoint);
DrawFormattedText(w,[
    'You won ' a_an_2 state2_color ' token, so we will take you ' '\n' ...
    'to the ' state2_color ' slot machines in the PRIZE ROOM.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- fix cross explanation
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
DrawFormattedText(w,[
    'Before you enter each room, this symbol will show' '\n' ...
    'up in the middle of the screen...' ...
    ],'center',rect(4)*0.6, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
DrawFormattedText(w,[
    'Each time this shows up, focus on that middle point.' '\n'...
    'Your focus is very important for the eyetracker!'
    ],'center',rect(4)*0.6, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- prize room choice
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state2_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A2, [], slot_label_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('DrawTexture', w, state2_token, [], spent_token_Mpoint);
Screen('Flip',w);
KbWait([],2);

% ---- wait for prize room selection
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

% ---- payoff explanation A, prize room
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
      WaitSecs(1)

% ---- payoff explanation B, prize room
      Screen('DrawTexture', w, B2, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Win!' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)
end

% -----------------------------------------------------------------------------
% 6 - Walk through #2

DrawFormattedText(w,[
    'Let''s walk through another round together.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- fix cross
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
Screen('Flip',w);
WaitSecs(.5)

% --- token room choice
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('Flip',w);
KbWait([],2);

% ---- Wait for token room selection
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
      WaitSecs(1);
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

% ---- payoff screen, token room
Screen('DrawTexture', w, state3_token, [], Mpoint);
Screen('Flip',w);
WaitSecs(1);

% ---- payoff explanation, token room
Screen('DrawTexture', w, state3_token, [], Mpoint);
DrawFormattedText(w,[
'You won ' a_an_3 state3_color ' token, so we will take you ' '\n' ...
'to the ' state3_color ' slot machines in the PRIZE ROOM.' ...
],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- fix cross
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
WaitSecs(.5)

% ---- prize room choice
Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
Screen('DrawTexture', w, B3, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('DrawTexture', w, state3_token, [], spent_token_Mpoint);
Screen('Flip',w);
KbWait([],2);

% ---- wait for prize room selection
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
 while key_code(L) == 0 && key_code(R) == 0
         [key_is_down, secs, key_code] = KbCheck;
 end
down_key = find(key_code,1);

if down_key == L
      Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
      Screen('DrawTexture', w, B3, [], slot_label_Rpoint);
      Screen('FrameRect',w,green,slot_label_Lframe,10);
      Screen('FrameRect',w,white,slot_label_Rframe,10);
      Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
      Screen('DrawTexture', w, state3_coin_slot, [], coinslot_Lpoint);
      Screen('Flip',w);
      WaitSecs(1);

% ---- payoff explanation A, prize room
      Screen('DrawTexture', w, A3, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Lose' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)

elseif down_key == R
      Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
      Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
      Screen('DrawTexture', w, A3, [], slot_label_Lpoint);
      Screen('DrawTexture', w, B3, [], slot_label_Rpoint);
      Screen('FrameRect',w,white,slot_label_Lframe,10);
      Screen('FrameRect',w,green,slot_label_Rframe,10);
      Screen('DrawTexture', w, spent_token, [], spent_token_Mpoint);
      Screen('DrawTexture', w, state3_coin_slot, [], coinslot_Rpoint);
      Screen('Flip',w);
      WaitSecs(1)

% ---- payoff explanation B, prize room
      Screen('DrawTexture', w, B3, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Lose' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)
end

% -----------------------------------------------------------------------------
% 7 - Practice round #3, no walk through

DrawFormattedText(w,[
    'Let''s try playing one last round.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Get rid of token room payoff screen
DrawFormattedText(w,[
    'To speed things up, we will not show you the' '\n' ...
    'color of the token that you won. We will just take' '\n' ...
    'you to the correct slot machines in the PRIZE ROOM.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- fix cross
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
Screen(w, 'Flip');
WaitSecs(.5)

% ---- token room choice
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('Flip',w);
KbWait([],2);

% ---- Wait for token room selection
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

% ---- fix cross
Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 40);
Screen(w, 'Flip');
WaitSecs(.5)

% ---- prize room choice
Screen('DrawTexture', w, state3_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, state3_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, B3, [], slot_label_Lpoint);
Screen('DrawTexture', w, A3, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);
Screen('DrawTexture', w, state3_token, [], spent_token_Mpoint);
Screen('Flip',w);
KbWait([],2);

% ---- Wait for prize room selection
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

% ---- payoff explanation A, prize room
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
      WaitSecs(1)

% ---- payoff explanation B, prize room
      Screen('DrawTexture', w, A3, [], Mpoint);
      Screen('FrameRect',w,white,Mframe,10);
      DrawFormattedText(w,[
          'Lose' ...
          ],'center',rect(4)*0.75, [], [], [], [], 1.6);
      Screen('Flip',w);
      WaitSecs(1.5)
end

% ---- questions?
DrawFormattedText(w,[
    'Let''s pause for just a moment.' '\n\n' ...
    'If you have any questions at all about the strategy game,' '\n' ...
    'this is a great time to ask the experimenter.' '\n\n' ...
    'Once the experimenter has answered all of your questions,' '\n' ...
    'press any key to continue.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% -----------------------------------------------------------------------------
% 8 - Token room programming

DrawFormattedText(w,[
    'In order for you to win the most,' '\n' ...
    'you will need to know how we' '\n' ...
    'programmed the slot machines.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, token_room, [], room_Upoint);
DrawFormattedText(w,[
    'Let''s start in the TOKEN ROOM.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

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
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Intro token bags
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
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

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

Screen('DrawTexture', w, A1_blank_token_bag, [], L1point);
Screen('DrawTexture', w, A1_blank_token_bag, [], L2point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R1point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R2point);

DrawFormattedText(w,[
    'There are two bags for each slot machine...'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Slot machine 1
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, A1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, A1_blank_token_bag, [], R2point);
DrawFormattedText(w,[
    'For the first slot machine, we filled the top bag with a' '\n' ...
    'large, random, number of ' state2_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, A1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, A1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And the bottom bag with a large,' '\n' ...
    'random, number of ' state3_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, A1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, A1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And then we dumped them in the slot machine!'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Slot machine 2
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, B1_blank_token_bag, [], R2point);
DrawFormattedText(w,[
    'For the second slot machine, we filled the top bag with a' '\n' ...
    'large, random, number of ' state2_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, B1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And the bottom bag with a large,' '\n' ...
    'random, number of ' state3_color ' tokens...' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, B1_S2_token_bag, [], R1point);
Screen('DrawTexture', w, B1_S3_token_bag, [], R2point);
DrawFormattedText(w,[
    'And then we dumped them into the slot machine!'
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% --- Independence explanation
Screen('DrawTexture', w, step1_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, step1_slot_R, [], slot_Rpoint);
Screen('DrawTexture', w, A1, [], slot_label_Lpoint);
Screen('DrawTexture', w, B1, [], slot_label_Rpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('FrameRect',w,white,slot_label_Rframe,10);

DrawFormattedText(w,[
    'This means that at each slot machine,' '\n' ...
    'you have a different, unknown,' '\n' ...
    'chance of winning each color token.' ...
    ],'center',rect(4)*0.8, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- With replacement/fixed probs explanation
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
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

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
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- questions?
DrawFormattedText(w,[
    'Let''s pause for just a moment.' '\n\n' ...
    'If you have any questions at all about the strategy game,' '\n' ...
    'this is a great time to ask the experimenter.' '\n\n' ...
    'Once the experimenter has answered all of your questions,' '\n' ...
    'press any key to continue.' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% -----------------------------------------------------------------------------
% 9 - Prize room programming

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Let''s move to the PRIZE ROOM.' ...
    ],'center',rect(4)*0.75, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Slot machines independent
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'There are two important things about how the' '\n' ...
    'slot machines in the PRIZE ROOM were programmed.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'First: At each slot machine in the PRIZE ROOM,' '\n' ...
    'you have a different, unknown, chance of winning.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Slot machines probabilities will change
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Second: Your chance of winning, at each slot' '\n' ...
    'machine in the PRIZE ROOM, WILL CHANGE!' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'This makes the slot machines in the PRIZE ROOM a' '\n' ...
    'bit more complicated than those in the TOKEN ROOM.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, token_room, [], room_Upoint);
DrawFormattedText(w,[
    'Remember: in the TOKEN ROOM, your chance of' '\n'...
    'winning each color token does not change.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'To best understand how your chances of' '\n' ...
    'winning will change, imagine that...' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Each time you leave the PRIZE ROOM, we' '\n' ...
    'make a TINY, random, tweak to your' '\n' ...
    'chances of winning at each slot machine.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'This means that each time you return to the PRIZE ROOM,' '\n' ...
    'your chance of winning at each slot machine will be' '\n' ...
    'slightly different than it was the round before.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Example slot machine changing
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Let''s look at one slot machine as an example.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, win, [], CenterRectOnPoint([0,0,533*.6,387*.6], 3*rect(3)/4, rect(4)*0.3));
Screen('DrawTexture', w, lose, [], CenterRectOnPoint([0,0,533*.4,387*.4], 3*rect(3)/4, rect(4)*0.5));
DrawFormattedText(w,[
    'Let''s pretend that at the beginning of the game' '\n' ...
    'this slot machine has a good chance of winning.' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- Animation
Screen('DrawTexture', w, state2_slot_L, [], slot_Lpoint);
Screen('DrawTexture', w, B2, [], slot_label_Lpoint);
Screen('FrameRect',w,white,slot_label_Lframe,10);
Screen('DrawTexture', w, win, [], CenterRectOnPoint([0,0,533*.6,387*.6], 3*rect(3)/4, rect(4)*0.3));
Screen('DrawTexture', w, lose, [], CenterRectOnPoint([0,0,533*.4,387*.4], 3*rect(3)/4, rect(4)*0.5));
DrawFormattedText(w,['Round: 1'], rect(3)*.7, rect(4)*0.2, [], [], [], [], 1.6);
DrawFormattedText(w,[
    'Watch how your chance of winning at this slot' '\n' ...
    'machine slowly changes over 75 rounds of the game.' '\n\n' ...
    'Press any key to start.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(1)
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
    DrawFormattedText(w,['Round: ' num2str(trial_num(trial))], rect(3)*.7, rect(4)*0.2, [], [], [], [], 1.6);
    Screen('Flip',w);
    WaitSecs(.05)
end

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
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- directionality of change
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'Remember: These TINY tweaks are RANDOM...' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'This means that a slot machine that starts' '\n' ...
    'off with a HIGH chance of winning can SLOWLY' '\n'...
    'get better, SLOWLY get worse, or stay the same...'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'On the flip side, a slot machine that starts' '\n' ...
    'off with a LOW chance of winning can SLOWLY' '\n'...
    'get better, SLOWLY get worse, or stay the same.'
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- this means you have to pay attention!
Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'This means that you will have to pay close attention to' '\n' ...
    'figure out which slot machine in the PRIZE ROOM is the best!' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

Screen('DrawTexture', w, prize_room, [], room_Upoint);
DrawFormattedText(w,[
    'During the game, which slot machine in' '\n' ...
    'the PRIZE ROOM is the best may change!' ...
    ],'center',rect(4)*0.7, [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

% ---- questions?
DrawFormattedText(w,[
    'Now we''ve gone over all of the rules and programming,' '\n' ...
    'but there were a lot of things to keep track of!' '\n' ...
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

DrawFormattedText(w,[
    'If we explained anything poorly in our tutorial,' '\n' ...
    'this is a great time to ask for clarification.' '\n\n' ...
    'After all of your questions have been answered,' '\n' ...
    'you will play 15 practice rounds.'
    ],'center','center', [], [], [], [], 1.6);
Screen('DrawTexture', w, next_arrow, [], next_arrow_loc);
Screen('Flip',w);
WaitSecs(1)
KbWait([],2);

ShowCursor; %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?
Screen('Close',w); %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?
Screen('Close'); %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?

%jheapcl; ALTERED FOR DEBUGGING

end
