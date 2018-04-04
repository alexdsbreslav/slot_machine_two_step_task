% The bulk of this task code was written by Arkady Konovalov, PhD (University of Zurich)
% and generously shared on request. I have superficially altered the script to be amenable to
% multiple blocks with different reward structures. Portions of this code have been pulled
% from a script written by Nikki Sullivan, PhD (Duke University) with her permission.

% Please do not share or use this script without the permission of all invovled parties.

function main_task(trials, block)

    global w rect sub pay stim_color_step1 ...
    stim_colors_step2 stim_step2_color_select ...
    stim_prac_symbol stim_symbol rng_seed ...
    A1 B1 A2 B2 A3 B3

    % some setups
    Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
    FlushEvents;
    %HideCursor; %ALTERED FOR DEBUGGING
    PsychDefaultSetup(1);

    %create file name string for sub with leading zeros
    filename_subnum = pad(num2str(sub), 3, 'left', '0');

    % check block
     if block == 0
         results_file_name = ['sub' filename_subnum '_practice'];
     elseif block == 1
         results_file_name = ['sub' filename_subnum '_money'];
     else
         results_file_name = ['sub' filename_subnum '_food'];
     end

    % Check to prevent overwriting previous data
     A= exist([results_file_name '.mat'], 'file');
     if A
        writeover=input('Subject + Session number already exists, do you want to overwrite? 1=yes, 0=no ');
     else
        writeover=1;
     end

   switch writeover
    case 0
        disp(' ')
        disp('Try again then')
    case 1



    % Open the screen
    doublebuffer=1; %????
    screens = Screen('Screens'); %count the screen
    whichScreen = min(screens); %select the screen; ALTERED THIS BECAUSE IT KEPT SHOWING UP ON MY LAPTOP INSTEAD OF THE ATTACHED MONITOR
    [w, rect] = Screen('OpenWindow', whichScreen, 0,[], 32, ...
        doublebuffer+1,[],[],kPsychNeedFastBackingStore); %???


    % display coordinates setup
    r = [0,0,400,290];
    rc = [0,0,420,310]; %choice rectangle
    Lpoint = CenterRectOnPoint(r, rect(3)/4, rect(4)*0.3); %drawingpoints on screen
    Rpoint = CenterRectOnPoint(r, 3*rect(3)/4, rect(4)*0.3);
    Upoint = CenterRectOnPoint(r, rect(3)/2, rect(4)*0.2);
    Mpoint = CenterRectOnPoint(r, rect(3)/2, rect(4)*0.5);
    Lchoice = CenterRectOnPoint(rc, rect(3)/4, rect(4)*0.3); %drawingpoints on screen
    Rchoice = CenterRectOnPoint(rc, 3*rect(3)/4, rect(4)*0.3);

    % loading images from the randomized permutations

    if block == 0
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

    elseif block == 1
        A1 = imread(['stimuli/main_task/' char(stim_color_step1(2)) '/' ...
          char(stim_symbol(1)) '.png'],'png');
        B1 = imread(['stimuli/main_task/' char(stim_color_step1(2)) '/' ...
          char(stim_symbol(2)) '.png'],'png');

        A2 = imread(['stimuli/main_task/' char(stim_colors_step2(2)) '/' char(stim_step2_color_select(1)) '/' ...
          char(stim_symbol(3)) '.png'],'png');
        B2 = imread(['stimuli/main_task/' char(stim_colors_step2(2)) '/' char(stim_step2_color_select(1)) '/' ...
          char(stim_symbol(4)) '.png'],'png');

        A3 = imread(['stimuli/main_task/' char(stim_colors_step2(2)) '/' char(stim_step2_color_select(2)) '/' ...
          char(stim_symbol(5)) '.png'],'png');
        B3 = imread(['stimuli/main_task/' char(stim_colors_step2(2)) '/' char(stim_step2_color_select(2)) '/' ...
          char(stim_symbol(6)) '.png'],'png');

    else
        A1 = imread(['stimuli/main_task/' char(stim_color_step1(3)) '/' ...
          char(stim_symbol(7)) '.png'],'png');
        B1 = imread(['stimuli/main_task/' char(stim_color_step1(3)) '/' ...
          char(stim_symbol(8)) '.png'],'png');

        A2 = imread(['stimuli/main_task/' char(stim_colors_step2(3)) '/' char(stim_step2_color_select(1)) '/' ...
          char(stim_symbol(9)) '.png'],'png');
        B2 = imread(['stimuli/main_task/' char(stim_colors_step2(3)) '/' char(stim_step2_color_select(1)) '/' ...
          char(stim_symbol(10)) '.png'],'png');

        A3 = imread(['stimuli/main_task/' char(stim_colors_step2(3)) '/' char(stim_step2_color_select(2)) '/' ...
          char(stim_symbol(11)) '.png'],'png');
        B3 = imread(['stimuli/main_task/' char(stim_colors_step2(3)) '/' char(stim_step2_color_select(2)) '/' ...
          char(stim_symbol(12)) '.png'],'png');
    end

    % Keyboard
    KbName('UnifyKeyNames');
    L = KbName('LeftArrow');
    R = KbName('RightArrow');
    exitKeys = KbName({'e', 'E'});
    spaceKey = KbName('space');
    startFirstKeys = KbName({'b', 'B'});
    continueKeys = KbName({'c', 'C'});

    % Variables
    a = 0.4 + 0.6.*rand(trials,2); %transition probabilities
    r = rand(trials, 2); %transition determinant

    % colors
    gray = 150;
    black = 0;
    white = [255];
    brown = [102,51,0];
    chosen_color = [0 220 0];

    % indicator drawing points
    ind = [0,0,400,50];
    blue = [152,205,232];
    purple = [196,182,206];

    % blank matrices for variables
    action = NaN(trials,3);
    choice_on_time = NaN(trials,1);
    choice_off_time = NaN(trials,1);
    position = NaN(trials,3);
    state = NaN(trials,1);

    payoff_prob = zeros(trials,4);
    payoff_prob(1,:) = 0.25 + 0.5.*rand(1,4);
    payoff_det = rand(trials,4);
    payoff = NaN(trials,2);

    % Waiting screen
    Screen('FillRect', w, black);
    Screen('TextSize', w, 30);

    % Screen at the beginning of each block
    if block == 0
        DrawFormattedText(w, 'Press b to begin the practice round', 'center', 'center', white);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

    elseif block == 2 % block == 2 is food
        A = exist(['sub' num2str(sub) '_money.mat'], 'file');
        if A
            part = 2;
            % Screen 1a if we are on block 2
            DrawFormattedText(w, ['This is part 2(of 2) of the experiment.' '\n\n'...
            'The rules of the game are exactly the same, but the chances of winning from each reward block have been reset!'],'center', 'center', white);
            Screen(w, 'Flip');
            KbWait([],2);
        else
            part = 1;
        end

        % Screen 1b
        DrawFormattedText(w, ['In this part of the experiment, you will be playing for food rewards.' '\n\n'...
        'Each time you choose a reward box, you''ll take one bite of a snack.'],'center', 'center', white);
        Screen(w, 'Flip');
        KbWait([],2);

        % Screen 2
        DrawFormattedText(w, ['You can choose either snack as much or as little as you like.' '\n\n'...
          'We have given you enough of each snack to make sure that you cannot run out.'],'center', 'center', white);
        Screen(w, 'Flip');
        KbWait([],2);

        % Screen 3

        DrawFormattedText(w, ['Press b to begin part ' num2str(part) '(of 2) of the experiment.'], 'center', 'center', white);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

    else % block = 1 is money
        A = exist(['sub' num2str(sub) '_food.mat'], 'file');
        if A
            part = 2;
            % Screen 1a if we are on block 2
            DrawFormattedText(w, ['This is part 2(of 2) of the experiment.' '\n\n'...
            'The rules of the game are exactly the same, but the chances of winning from each reward block have been reset!'],'center', 'center', white);
            Screen(w, 'Flip');
            KbWait([],2);
        else
            part = 1;
        end

        % Screen 1
        DrawFormattedText(w, ['In this part of the experiment, you will be playing for money.' '\n\n'...
        'Each time you choose a reward box, you''ll win 10 cents.'],'center', 'center', white);
        Screen(w, 'Flip');
        KbWait([],2);

        % Screen 2
        DrawFormattedText(w, ['Each time you win 10 cents, you''ll take a dime out of one of the two bowls and place it in your bank.'],'center', 'center', white);
        Screen(w, 'Flip');
        KbWait([],2);

        % Screen 3
        DrawFormattedText(w, ['You can choose from either bowl as much or as little as you like.' '\n\n'...
          'We have given you enough dimes in each bowl to make sure that you cannot run out.'],'center', 'center', white);
        Screen(w, 'Flip');
        KbWait([],2);

        % Screen 4
        DrawFormattedText(w, ['Press b to begin part ' num2str(part) '(of 2) of the experiment.'], 'center', 'center', white);
        Screen(w, 'Flip');

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              sca; return
          elseif keyIsDown && any(keyCode(startFirstKeys))
              break
          end
        end

    end

    Screen('CloseAll');



    Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
    %HideCursor; ALTERED FOR DEBUGGING

    WaitSecs(0.1);

    [w, rect] = Screen('OpenWindow', whichScreen, 0,[], 32, ...
        doublebuffer+1,[],[],kPsychNeedFastBackingStore);

    % Trial loop

    t0 = GetSecs;

    for trial = 1:trials

        % First stage

        % short break

        if block ~= 0

            if trial == (trials/3) + 1 || trial == (2*trials/3) + 1
                Screen('FillRect', w, black);
                Screen('TextSize', w, 30);
                DrawFormattedText(w, 'You can take a short break. Press left or right to continue', 'center', 'center', white);
                Screen(w, 'Flip');
                KbWait([],2);
            end
        end

        % Fixation screen
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, 60);
        DrawFormattedText(w, '+', 'center', 'center', white);
        Screen(w, 'Flip');
        WaitSecs(.5);

        % Draw indicators

        Screen(w, 'FillRect', black);


        position(trial,1) = round(rand); %randomizing images positions

        type = position(trial,1);

        % Draw stimuli


        picL = drawimage(type,1);
        picR = drawimage(1-type,1);

        Screen('DrawTexture', w, picL, [], Lpoint);
        Screen('DrawTexture', w, picR, [], Rpoint);
        Screen('FrameRect',w,white,Lchoice,10); %outline the stimuli with white box
        Screen('FrameRect',w,white,Rchoice,10);
        Screen('Flip', w);


        choice_on_time(trial,1) = GetSecs - t0;

        key_is_down = 0;
        FlushEvents;
        [key_is_down, secs, key_code] = KbCheck;

        while key_code(L) == 0 && key_code(R) == 0
                [key_is_down, secs, key_code] = KbCheck;
        end

        choice_off_time(trial,1) = GetSecs - t0;

        down_key = find(key_code,1);

        if (down_key==L && type == 0) || (down_key==R && type == 1)
            action(trial,1)=0;
        elseif (down_key==L && type == 1) || (down_key==R && type == 0)
            action(trial,1)=1;
        end

        if down_key == L
            Screen('DrawTexture', w, picL, [], Lpoint);
            Screen('DrawTexture', w, picR, [], Rpoint);
            Screen('FrameRect',w,chosen_color,Lchoice,10);
            Screen('FrameRect',w,white,Rchoice,10);

            Screen('Flip',w);

       elseif down_key == R

           Screen('DrawTexture', w, picL, [], Lpoint);
           Screen('DrawTexture', w, picR, [], Rpoint);
           Screen('FrameRect',w,chosen_color,Rchoice,10);
           Screen('FrameRect',w,white,Lchoice,10);

           Screen('Flip',w);
        end


        % second stage transition randomization

        % a is a Gaussian distribution from 0.4 - 1.0 (mean = 0.7).
        % r is a Guassian distribution from 0 - 1 (mean = 0.5).
        % this code basically says that when you choose A, go to state 2 70% of the time;
        % when you choose B, goes to state 2 30% of the time

        if action(trial,1) == 0
            if  r(trial, 1) < a(trial,1)
                state(trial,1) = 2;
            else state(trial,1) = 3;
            end
        else
            if  r(trial, 2) > a(trial,2)
                state(trial,1) = 2;
            else state(trial,1) = 3;
            end
        end



        WaitSecs(1);

        % state 2 (blue state) and 3 (purple state)



        if state(trial,1) == 2


            % Fixation screen
            Screen(w, 'FillRect', black);
            Screen('TextSize', w, 60);
            DrawFormattedText(w, '+', 'center', 'center', white);
            Screen(w, 'Flip');
            WaitSecs(.5);

            %choice screen
            Screen(w, 'FillRect', black);

            position(trial,2) = round(rand); %randomizing images positions
            type = position(trial,2);


            picL = drawimage(type,2);
            picR = drawimage(1-type,2);


            Screen('DrawTexture', w, picL, [], Lpoint);
            Screen('DrawTexture', w, picR, [], Rpoint);
            Screen('FrameRect',w,white,Lchoice,10); % outline the stimuli with white box
            Screen('FrameRect',w,white,Rchoice,10);
            Screen('Flip', w);

            choice_on_time(trial,2) = GetSecs - t0;

            key_is_down = 0;
            FlushEvents;
            oldenablekeys = RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(-3);
            end

            choice_off_time(trial,2) = GetSecs - t0;

            down_key = find(key_code,1);

            if (down_key==L && type == 0) || (down_key==R && type == 1)
                action(trial,2)=0;
                if payoff_det(trial, 1) <  payoff_prob(trial,1)
                    payoff(trial,1) = 1;
                else payoff(trial,1) = 0;
                end
            elseif (down_key==L && type == 1) || (down_key==R && type == 0)
                action(trial,2)=1;
                if payoff_det(trial, 2) <  payoff_prob(trial,2)
                    payoff(trial,1) = 1;
                else payoff(trial,1) = 0;
                end
            end

            if down_key == L
                Screen('DrawTexture', w, picL, [], Lpoint);
                Screen('DrawTexture', w, picR, [], Rpoint);
                Screen('FrameRect',w,chosen_color,Lchoice,10);
                Screen('FrameRect',w,white,Rchoice,10);
                Screen('Flip',w);
               WaitSecs(0.5);
           elseif down_key == R
               Screen('DrawTexture', w, picL, [], Lpoint);
               Screen('DrawTexture', w, picR, [], Rpoint);
               Screen('FrameRect',w,chosen_color,Rchoice,10);
               Screen('FrameRect',w,white,Lchoice,10);
               Screen('Flip',w);
               WaitSecs(0.5);
           end


            % choice - payoff screen

            % separate reward statements depending on block
            if block == 0
                reward = 'Win!';
                noreward = 'Try again';
            elseif block == 1
                reward = '+10 cents';
                noreward = '0 cents';
            else
                reward = 'Take one bite of a snack';
                noreward = 'Try again';
            end

            picD = drawimage(action(trial,2),2);
            Screen('DrawTexture', w, picD, [], Mpoint);
            if payoff(trial,1) == 1
                DrawFormattedText(w, reward, 'center', rect(4)*0.8, white);
            else
                DrawFormattedText(w, noreward, 'center', rect(4)*0.8, white);
            end

            Screen('Flip', w);
            WaitSecs(1);


        else

             % Fixation screen
            Screen(w, 'FillRect', black);
            Screen('TextSize', w, 60);
            DrawFormattedText(w, '+', 'center', 'center', white);
            Screen(w, 'Flip');
            WaitSecs(.5);

            %choice screen

            Screen(w, 'FillRect', black);

            position(trial,3) = round(rand); %randomizing images positions
            type = position(trial,3);

            picL = drawimage(type,3);
            picR = drawimage(1-type,3);


            Screen('DrawTexture', w, picL, [], Lpoint);
            Screen('DrawTexture', w, picR, [], Rpoint);
            Screen('FrameRect',w,white,Lchoice,10); % outline stimuli with white box
            Screen('FrameRect',w,white,Rchoice,10);
            Screen('Flip', w);

            choice_on_time(trial,3) = GetSecs - t0;

            key_is_down = 0;
            FlushEvents;
            oldenablekeys = RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(-3);
            end

            choice_off_time(trial,3) = GetSecs - t0;

            down_key = find(key_code,1);

            if (down_key==L && type == 0) || (down_key==R && type == 1)
                action(trial,3)=0;
                if payoff_det(trial, 3) <  payoff_prob(trial,3)
                    payoff(trial,2) = 1;
                else payoff(trial,2) = 0;
                end
            elseif (down_key==L && type == 1) || (down_key==R && type == 0)
                action(trial,3)=1;
                if payoff_det(trial, 4) <  payoff_prob(trial,4)
                    payoff(trial,2) = 1;
                else payoff(trial,2) = 0;
                end
            end

            if down_key == L
                Screen('DrawTexture', w, picL, [], Lpoint);
                Screen('DrawTexture', w, picR, [], Rpoint);
                Screen('FrameRect',w,chosen_color,Lchoice,10);
                Screen('FrameRect',w,white,Rchoice,10);

                Screen('Flip',w);
                WaitSecs(0.5);
           elseif down_key == R
               Screen('DrawTexture', w, picL, [], Lpoint);
               Screen('DrawTexture', w, picR, [], Rpoint);
               Screen('FrameRect',w,chosen_color,Rchoice,10);
               Screen('FrameRect',w,white,Lchoice,10);

               Screen('Flip',w);
               WaitSecs(0.5);
           end

           % separate reward statements depending on block
           if block == 0
               reward = 'Win!';
               noreward = 'Try again';
           elseif block == 1
               reward = '+10 cents';
               noreward = '0 cents';
           else
               reward = 'Take one bite of a snack';
               noreward = 'Try again';
           end

            picD = drawimage(action(trial,3),3);
            Screen('DrawTexture', w, picD, [], Mpoint);
            if payoff(trial,2) == 1
                DrawFormattedText(w, reward, 'center', rect(4)*0.8, white);
            else
                DrawFormattedText(w, noreward, 'center', rect(4)*0.8, white);
            end

            Screen('Flip', w);
            WaitSecs(1);



        end

        for i = 1:4
            payoff_prob(trial+1,i) = payoff_prob(trial,i) + 0.025*randn;
            if (payoff_prob(trial+1,i) < 0.25) || (payoff_prob(trial+1,i) > 0.75)
                payoff_prob(trial+1,i) = payoff_prob(trial,i);
            end
        end


    end

    RestrictKeysForKbCheck([]);

    %saving data
    task_data = struct;
    task_data.rng_seed = rng_seed;
    task_data.subject = sub; %*ones(trials,1);
    task_data.stim_color_step1 = stim_color_step1(block+1); % stimuli are always selected where 1st item in array goes to practice, then money, then food
    task_data.stim_colors_step2 = stim_colors_step2(block+1);

    if block == 0
        task_data.stim_symbol = stim_prac_symbol;
    elseif block == 1 % first 6 symbols always go to money block
        task_data.stim_symbol = stim_symbol(1:6);
    else % second 6 symbols in the arrary always go to food block
        task_data.stim_symbol = stim_symbol(7:12);
    end

    task_data.position = position;
    task_data.action = action;
    task_data.on = choice_on_time;
    task_data.off = choice_off_time;
    task_data.rt = choice_off_time-choice_on_time;
    task_data.transition_prob = a;
    task_data.transition_det = r;
    task_data.payoff_prob = payoff_prob;
    task_data.payoff_det = payoff_det;
    task_data.payoff = payoff;
    task_data.state = state;

    save(results_file_name, 'task_data', '-v6');

    % Payoff screen
    payoff_sum = sum(nansum(payoff))/10;

    if block == 0 % practice
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, 30);
        DrawFormattedText(w, 'You have completed the practice round.', 'center', 'center', white);
        DrawFormattedText(w, 'Press c to continue to the experiment', 'center', rect(4)*0.8, white);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              sca; return
          elseif keyIsDown && any(keyCode(continueKeys))
              break
          end
        end

    elseif block == 1 % money block
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, 30);
        DrawFormattedText(w, 'This part of the experiment is complete. You earned:', 'center', 'center', white);
        DrawFormattedText(w,  ['$' sprintf('%.2f', payoff_sum)], 'center', rect(4)*0.6, white);
        DrawFormattedText(w, 'Press c to continue to the next part', 'center', rect(4)*0.8, white);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              sca; return
          elseif keyIsDown && any(keyCode(continueKeys))
              break
          end
        end

    elseif block == 2 % food block
        Screen(w, 'FillRect', black);
        Screen('TextSize', w, 30);
        DrawFormattedText(w, ['This part of the experiment is complete.' '\n\n'...
          'Press c to contine to the next part.'], 'center', 'center', white);
        Screen(w, 'Flip');
        WaitSecs(1);

        while 1 %wait for response and allow exit if necessesary
          [keyIsDown, ~, keyCode] = KbCheck;
          if keyIsDown && any(keyCode(exitKeys))
              sca; return
          elseif keyIsDown && any(keyCode(continueKeys))
              break
          end
        end

    end

    if block == 1
       pay = 7 + payoff_sum; % base pay for my task is $7
    end

%     Screen('Close',w);
     Screen('CloseAll');
    FlushEvents;
%   jheapcl; ALTERED FOR DEBUGGING; THIS FUNCTION HELPS PREVENT MEMORY
%   EXCEPTIOINS

end
