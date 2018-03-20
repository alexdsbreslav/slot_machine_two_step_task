function mytutorial

% tutorial for the learning task

%clear all

Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING

FlushEvents;

PsychDefaultSetup(1);
Screen('CloseAll');
Screen('Close');

%HideCursor; ALTERED FOR DEBUGGING

global rect sub


%set random number generator
%rand('state',sum(100*clock));

doublebuffer=1;
screens = Screen('Screens'); %count the screen
whichScreen = min(screens); %select the screen ALTERED FOR DEBUGGING
[w,rect] = Screen('OpenWindow', whichScreen, 0,[], 32, ...
        doublebuffer+1,[],[],kPsychNeedFastBackingStore);

r = [0,0,400,290]; %stimuli rectangle
rc = [0,0,420,310]; %choice rectangle
Lpoint = CenterRectOnPoint(r, rect(3)/4, rect(4)*0.3); %drawingpoints on screen
L1point = CenterRectOnPoint(r, rect(3)/4, rect(4)*0.2);
L2point = CenterRectOnPoint(r, rect(3)/4, rect(4)*0.5);
Rpoint = CenterRectOnPoint(r, 3*rect(3)/4, rect(4)*0.3);
R1point = CenterRectOnPoint(r, 3*rect(3)/4, rect(4)*0.2);
R2point = CenterRectOnPoint(r, 3*rect(3)/4, rect(4)*0.5);
Upoint = CenterRectOnPoint  (r, rect(3)/2, rect(4)*0.3);
Mpoint = CenterRectOnPoint(r, rect(3)/2, rect(4)*0.5);

%choice frames
Lchoice = CenterRectOnPoint(rc, rect(3)/4, rect(4)*0.3); %drawingpoints on screen
Rchoice = CenterRectOnPoint(rc, 3*rect(3)/4, rect(4)*0.3);
Uchoice = CenterRectOnPoint(rc, rect(3)/2, rect(4)*0.3);

%loading stimuli images
A1 = imread('1AP.png','png');
B1 = imread('1BP.png','png');

A2 = imread('2AP.png','png');
B2 = imread('2BP.png','png');

A3 = imread('3AP.png','png');
B3 = imread('3BP.png','png');

A1 = Screen('MakeTexture', w, A1);
B1 = Screen('MakeTexture', w, B1);
A2 = Screen('MakeTexture', w, A2);
B2 = Screen('MakeTexture', w, B2);
A3 = Screen('MakeTexture', w, A3);
B3 = Screen('MakeTexture', w, B3);

change1 = imread('change1.png');
change2 = imread('change2.png');
change3 = imread('change3.png');
change4 = imread('change4.png');
change35 = imread('change35.png');
change50 = imread('change50.png');
change50b = imread('change50b.png');
change50c = imread('change50c.png');
change1 = Screen(w,'MakeTexture',change1);
change2 = Screen(w,'MakeTexture',change2);
change3 = Screen(w,'MakeTexture',change3);
change4 = Screen(w,'MakeTexture',change4);
change35 = Screen(w,'MakeTexture',change35);
change50 = Screen(w,'MakeTexture',change50);
change50b = Screen(w,'MakeTexture',change50b);
change50c = Screen(w,'MakeTexture',change50c);


% Keyboard
KbName('UnifyKeyNames');
L = KbName('LeftArrow');
R = KbName('RightArrow');

white = [255 255 255];
black = [0 0 0];
green = [0 220 0];

Screen('FillRect', w, [0 0 0]);
Screen('TextSize', w, 30);
Screen('TextColor',w,[255 255 255]);
Screen('TextFont',w,'Helvetica');

% screen 1
DrawFormattedText(w,'Press any key to start the tutorial for the first part of the experiment, and to continue from page to page.',...
    'center','center');
Screen('Flip',w);
KbWait([],2);


% screen 1
DrawFormattedText(w,'Please read the instructions carefully. You will not be able to return to previous screens.',...
    'center','center');
Screen('Flip',w);
KbWait([],2);

% screen 2
DrawFormattedText(w,'Your goal in this experiment is to win as many rewards as possible.','center','center');
Screen('Flip',w);
KbWait([],2);

