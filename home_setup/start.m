% The code that this is based on was initially written for Konovalov (2016) Nature Communications.
% The original code was shared with me and I have maintained some of the basic structure
% and notation; however, I have substantially altered the code for my own purposes.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function start

% clear everything from the workspace; everything is saved in the initialization_struct
Screen('CloseAll');
FlushEvents;

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% ---- Flexible parameters that need to be checked
% ---- Task specificiations
num_trials_practice = 1;
num_trials_main_task = 5;

length_of_reward_feedback_screen = 4;

% ---- File specifications
file_root = '/Users/alex/OneDrive - Duke University/1. Research Projects/1. Huettel/17.09_MDT/6. Raw Data/MatLab'; % for Alex's computer
% file_root = '\Users\ads48\Documents\Projects\18.08.07_MDT\raw_data\matlab'; % for the eye-tracker
sl = '/'; % for OSX
% sl = '\'; % for Windows

% ---- Text formatting specifications
textsize_directions = 30;
textsize_allergy_wanting_rateGuide = 20;
textsize_fixcross = 40;
textsize_countdown = 20;

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

sub = input('Subject number: '); %keep sub number as a string so we can validate easily below

% create subject folder in the raw data folder
filename_subnum = pad(num2str(sub), 3, 'left', '0');
data_file_path = [file_root sl 'sub' filename_subnum];
[~, msg, ~] = mkdir(data_file_path);

folder_already_exists = strcmp(msg, 'Directory already exists.');

if folder_already_exists
   sub_exists = input(['\n\n' ...
   'Subject' filename_subnum ' already exists. Do you want to enter a new subject number?' '\n\n' ...
     '1 = Yes, I''ll restart and enter a new subject number.' '\n' ...
     '0 = No, I need to alter this subject''s data' '\n' ...
     'Response: ' ]);

     if ~ismember(sub_exists, [0 1])
       disp('Invalid entry, please try again.')
       sca; return
     end
else
   sub_exists = 99;
end


if sub_exists == 1
   disp([ fprintf('\n') ...
   'OK, you should restart the function to try again'])
   sca; return

elseif sub_exists == 0
    load([data_file_path sl 'initialization structure.mat']);
    if initialization_struct.block(2) == 1
        block1_text = 'Money';
        block2_text = 'Food';
    else
        block1_text = 'Food';
        block2_text = 'Money';
    end

    disp([fprintf('\n\n\n\n') ...
    'The following files already exist: ' ls(data_file_path)]);

    start_where = input(['What block do you want to start on?' '\n' ...
    'You will overwrite any existing data on and after the block you choose.' '\n\n' ...
    '0 = CANCEL and restart the function' '\n' ...
    '1 = Allergy & Wanting Questionnaire' '\n' ...
    '2 = Tutorial' '\n' ...
    '3 = Practice Rounds' '\n' ...
    '4 = Block 1 (' block1_text ')' '\n' ...
    '5 = Block 2 (' block2_text ')' '\n' ...
    'Response: ']);

    if ~ismember(start_where, [0 1 2 3 4 5])
      disp('Invalid entry, please try again.')
      sca; return
    end

    if start_where == 0
       disp([fprintf('\n') ...
       'OK, you should restart the function to try again'])
       sca; return
    end

else
    start_where = 1;
    % shuffle the rng and save the seed
    rng('shuffle');
    init_rng_seed = rng;
    init_rng_seed = init_rng_seed.Seed;

    % create stimuli structure
    initialization_struct = struct;
    initialization_struct.sub = sub; % save the subject number into the structure
    initialization_struct.data_file_path = data_file_path; % save the data file path as well
    initialization_struct.rng_seed = init_rng_seed; % save the rng seed for the initialization structure

    % stimuli sets
    symbols = {'b', 'e', 'i', 'inf', 'l', 'n', 'o', 'r', 'ri', 'to', 'u', 'w'};
    prac_symbols = {'4pt', '5pt', 'bolt', 'cir', 'pent', 'tri'};
    step1_colors = {'white', 'grey', 'dark_grey'};
    step2_color_pairs = {'red_blue', 'orange_purple', 'yellow_green'};
    step2_color = {'warm', 'cool'};

    % create shuffled arrays of each of the symbols and colors
    initialization_struct.stim_color_step1 = step1_colors(randperm(numel(step1_colors)));
    initialization_struct.stim_colors_step2 = step2_color_pairs(randperm(numel(step2_color_pairs)));
    initialization_struct.stim_step2_color_select = step2_color(randperm(numel(step2_color)));
    initialization_struct.stim_prac_symbol = prac_symbols(randperm(numel(prac_symbols)));
    initialization_struct.stim_symbol = symbols(randperm(numel(symbols)));

    % randomize the block order for the food and money blocks
    block = randi([1,2]);
    initialization_struct.block = [0 block 3-block];

    % randomize the location of the foods
    sweet_loc_left = randi([0,1]);
    initialization_struct.sweet_loc_left = sweet_loc_left;

    % input the number of trials per block; 1 = practice trials, 2 = experimental blocks
    initialization_struct.num_trials = [num_trials_practice num_trials_main_task];

    % set the reward_feedback_len
    initialization_struct.reward_feedback_len = length_of_reward_feedback_screen;

    % set the file root and backslash vs. forwardslash convention
    initialization_struct.file_root = file_root;
    initialization_struct.slash_convention = sl;

    % set the text formatting specs
    initialization_struct.textsize_directions = textsize_directions;
    initialization_struct.textsize_allergy_wanting_rateGuide = textsize_allergy_wanting_rateGuide;
    initialization_struct.textsize_fixcross = textsize_fixcross;
    initialization_struct.textsize_countdown = textsize_countdown;

    save([data_file_path sl 'initialization structure'], 'initialization_struct', '-v6')
