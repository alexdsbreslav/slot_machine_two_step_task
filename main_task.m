% This bulk of this task code was written by Arkady Konovalov, PhD (University of Zurich) and generously shared on request.
% I have altered the code for my purposes

function main_task(trials,track, block)

    track = 0;

    global w rect A1 B1 A2 B2 A3 B3 sub pay

    % some setups
    Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
    FlushEvents;
    %HideCursor; %ALTERED FOR DEBUGGING
    PsychDefaultSetup(1);


    % check block
     if block == 0
         results_file_name = ['sub' num2str(sub) '_practice'];
     elseif block == 1
         results_file_name = ['sub' num2str(sub) '_money'];
     else
         results_file_name = ['sub' num2str(sub) '_food'];
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


    % loading images
    if block == 0
        A1 = imread('1AP.png','png');
        B1 = imread('1BP.png','png');

        A2 = imread('2AP.png','png');
        B2 = imread('2BP.png','png');

        A3 = imread('3AP.png','png');
        B3 = imread('3BP.png','png');

    else
        A1 = imread('1A.png','png');
        B1 = imread('1B.png','png');

        A2 = imread('2A.png','png');
        B2 = imread('2B.png','png');

        A3 = imread('3A.png','png');
        B3 = imread('3B.png','png');
    end

    % Keyboard
    KbName('UnifyKeyNames');
    L = KbName('LeftArrow');
    R = KbName('RightArrow');
    exitKeys = KbName({'e', 'E'});
    spaceKey = KbName('space');
    startFirstKeys = KbName({'b', 'B'});
    continueKeys = KbName({'c', 'C'})

    % Variables



    a = 0.4 + 0.6.*rand(trials,2); %transition probabilities

    % colors
    gray = 150;
    black = 0;
    white = 255;
    brown = [102,51,0];

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
    payoff = NaN(trials,2);

    %status = Eyelink('initialize');

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

    %TRACKING


%      el = EyelinkInitDefaults(w);
%      EyelinkInit(0);
%     Screen('FillRect', w, gray);
%     Screen('Flip', w);



    %Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA');
%     if practice == 1
%     etfilename = ['edata' num2str(sub)  'p.edf'];
%     else
%         etfilename = ['edata' num2str(sub) num2str(bars) '.edf'];
%     end
%     et_on_time = NaN(trials,1);
%     et_off_time = NaN(trials,1);
%
%     createFile=1;
%
%      if createFile
%         status=Eyelink('OpenFile',etfilename);
%         if status~=0
%             error('openfile error, status: ',status)
%         end
%      end
%
%     if practice == 0
%         if bars == 0
%             EyelinkDoTrackerSetup(el);
%         end
%     end
    %EyelinkDoDriftCorrection(el);

    Screen('CloseAll');



    Screen('Preference', 'SkipSyncTests', 1); % ALTERED FOR DEBUGGING
    %HideCursor; ALTERED FOR DEBUGGING

    WaitSecs(0.1);

    [w, rect] = Screen('OpenWindow', whichScreen, 0,[], 32, ...
        doublebuffer+1,[],[],kPsychNeedFastBackingStore);

%     Eyelink('startrecording');
%     evt = Eyelink('NewestFloatSample');
%     et0 = evt.time;


    % Trial loop

    t0 = GetSecs;

%     eye_used = Eyelink('eyeavailable'); % get eye that's tracked

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

%         if track == 1
%         %the following section gets eyeposition data from the eye
%             %tracker and makes the subject stare at the cross for 2 s
%             timeonfix=0;
%             fixstart=GetSecs;
%             while timeonfix<1
%                 evt = Eyelink('NewestFloatSample');
%                 mx = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array (Why?)
%                 my = evt.gy(eye_used+1);
%
%                 if mx<0.4*rect(3) || mx>0.6*rect(3) || my<0.35*rect(4) || my>0.65*rect(4)
%                     fixstart = GetSecs;
%                 end
%
%                 timeonfix=GetSecs-fixstart;
%             end
%         else
          WaitSecs(1);