% screen 3
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['In the game, you will see pairs of boxes.  They are identified by a symbol and a color.' '\n\n'...
    'Your job is to choose one of them.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);


% screen 4
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['Each of the first type of box we will consider has a certain chance of containing a reward.' '\n\n'...
    'The aim is to find a box with a high chance of a reward, and choose it.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['In this demonstration you won''t be playing for real rewards.' '\n\n'...
    'In the actual experiment, you will be playing for real money and food.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);


% screen 5
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['For this demonstration, you will select the box you want using the keyboard.' '\n\n'...
    'You select the left box by pressing the left arrow key, and the right box by pressing the right arrow key.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 6
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['Practice selecting them now, using the arrow keys.  When you select a box, it will highlight.''\n\n'...
    'The tutorial will continue after 4 presses.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

for t = 1:4
   Screen('DrawTexture', w, A2, [], Lpoint);
   Screen('DrawTexture', w, B2, [], Rpoint);
   Screen('Flip',w);
   FlushEvents;
   [key_is_down, secs, key_code] = KbCheck;
    while key_code(L) == 0 && key_code(R) == 0
            [key_is_down, secs, key_code] = KbCheck;
    end
   down_key = find(key_code,1);

   if down_key == L
            Screen('DrawTexture', w, A2, [], Lpoint);
            Screen('DrawTexture', w, B2, [], Rpoint);
            Screen('FrameRect',w,green,Lchoice);
            DrawFormattedText(w,['When you select a box, it will highlight. Try another box.'],'center',...
            rect(4)*0.7);
            Screen('Flip',w);
            WaitSecs(1.5);
   elseif down_key == R
           Screen('DrawTexture', w, A2, [], Lpoint);
           Screen('DrawTexture', w, B2, [], Rpoint);
            Screen('FrameRect',w,green,Rchoice);
            DrawFormattedText(w,['When you select a box, it will highlight. Try another box.'],'center',...
                rect(4)*0.7);
            Screen('Flip',w);
            WaitSecs(1.5);
   end

end

DrawFormattedText(w,['Press any key to continue.'],'center','center');
Screen('Flip',w);
KbWait([],2);


% screen 8
DrawFormattedText(w,'After a box is selected, you will find out the result','center','center');
Screen('Flip',w);
KbWait([],2);

% screen 9
Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['It is important to understand how the computer decides whether you win a reward.' '\n\n'...
    'To illustrate this, consider just one of the boxes.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 10
Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['Each time you select a box the computer spins a slot machine to decide if you win.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['For this box, you have a 60% chance of winning.' '\n\n'...
    'Other boxes may be more or less, and after this demonstration you will have to figure it out for yourself.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 11
Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['To get a feel for this, have a try:' '\n\n'...
    'Every time you select the box is like playing a game of chance, with a 60% of winning a reward.' '\n\n'...
    'Press the left arrow key to select the box and try this out.' '\n\n'...
    'You will get 10 tries.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

a=[1 0 1 1 1 0 1 0 1 1];

for i = 1:10
   Screen('DrawTexture', w, A2, [], Upoint);
   Screen('Flip',w);
   FlushEvents;
   [key_is_down, secs, key_code] = KbCheck;
    while key_code(L) == 0
            [key_is_down, secs, key_code] = KbCheck;
    end
   down_key = find(key_code,1);

   if down_key == L
            Screen('DrawTexture', w, A2, [], Upoint);
            Screen('FrameRect',w,green,Uchoice);
            if a(i) == 1
                DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
                Screen('Flip',w);
            else
                DrawFormattedText(w,['0 points'],'center',rect(4)*0.7);
                Screen('Flip',w);
            end
            WaitSecs(1);
   end
end

Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['Total number of wins = 7' '\n\n'...
    'Press any key to continue.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 12
Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['The chance to win is random in every round. Beyond this there are no patterns.' '\n\n'...
    'For instance, wins and losses do not alternate.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 13
DrawFormattedText(w,['Of course, not all boxes will be equally good.  Other boxes may give you rewards less (or more) often.' '\n\n'...
    'In the next example, one box will be better than the other.'],'center','center');
Screen('Flip',w);
KbWait([],2);

% screen 14
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['During the game, try selecting both boxes, and see if you can work out which one is better.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 15
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['Each box is identified by its symbol and its color.  Each box will sometimes come up on the right...'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A2, [], Rpoint);
Screen('DrawTexture', w, B2, [], Lpoint);
DrawFormattedText(w,['...and sometimes come up on the left.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['Which side a box appears on does not influence your chance of winning.' '\n\n'...
    'For instance, left is not luckier than right.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 17
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
DrawFormattedText(w,['Now try to find the better box.  You have 20 trials in this game.' '\n\n'...
    'Remember, the left arrow key is for the left box, and the right arrow key is for the right box.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);



for t = 1:5 %ALTERED FOR DEBUGGING. THIS WAS SET AT 20 TRIALS BUT I SHORTENED IT TO GET THROUGH FASTER

    Screen(w, 'FillRect', black);
    Screen('TextSize', w, 60);
    DrawFormattedText(w, '+', 'center', 'center', white);
    Screen(w, 'Flip');
    WaitSecs(1);

    Screen('TextSize', w, 30);
    r = rand;
   if  r > 0.5
       a = Lpoint; b = Rpoint; type = 0;
   else a = Rpoint; b = Lpoint; type = 1;
   end

   Screen('DrawTexture', w, A2, [], a);
   Screen('DrawTexture', w, B2, [], b);
   Screen('Flip',w);
   FlushEvents;
   [key_is_down, secs, key_code] = KbCheck;
    while key_code(L) == 0 && key_code(R) == 0
            [key_is_down, secs, key_code] = KbCheck;
    end
   down_key = find(key_code,1);

   if down_key == L
            Screen('DrawTexture', w, A2, [], a);
            Screen('DrawTexture', w, B2, [], b);
            Screen('FrameRect',w,green,Lchoice);
            r = rand;
            if type == 0
                if r < 0.9
                    DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
                else
                    DrawFormattedText(w,['0 points'],'center',rect(4)*0.7);
                end
            else
                 if r < 0.1
                    DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
                else
                    DrawFormattedText(w,['0 points'],'center',rect(4)*0.7);
                 end
            end
            Screen('Flip',w);
            WaitSecs(1);
   elseif down_key == R
           Screen('DrawTexture', w, A2, [], a);
           Screen('DrawTexture', w, B2, [], b);
           Screen('FrameRect',w,green,Rchoice);
           r = rand;
           if type == 1
                if r < 0.9
                    DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
                else
                    DrawFormattedText(w,['0 points'],'center',rect(4)*0.7);
                end
            else
                 if r < 0.1
                    DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
                else
                    DrawFormattedText(w,['0 points'],'center',rect(4)*0.7);
                 end
           end
           Screen('Flip',w);
           WaitSecs(1);
   end

end

DrawFormattedText(w,['Press any key to continue.'],'center','center');
Screen('Flip',w);
KbWait([],2);


% screen 18
Screen('DrawTexture', w, A2, [], Upoint);
DrawFormattedText(w,['This was the better box.  If you were playing for real, then you would want to choose it over the other box.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 19
DrawFormattedText(w,['The actual game is harder for two reasons.' '\n\n'...
    'First, the chance that a box contains a reward can change slowly over time.'],'center','center');
Screen('Flip',w);
KbWait([],2);

% screen 20
DrawFormattedText(w,['Because the boxes can slowly change, a box that starts out better,' '\n\n'...
    'can turn worse later, or a worse one can turn better.' '\n\n'...
    'So finding the box that is best right now requires continual concentration.'],'center','center');
Screen('Flip',w);
KbWait([],2);


% screen 21
DrawFormattedText(w,['Boxes can also stay more or less the same, or change back and forth, or many other patterns.'],'center','center');
Screen('Flip',w);
KbWait([],2);
DrawFormattedText(w,['In fact, the change is completely unpredictable. But it is also slow.' '\n\n'...
    'So a box that is good now will probably be pretty good for a while.'],'center','center');
Screen('Flip',w);
KbWait([],2);

% screen 22
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change1, [], Rpoint);
DrawFormattedText(w,['To illustrate this, again consider just one box.' '\n\n'...
   'Here is an example of how the chance of wins might start off. Initially, there is a 60% chance of a win.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 23
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change2, [], Rpoint);
DrawFormattedText(w,['On the next few trials it is similar...'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change3, [], Rpoint);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change4, [], Rpoint);
DrawFormattedText(w,['But see how it looks 30 trials later...'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 24
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change35, [], Rpoint);
DrawFormattedText(w,['Now there is little chance of winning a reward from this box.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 25
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change50, [], Rpoint);
DrawFormattedText(w,['Later still it might get a bit better again.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 26
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change50b, [], Rpoint);
DrawFormattedText(w,['Now imagine what would happen if you selected this box repeatedly.' '\n\n'...
    'The stars above the line show when you might win a reward.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);


% screen 27
Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, change50b, [], Rpoint);
DrawFormattedText(w,['Early on, you often get wins, but later you get fewer, and still later, somewhat more.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 28
Screen('DrawTexture', w, A2, [], L1point);
Screen('DrawTexture', w, B2, [], L2point);
Screen('DrawTexture', w, change50c, [], Rpoint);
DrawFormattedText(w,['The red line shows another hypothetical box.' '\n\n'...
    'It starts off worse, at 45%, but doesnt change much.' '\n\n'...
    'So in the game you would do well if you started choosing the first box, but switched to the other one later on.' '\n\n'...
    'Of course you have to figure out which is best.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 29
Screen('DrawTexture', w, A2, [], L1point);
Screen('DrawTexture', w, B2, [], L2point);
Screen('DrawTexture', w, change50c, [], Rpoint);
DrawFormattedText(w,['Remember, these are just examples.' '\n\n'...
    'In the game, boxes will also get better and show other forms of unpredictable change.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 30
Screen('DrawTexture', w, A2, [], L1point);
Screen('DrawTexture', w, A3, [], L2point);
Screen('DrawTexture', w, B2, [], R1point);
Screen('DrawTexture', w, B3, [], R2point);
DrawFormattedText(w,['You are almost ready to try out the full game.' '\n\n'...
    'But there is one more complication: more boxes.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A2, [], L1point);
Screen('DrawTexture', w, A3, [], L2point);
Screen('DrawTexture', w, B2, [], R1point);
Screen('DrawTexture', w, B3, [], R2point);
DrawFormattedText(w,['In particular, there are two pairs of boxes containing rewards.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 31
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['There is also a third pair of boxes.' '\n\n'...
    'In the game, you start each trial by choosing between these two.' '\n\n'...
    'Rather than having some chance of giving you a reward,' '\n\n'...
    'these have a chance of giving you either of the two pairs of reward boxes...'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['... which you then choose between to win a reward as before.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

%screen 32
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['Try it now: Select a box with the arrow keys'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen(w, 'Flip');
WaitSecs(1);

Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
Screen('Flip',w);
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
while key_code(L) == 0 && key_code(R) == 0
        [key_is_down, secs, key_code] = KbCheck;
end
down_key = find(key_code,1);

if down_key == L
        Screen('DrawTexture', w, A1, [], Lpoint);
        Screen('DrawTexture', w, B1, [], Rpoint);
        Screen('FrameRect',w,green,Lchoice);
        Screen('Flip',w);
        WaitSecs(1);
elseif down_key == R
       Screen('DrawTexture', w, A1, [], Lpoint);
       Screen('DrawTexture', w, B1, [], Rpoint);
        Screen('FrameRect',w,green,Rchoice);
        Screen('Flip',w);
        WaitSecs(1);
end

Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 30);
Screen(w, 'Flip');
WaitSecs(1);

Screen('DrawTexture', w, A2, [], Lpoint);
Screen('DrawTexture', w, B2, [], Rpoint);
Screen('Flip',w);
FlushEvents;
[key_is_down, secs, key_code] = KbCheck;
while key_code(L) == 0 && key_code(R) == 0
        [key_is_down, secs, key_code] = KbCheck;
end
down_key = find(key_code,1);

if down_key == L
        Screen('DrawTexture', w, A2, [], Lpoint);
        Screen('DrawTexture', w, B2, [], Rpoint);
        Screen('FrameRect',w,green,Lchoice);
        DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
        Screen('Flip',w);
        WaitSecs(1);
elseif down_key == R
       Screen('DrawTexture', w, A2, [], Lpoint);
       Screen('DrawTexture', w, B2, [], Rpoint);
       DrawFormattedText(w,['+1 point'],'center',rect(4)*0.7);
        Screen('FrameRect',w,green,Rchoice);
        Screen('Flip',w);
        WaitSecs(1);
end

%screen 33
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
Screen('FrameRect',w,green,Lchoice);
DrawFormattedText(w,['Just like the reward boxes, when you select one of these boxes,' '\n\n'...
    'the computer spins a slot machine to determine which pair of reward boxes to give you.' '\n\n'...
    'For instance, this one might give you the blue boxes about 7 times out of 10,' '\n\n'...
    'and give you the purple boxes about 3 times out of 10.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

%screen 34
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
Screen('FrameRect',w,green,Rchoice);
DrawFormattedText(w,['Whereas this one might give you the blue boxes about 3 times out of 10,' '\n\n'...
    'and give you the purple boxes about 7 times out of 10.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
Screen('FrameRect',w,green,Rchoice);
DrawFormattedText(w,['If these were the chances and if the box with the best chance of a reward was a purple one,' '\n\n'...
    'then this box would be a better choice.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

%screen 35
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['Important: the chances of these boxes leading to different colored reward boxes does not change over time.' '\n\n'...
    'This is different from the chances of finding a reward in the other boxes, which does change over time.' '\n\n'...
    'Even though the chances of these boxes will not change over time, you will still have to figure out what those chances are.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 36
Screen('DrawTexture', w, A2, [], L1point);
Screen('DrawTexture', w, A3, [], L2point);
Screen('DrawTexture', w, B2, [], R1point);
Screen('DrawTexture', w, B3, [], R2point);
DrawFormattedText(w,['This may all sound complicated, so let''s review:' '\n\n'...
    'These boxes are two games of figuring out which one has a better chance of a reward.' '\n\n'...
    'This is just like what you played before except that the chance of a reward is changing.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['On top of that game is another one of figuring out which box is better.' '\n\n'...
    'This is also like what you played before, except with these boxes you don''t win rewards directly:' '\n\n'...
    'you win the chance to win a reward in the other game.' '\n\n'...
    'A better box will take you to a game with a better chance of winning a reward.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

%screen 37
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['Important reminder 1 (of 3):' '\n\n'...
    'What matters is the box color and symbol, not what side it appears on.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

%screen 38
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['Important reminder 2 (of 3):' '\n\n'...
    'The choice you make between the beige boxes only affects whether you get to the blue or purple reward boxes.' '\n\n'...
    'The choice you make between the beige boxes has no effect on how likely you are to win a reward from a blue or purple box.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

%screen 39.1
Screen('DrawTexture', w, A1, [], Lpoint);
Screen('DrawTexture', w, B1, [], Rpoint);
DrawFormattedText(w,['Important reminder 3 (of 3):' '\n\n'...
    'You will have to figure out all of chances in the game.' '\n\n'...
    'The chance of a beige box leading to the blue or purple boxes does not change.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);
%screen 39.2
Screen('DrawTexture', w, A2, [], L1point);
Screen('DrawTexture', w, A3, [], L2point);
Screen('DrawTexture', w, B2, [], R1point);
Screen('DrawTexture', w, B3, [], R2point);
DrawFormattedText(w,['Important reminder 3 (of 3):' '\n\n'...
    'The chance of winning a reward from the blue or puprple boxes slowly changes over time.'],'center',...
    rect(4)*0.7);
Screen('Flip',w);
KbWait([],2);

% screen 40
DrawFormattedText(w,['Let''s put it all together into an example game.' '\n\n'...
    'In this practice, you won''t be winning real rewards, we''ll just show you that you won!' '\n\n'...
    'You will do the task for 15 trials, which is less than 4 minutes.'],'center','center');
Screen('Flip',w);
KbWait([],2);

Screen(w, 'FillRect', black);
Screen('TextSize', w, 60);
DrawFormattedText(w, '+', 'center', 'center', white);
Screen('TextSize', w, 30);
DrawFormattedText(w,['This experiment uses eye-tracking' '\n\n'...
    'In the actual experiment, before every choice you will have to stare at the white cross in middle of the screen' '\n\n'...
    'for one second, or the software will not allow you to proceed'],'center',...
    rect(4)*0.8);
Screen(w, 'Flip');
KbWait([],2);


ShowCursor; %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?
Screen('Close',w); %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?
Screen('Close'); %ALTERED FOR DEBUGGING; THIS WAS HASHED OUT?

%jheapcl; ALTERED FOR DEBUGGING


end
