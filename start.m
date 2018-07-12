% The bulk of this task code was written by Arkady Konovalov, PhD (University of Zurich)
% and generously shared on request. I have superficially altered the script to be amenable to
% multiple blocks with different reward structures.

% Please do not share or use this script without the permission of all invovled parties.

function start
    sub = input('Subject number: '); %keep sub number as a string so we can validate easily below

    % create subject folder in the raw data folder
    filename_subnum = pad(num2str(sub), 3, 'left', '0');
    data_file_path = ['/Users/alex/OneDrive - Duke University/1. Research Projects/1. Huettel/17.09_MDT/6. Raw Data/MatLab/sub' filename_subnum];
    [~, msg, ~] = mkdir(data_file_path);

    folder_already_exists = strcmp(msg, 'Directory already exists.');
    if folder_already_exists
       sub_exists = input(['\n\n' ...
       'Subject' filename_subnum ' already exists. Do you want to enter a new subject number?' '\n\n' ...
         '1 = Yes, I''ll restart and enter a new subject number.' '\n' ...
         '0 = No, I need to alter this subject''s data' '\n' ...
         'Response: ' ]);
    else
       sub_exists = 99;
    end

    switch sub_exists
        case 1
           disp([ fprintf('\n') ...
           'OK, you should restart the function to try again'])

        case 0
            disp([fprintf('\n\n\n\n') ...
            'The following files already exist: ' ls(data_file_path)]);

            start_where = input(['What block do you want to start on?' '\n' ...
            'You will overwrite any existing data on and after the block you choose.' '\n\n' ...
            '0 = CANCEL and restart the function' '\n' ...
            '1 = Tutorial' '\n' ...
            '2 = Practice Rounds' '\n' ...
            '3 = Block 1' '\n' ...
            '4 = Block 2' '\n' ...
            'Response: ']);

            load([data_file_path '/initialization structure.mat']);

            switch start_where
                case 99
                   disp([fprintf('\n') ...
                   'OK, you should restart the function to try again'])

                case 1
                % ---- TASK
                    % ---- 1: Tutorial
                        rng(66); % set the rng so everyone sees the same video
                        % tutorial_v4;

                    % ---- 2: practice trials (Block 0 in code)
                        rng(initialization_struct.rng_seed(2));
                        main_task(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1));

                    % ---- 3: Block 1 of the main experiment trials
                        rng(initialization_struct.rng_seed(3));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));

                    % ---- 4: Block 2 of the main experiment trials
                        rng(initialization_struct.rng_seed(4));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(3));

                    % --- display winnings
                        load([data_file_path '/money.mat']);
                        fprintf('\n\n\n\n\n\n\n\n\n\nYour total earnings (show up fee included) = $ %.2f\n\nThank you for your participation\n\n\n', task_data.payoff_total);
                case 2
                % ---- TASK
                    % ---- 2: practice trials (Block 0 in code)
                        rng(initialization_struct.rng_seed(2)); 
                        main_task(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1));

                    % ---- 3: Block 1 of the main experiment trials
                        rng(initialization_struct.rng_seed(3));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));

                    % ---- 4: Block 2 of the main experiment trials
                        rng(initialization_struct.rng_seed(4));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(3));

                    % --- display winnings
                        load([data_file_path '/money.mat']);
                        fprintf('\n\n\n\n\n\n\n\n\n\nYour total earnings (show up fee included) = $ %.2f\n\nThank you for your participation\n\n\n', task_data.payoff_total);
                case 3
                % ---- TASK
                    % ---- 3: Block 1 of the main experiment trials
                        rng(initialization_struct.rng_seed(3));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));

                    % ---- 4: Block 2 of the main experiment trials
                        rng(initialization_struct.rng_seed(4));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(3));

                    % --- display winnings
                        load([data_file_path '/money.mat']);
                        fprintf('\n\n\n\n\n\n\n\n\n\nYour total earnings (show up fee included) = $ %.2f\n\nThank you for your participation\n\n\n', task_data.payoff_total);
                case 4
                % ---- TASK
                    % ---- 4: Block 2 of the main experiment trials
                        rng(initialization_struct.rng_seed(4));
                        main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(3));

                    % --- display winnings
                        load([data_file_path '/money.mat']);
                        fprintf('\n\n\n\n\n\n\n\n\n\nYour total earnings (show up fee included) = $ %.2f\n\nThank you for your participation\n\n\n', task_data.payoff_total);
            end

        case 99
            % shuffle the rng and save the seed
            rng('shuffle');
            rng_seed = rng;
            rng_seed = rng_seed.Seed;
            rng_seed = [rng_seed rng_seed+1 rng_seed+2 rng_seed+3] % create 4 rng seeds, 1 used each for the initialization, practice, block1, and block2

            % create stimuli structure
            initialization_struct = struct;
            initialization_struct.sub = sub; % save the subject number into the structure
            initialization_struct.data_file_path = data_file_path; % save the data file path as well
            initialization_struct.rng_seed = rng_seed; % save the rng seeds

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
            block = randi([1,2])
            initialization_struct.block = [0 block 3-block];

            % input the number of trials per block; 1 = practice trials, 2 = experimental blocks
            initialization_struct.num_trials = [2 2];

            save([data_file_path '/initialization structure'], 'initialization_struct', '-v6')

    % ---- TASK
        % ---- 1: Tutorial
            rng(66); % set the rng so everyone sees the same video
            % tutorial_v4;

        % ---- 2: practice trials (Block 0 in code)
            rng(initialization_struct.rng_seed(2));
            main_task(initialization_struct, initialization_struct.num_trials(1), initialization_struct.block(1));

        % ---- 3: Block 1 of the main experiment trials
            rng(initialization_struct.rng_seed(3));
            main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(2));

        % ---- 4: Block 2 of the main experiment trials
            rng(initialization_struct.rng_seed(4));
            main_task(initialization_struct, initialization_struct.num_trials(2), initialization_struct.block(3));

        % --- display winnings
            load([data_file_path '/money.mat']);
            fprintf('\n\n\n\n\n\n\n\n\n\nYour total earnings (show up fee included) = $ %.2f\n\nThank you for your participation\n\n\n', task_data.payoff_total);

    end
end