%         end

        % Draw indicators

        Screen(w, 'FillRect', black);


        position(trial,1) = round(rand); %randomizing images positions

        type = position(trial,1);

        % Draw stimuli


        picL = drawimage(type,1);
        picR = drawimage(1-type,1);

        Screen('DrawTexture', w, picL, [], Lpoint);
        Screen('DrawTexture', w, picR, [], Rpoint);
        Screen('Flip', w);


        choice_on_time(trial,1) = GetSecs - t0;
%         evt = Eyelink('newestfloatsample');
%         et_on_time(trial,1) = evt.time - et0;

        key_is_down = 0;
        FlushEvents;
        [key_is_down, secs, key_code] = KbCheck;

        while key_code(L) == 0 && key_code(R) == 0
                [key_is_down, secs, key_code] = KbCheck;
        end

        choice_off_time(trial,1) = GetSecs - t0;
%         evt = Eyelink('newestfloatsample');
%         et_off_time(trial,1) = evt.time - et0;
        down_key = find(key_code,1);

        if (down_key==L && type == 0) || (down_key==R && type == 1)
            action(trial,1)=0;
        elseif (down_key==L && type == 1) || (down_key==R && type == 0)
            action(trial,1)=1;
        end

        if down_key == L
            Screen('DrawTexture', w, picL, [], Lpoint);
            Screen('DrawTexture', w, picR, [], Rpoint);
            Screen('FrameRect',w,white,Lchoice);
            Screen('Flip',w);

       elseif down_key == R

           Screen('DrawTexture', w, picL, [], Lpoint);
           Screen('DrawTexture', w, picR, [], Rpoint);
           Screen('FrameRect',w,white,Rchoice);
           Screen('Flip',w);
        end


        % second stage transition randomization

        r = rand;
        if action(trial,1) == 0
            if  r < a(trial,1)
                state(trial,1) = 2;
            else state(trial,1) = 3;
            end
        else
            if  r > a(trial,2)
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

%             if track == 1
%             %the following section gets eyeposition data from the eye
%                 %tracker and makes the subject stare at the cross for 2 s
%                 timeonfix=0;
%                 fixstart=GetSecs;
%                 while timeonfix<1
%                     evt = Eyelink('NewestFloatSample');
%                     mx = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array (Why?)
%                     my = evt.gy(eye_used+1);
%
%                     if mx<0.4*rect(3) || mx>0.6*rect(3) || my<0.35*rect(4) || my>0.65*rect(4)
%                         fixstart = GetSecs;
%                     end
%
%                     timeonfix=GetSecs-fixstart;
%                 end
%             else
                WaitSecs(1);
%             end

            %choice screen
            Screen(w, 'FillRect', black);

            position(trial,2) = round(rand); %randomizing images positions
            type = position(trial,2);


            picL = drawimage(type,2);
            picR = drawimage(1-type,2);


            Screen('DrawTexture', w, picL, [], Lpoint);
            Screen('DrawTexture', w, picR, [], Rpoint);
            Screen('Flip', w);

            choice_on_time(trial,2) = GetSecs - t0;
%             evt = Eyelink('newestfloatsample');
%             et_on_time(trial,2) = evt.time - et0;

            key_is_down = 0;
            FlushEvents;
            oldenablekeys = RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(-3);
            end

            choice_off_time(trial,2) = GetSecs - t0;
%             evt = Eyelink('newestfloatsample');
%             et_off_time(trial,2) = evt.time - et0;
%
            down_key = find(key_code,1);

            if (down_key==L && type == 0) || (down_key==R && type == 1)
                action(trial,2)=0;
                if rand <  payoff_prob(trial,1)
                    payoff(trial,1) = 1;
                else payoff(trial,1) = 0;
                end
            elseif (down_key==L && type == 1) || (down_key==R && type == 0)
                action(trial,2)=1;
                if rand <  payoff_prob(trial,2)
                    payoff(trial,1) = 1;
                else payoff(trial,1) = 0;
                end
            end

            if down_key == L
                Screen('DrawTexture', w, picL, [], Lpoint);
                Screen('DrawTexture', w, picR, [], Rpoint);
                Screen('FrameRect',w,white,Lchoice);
                Screen('Flip',w);
               WaitSecs(0.5);
           elseif down_key == R
               Screen('DrawTexture', w, picL, [], Lpoint);
               Screen('DrawTexture', w, picR, [], Rpoint);
               Screen('FrameRect',w,white,Rchoice);
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

