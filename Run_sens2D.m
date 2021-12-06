%=========================================================================%
% Routine Run_sens2D.m
% Created By: Danny Galvis, Darren Walsh, James Rankin
% This routine extracts % change in the error when individual parameters
% are increased/decreased. The change in error is compared to the best fit
% optimization found in parameters_best_final.mat


% Output: sensitive2D.mat in the result_files directory. These are 2D because
% the left and right endpoints P0->X and Pn-1->X are allowed to vary
% independently and sampling is done in for combinations of both values
% Output arrays:
% 1) sensitive2D - 4xptsxpts array 
% dimension 1: 4 entries [P0->P1, Pn-1->Pn] max_par(1)- max value sampled
%                        [P0->GA, Pn-1->GA] max_par(2)- " "
%                        [P0->A,  Pn-1->A]  max_par(3)- " "
%                        [P0->S,  Pn-1->S]  max_par(4)- " "
% dimension 2 and 3: linspace(0,max_par(1:4),pts) pts - 400 grid spacing
%                    dimension 2 P0->X
%                    dimension 3 Pn-1->X

% 2) curves_flats - 2xpts array. This is 1D for the parameters that do
% not occur across the 50 proliferative populations.
% dimension 1: 2 entries [GA->S] max_par(5)- max value sampled
%                        [A->D]  max_par(5)- " "
% dimension 2: linspace(0,max_par(5),pts) pts - 400 grid spacing

% 3) curves_fracs - 3xpts array. This is 1D for the parameters that do
% not occur across the 50 proliferative populations.
% dimension 1: 3 entries [P_in_H2AX] 
%                        [G in Ki67]  
%                        [G in H2AX]  
% dimension 2: linspace(0,1,pts) pts - 400 grid spacing

% THE RESULTS ARE IN % CHANGE OF ERROR_TOT FROM THE BASELINE BEST PARAMETER
% SET. IF  >100%, THE RESULT IS SET TO  100% TO MAKE THE IMAGES EASIER TO 
% INTERPRET

% Warning: These analysis takes a while to run
%=========================================================================%
%% Initialize the routine. Change inputs here
restoredefaultpath;clear;clc;
% Add paths to auxillary functions and parameter files
addpath('functions');addpath('result_files');

% Choose one of the optimized parameter sets
input_file = './result_files/my_run_of_authors/parameters_final4_ga.mat';
load comparison_data.mat;
%% Extract features for the baseline trajectories
load(input_file);
original_error = opt_fun(result,state_num,data);
pts = 400;
max_par = [0.05,0.05,0.01,0.01,0.05];%2*max(result(1:10));


%% Create Results for 2D sensitivity Pi -> X
sensitive2D = zeros(4,pts,pts);
count_pars = 1;
disp('I take a minute to run (but Im worth the wait)');
disp('This is an alternative way of looking at sensitivity')
disp('Could replace the bar charts?? This takes slope/intercept at the same time');

count = 1;
for pars = {[1,2],[3,4],[6,7],[8,9]}
    
    mp = max_par(count);
    
    disp([num2str(count_pars),' of ',num2str(size(sensitive2D,1))]);
    count_val1 = 1;
    for val1 = linspace(0,mp,pts)
        count_val2 = 1;
        for val2 = linspace(0,mp,pts)
            new_result = result;
            new_result(pars{1}(1)) = val1;
            new_result(pars{1}(2)) = val2;
             % Calculate the errors
            new_error = opt_fun(new_result,state_num,data);
            rel_error = 100*(new_error - original_error)/(original_error);           
            if rel_error > 100
                rel_error = 100;
            end
            sensitive2D(count_pars,count_val1,count_val2) = rel_error;
            count_val2 = count_val2 + 1;
        end
        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
    
    count = count + 1;
end

%% Produce Sensitive Flats A->D, Q->S,
sensitive_flats = zeros(2,pts);
count_pars = 1;
for pars = [5,10]
    disp([num2str(count_pars),' of ',num2str(size(sensitive_flats,1))]);
    count_val1 = 1;
    for val1 = linspace(0,max_par(count),pts)
        new_result = result;
        new_result(pars) = val1;
         % Calculate the errors
        new_error = opt_fun(new_result,state_num,data);
        rel_error = 100*(new_error - original_error)/(original_error);           

        sensitive_flats(count_pars,count_val1) = rel_error;

        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
end

%% Produce Sensitive Fracts P -> H2AX, Q->Ki67, Q -> H2AX
sensitive_fracs = zeros(3,pts);
count_pars = 1;

for pars = [11,12,13]
    disp([num2str(count_pars),' of ',num2str(size(sensitive_fracs,1))]);
    count_val1 = 1;
    for val1 = linspace(0,1,pts)
        new_result = result;
        new_result(pars) = val1;
         % Calculate the errors
        new_error = opt_fun(new_result,state_num,data);
        rel_error = 100*(new_error - original_error)/(original_error);           

        sensitive_fracs(count_pars,count_val1) = rel_error;

        count_val1 = count_val1 + 1;
    end
    count_pars = count_pars + 1;
end


%Save results
save('result_files/sensitive2D.mat','sensitive2D','sensitive_flats','sensitive_fracs','input_file','max_par');

 