end

if start_where == 1
% ---- TASK
% ---- 1: Allergy & wanting
    [exit_flag, eligible, food_salt, food_sweet] = allergy_wanting(initialization_struct);

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end

    initialization_struct.eligible = eligible;
    initialization_struct.food_salt = food_salt;
    initialization_struct.food_sweet = food_sweet;

    if initialization_struct.sweet_loc_left == 1
        initialization_struct.left_food = initialization_struct.food_sweet{1}(7:end-4);
        initialization_struct.right_food = initialization_struct.food_salt{1}(6:end-4);
    else
        initialization_struct.right_food = initialization_struct.food_sweet{1}(7:end-4);
        initialization_struct.left_food = initialization_struct.food_salt{1}(6:end-4);
    end

    save([data_file_path sl 'initialization structure'], 'initialization_struct', '-v6')

    if eligible == 0
        sca; return
    end
end

if start_where <= 2
% ---- Select food by hand if necessary
    if isempty(initialization_struct.food_salt)
        img_files = dir(['food_images' sl '*.png']);
        img_file_names = {img_files(1:length(img_files)).name}';
        img_file_index = find(contains(img_file_names, 'salt'))';

        food_salt = input(['There is no salty food selected for this participant.' '\n' ...
        'Please select one of the following foods.' '\n\n' ...
        num2str(img_file_index(1)) ' = ' img_file_names{img_file_index(1)} '\n' ...
        num2str(img_file_index(2)) ' = ' img_file_names{img_file_index(2)} '\n' ...
        num2str(img_file_index(3)) ' = ' img_file_names{img_file_index(3)} '\n' ...
        num2str(img_file_index(4)) ' = ' img_file_names{img_file_index(4)} '\n' ...
        num2str(img_file_index(5)) ' = ' img_file_names{img_file_index(5)} '\n' ...
        'Response: ']);

        initialization_struct.food_salt = cellstr(img_file_names{food_salt});
        save([data_file_path sl 'initialization structure'], 'initialization_struct', '-v6')
    end

    if isempty(initialization_struct.food_sweet)
        img_files = dir(['food_images' sl '*.png']);
        img_file_names = {img_files(1:length(img_files)).name}';
        img_file_index = find(contains(img_file_names, 'sweet'))';

        food_sweet = input(['There is no sweet food selected for this participant.' '\n' ...
        'Please select one of the following foods.' '\n\n' ...
        num2str(img_file_index(1)) ' = ' img_file_names{img_file_index(1)} '\n' ...
        num2str(img_file_index(2)) ' = ' img_file_names{img_file_index(2)} '\n' ...
        num2str(img_file_index(3)) ' = ' img_file_names{img_file_index(3)} '\n' ...
        num2str(img_file_index(4)) ' = ' img_file_names{img_file_index(4)} '\n' ...
        num2str(img_file_index(5)) ' = ' img_file_names{img_file_index(5)} '\n' ...
        'Response: ']);

        initialization_struct.food_sweet = cellstr(img_file_names{food_sweet});
        save([data_file_path sl 'initialization structure'], 'initialization_struct', '-v6')
    end

% ---- 2: Tutorial
    exit_flag = tutorial_v4(initialization_struct);

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

if start_where <= 3
% ---- 3: practice trials (Block 0 in code)
    if exist([data_file_path sl 'tutorial_timing.mat']) == 2
        load([data_file_path sl 'tutorial_timing.mat'])
        exit_flag = main_task(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1), tutorial_timing_struct);
    else
        exit_flag = main_task(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1));
    end

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