%             if track == 1
%             %the following section gets eyeposition data from the eye
%                 %tracker and makes the subject stare at the cross for 2 s
%                 timeonfix=0;
%                 fixstart=GetSecs;
%                 while timeonfix<1
%                     evt = Eyelink('NewestFloatSample');
%                     mx = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array (Why?)
%                     my = evt.gy(eye_used+1);
%
%                     if mx<0.4*rect(3) || mx>0.6*rect(3) || my<0.35*rect(4) || my>0.65*rect(4)
%                         fixstart = GetSecs;
%                     end
%
%                     timeonfix=GetSecs-fixstart;
%                 end
%             else
                 WaitSecs(1);
%             end

            %choice screen

            Screen(w, 'FillRect', black);

            position(trial,3) = round(rand); %randomizing images positions
            type = position(trial,3);

            picL = drawimage(type,3);
            picR = drawimage(1-type,3);


            Screen('DrawTexture', w, picL, [], Lpoint);
            Screen('DrawTexture', w, picR, [], Rpoint);
            Screen('Flip', w);

            choice_on_time(trial,3) = GetSecs - t0;
%             evt = Eyelink('newestfloatsample');
%             et_on_time(trial,3) = evt.time - et0;

            key_is_down = 0;
            FlushEvents;
            oldenablekeys = RestrictKeysForKbCheck([L,R]);

            while key_is_down==0
                    [key_is_down, secs, key_code] = KbCheck(-3);
            end

            choice_off_time(trial,3) = GetSecs - t0;
%             evt = Eyelink('newestfloatsample');
%             et_off_time(trial,3) = evt.time - et0;
%
            down_key = find(key_code,1);

            if (down_key==L && type == 0) || (down_key==R && type == 1)
                action(trial,3)=0;
                if rand <  payoff_prob(trial,3)
                    payoff(trial,2) = 1;
                else payoff(trial,2) = 0;
                end
            elseif (down_key==L && type == 1) || (down_key==R && type == 0)
                action(trial,3)=1;
                if rand <  payoff_prob(trial,4)
                    payoff(trial,2) = 1;
                else payoff(trial,2) = 0;
                end
            end

            if down_key == L
                Screen('DrawTexture', w, picL, [], Lpoint);
                Screen('DrawTexture', w, picR, [], Rpoint);
                Screen('FrameRect',w,white,Lchoice);
                Screen('Flip',w);
                WaitSecs(0.5);
           elseif down_key == R
               Screen('DrawTexture', w, picL, [], Lpoint);
               Screen('DrawTexture', w, picR, [], Rpoint);
               Screen('FrameRect',w,white,Rchoice);
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
    two_stage_task_data = struct;
    two_stage_task_data.subject = sub; %*ones(trials,1);
    two_stage_task_data.position = position;
    two_stage_task_data.action = action;
    two_stage_task_data.on = choice_on_time;
    two_stage_task_data.off = choice_off_time;
%     two_stage_task_data.eton = et_on_time;
%     two_stage_task_data.etoff = et_off_time;
    two_stage_task_data.rt = choice_off_time-choice_on_time;
    two_stage_task_data.transition_prob = a;
    two_stage_task_data.payoff_prob = payoff_prob;
    two_stage_task_data.payoff = payoff;
    two_stage_task_data.state = state;
%   two_stage_task_data.et0 = et0; ALTERED FOR DEBUGGING; I THINK THIS IS A
%   TRACKING VARIABLE
    save(results_file_name, 'two_stage_task_data', '-v6');

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%turn off eyetracking
%         Eyelink('stoprecording');
%
%
%     Eyelink('closefile');
%     status = Eyelink('receivefile',etfilename);
%     Eyelink('shutdown');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