if start_where <= 4
% ---- 4: Block 1 of the main experiment trials
% ---- space prepped?
    if initialization_struct.block(2) == 1
        reward_bowl_prep = input(['\n\n' ...
          'Money Block' '\n' ...
          'Prepare the space for the money block' '\n\n' ...
          '1 = Everything is set up; continue.' '\n' ...
          '0 = I need to fix something; exit the script.' '\n' ...
          'Response: ' ]);
    else
        reward_bowl_prep = input(['\n\n' ...
          'Food Block' '\n' ...
          'Left Food = ' left_food '\n'...
          'Right Food = ' right_food '\n\n' ...
          '1 = Everything is set up; continue.' '\n' ...
          '0 = I need to fix something; exit the script.' '\n' ...
          'Response: ' ]);
    end

    if ~ismember(reward_bowl_prep, [0 1])
        disp('Invalid entry, please try again.')
        sca; return
    elseif reward_bowl_prep == 0
        disp([fprintf('\n') ...
        'OK, you should restart the function to try again'])
        sca; return
    end

% ---- eyetracker ready?
    eyetrack_ready = input(['\n\n' ...
      'Initialize the eye-tracker.' '\n' ...
      '1 = Everything is set up; continue.' '\n' ...
      '0 = I need to fix something; exit the script' '\n' ...
      'Response: ' ]);

      if ~ismember(eyetrack_ready, [0 1])
          disp('Invalid entry, please try again.')
          sca; return
      elseif eyetrack_ready == 0
          disp([fprintf('\n') ...
          'OK, you should restart the function to try again'])
          sca; return
      end

% --- camera on?
    camera_on = input(['\n\n' ...
      'Before the task begins, ensure that the camera is on,' '\n' ...
      'and that the software is recording!' '\n\n' ...
      '1 = I am recording. The camera''s blue light is on; the recording timer has started.' '\n' ...
      '0 = Something may not be working, exit the script so I can double check.' '\n' ...
      'Response: ' ]);

    if ~ismember(camera_on, [0 1])
        disp('Invalid entry, please try again.')
        sca; return
    elseif camera_on == 0
        disp([fprintf('\n') ...
        'OK, you should restart the function to try again'])
        sca; return
    end

% --- run the task
    exit_flag = main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

if start_where <= 5
% ---- 5: Block 3 of the main experiment trials
% ---- space prepped?
    if initialization_struct.block(3) == 1
        reward_bowl_prep = input(['\n\n' ...
          'Money Block' '\n' ...
          'Prepare the space for the money block' '\n\n' ...
          '1 = Everything is set up; continue.' '\n' ...
          '0 = I need to fix something; exit the script.' '\n' ...
          'Response: ' ]);
    else
        reward_bowl_prep = input(['\n\n' ...
          'Food Block' '\n' ...
          'Left Food = ' initialization_struct.left_food '\n'...
          'Right Food = ' initialization_struct.right_food '\n\n' ...
          '1 = Everything is set up; continue.' '\n' ...
          '0 = I need to fix something; exit the script.' '\n' ...
          'Response: ' ]);
    end

    if ~ismember(reward_bowl_prep, [0 1])
        disp('Invalid entry, please try again.')
        sca; return
    elseif reward_bowl_prep == 0
        disp([fprintf('\n') ...
        'OK, you should restart the function to try again'])
        sca; return
    end

    % ---- eyetracker ready?
    eyetrack_ready = input(['\n\n' ...
      'Initialize the eye-tracker.' '\n' ...
      '1 = Everything is set up; continue.' '\n' ...
      '0 = I need to fix something; exit the script' '\n' ...
      'Response: ' ]);

      if ~ismember(eyetrack_ready,[0 1])
          disp('Invalid entry, please try again.')
          sca; return
      elseif eyetrack_ready == 0
          disp([fprintf('\n') ...
          'OK, you should restart the function to try again'])
          sca; return
      end

    % --- camera on?
    camera_on = input(['\n\n' ...
      'Before the task begins, ensure that the camera is on,' '\n' ...
      'and that the software is recording!' '\n\n' ...
      '1 = I am recording. The camera''s blue light is on; the recording timer has started.' '\n' ...
      '0 = Something may not be working, exit the script so I can double check.' '\n' ...
      'Response: ' ]);

    if ~ismember(camera_on, [0 1])
        disp('Invalid entry, please try again.')
        sca; return
    elseif camera_on == 0
        disp([fprintf('\n') ...
        'OK, you should restart the function to try again'])
        sca; return
    end

    % --- run the task
    exit_flag = main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(3));

    if exit_flag == 1
        disp('The script was exited because ESCAPE was pressed')
        sca; return
    end
end

% --- display winnings
load([data_file_path sl 'money.mat']);
fprintf('\n\n\n\n\n\n\n\n\n\nThe participant earned $ %.2f during the money rounds', money_struct.payoff_sum);
fprintf('\nRound up to the nearest dollar and pay them (show up fee included) = $ %.2f', money_struct.payoff_total);

end