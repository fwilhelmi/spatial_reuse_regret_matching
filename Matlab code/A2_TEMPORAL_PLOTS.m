clear all
clc

% --- CONFIGURATION ---
% Define the folder structure
scenarios = {'sce1_strong_equilibrium', 'sce2_weak_equilibrium'};
mechanisms = {'static', 'egreedy', 'regret_matching'};

% Map file names to logical AP names
% File 1 -> AP_A, File 2 -> AP_B
logFiles = {'logs_output_TEST_SIM_A0_A.txt', 'logs_output_TEST_SIM_A1_B.txt'};
apNames = {'AP_A', 'AP_B'};

% Initialize master data structure
results = struct();

% --- PARSING LOOP ---
for s = 1 : length(scenarios)
    scenarioName = ['simulation_results/' scenarios{s}];
    
    for m = 1 : length(mechanisms)
        mechName = mechanisms{m};
        
        for f = 1 : length(logFiles)
            % Construct path: Scenario/Mechanism/File
            % Example: sce1_strong_equilibrium/static/logs_output_TEST_SIM_A0_A.txt
            currentFile = logFiles{f};
            currentAP = apNames{f};
            
            filePath = fullfile(scenarioName, mechName, currentFile);
            
            % Check if file exists before trying to read
            if isfile(filePath)
                fprintf('Parsing: %s ... ', filePath);
                
                % Read entire file content into a string
                fileContent = fileread(filePath);
                
                % --- REGEX EXTRACTION ---
                % We capture the number inside parenthesis or after the equals sign
                
                % 1. Action Index: "Action (3)"
                tokens_action = regexp(fileContent, 'Action \((\d+)\)', 'tokens');
                
                % 2. Average Throughput: "Average throughput = 123.456"
                tokens_thr = regexp(fileContent, 'Average throughput = ([\d\.]+)', 'tokens');
                
                % 3. Average Delay
                tokens_avgD = regexp(fileContent, 'Average delay = ([\d\.]+)', 'tokens');
                
                % 4. Maximum Delay
                tokens_maxD = regexp(fileContent, 'Maximum delay = ([\d\.]+)', 'tokens');
                
                % 5. Minimum Delay
                tokens_minD = regexp(fileContent, 'Minimum delay = ([\d\.]+)', 'tokens');
                
                % 6. Associated Reward (Includes '-' for negative rewards)
                tokens_reward = regexp(fileContent, 'Associated reward = ([\d\.\-]+)', 'tokens');
                
                % --- CONVERSION & STORAGE ---
                % Helper function to convert extracted tokens to numeric array
                % [tokens{:}] un-nests the cell array
                
                if ~isempty(tokens_action)
                    results.(scenarios{s}).(mechName).(currentAP).action = ...
                        str2double([tokens_action{:}]);
                        
                    results.(scenarios{s}).(mechName).(currentAP).throughput = ...
                        str2double([tokens_thr{:}]);
                        
                    results.(scenarios{s}).(mechName).(currentAP).avgDelay = ...
                        str2double([tokens_avgD{:}]);
                        
                    results.(scenarios{s}).(mechName).(currentAP).maxDelay = ...
                        str2double([tokens_maxD{:}]);
                        
                    results.(scenarios{s}).(mechName).(currentAP).minDelay = ...
                        str2double([tokens_minD{:}]);
                        
                    results.(scenarios{s}).(mechName).(currentAP).reward = ...
                        str2double([tokens_reward{:}]);
                        
                    fprintf('Done. (%d iterations found)\n', length(tokens_action));
                else
                    fprintf('Warning: No data patterns found.\n');
                end
                
            else
                fprintf('Skipping: %s (File not found)\n', filePath);
            end
        end
    end
end

%% PLOT 1: Sce 1
dataEgreedyA = results.sce1_strong_equilibrium.egreedy.AP_A;
dataEgreedyB = results.sce1_strong_equilibrium.egreedy.AP_B;
dataRmA = results.sce1_strong_equilibrium.regret_matching.AP_A;
dataRmB = results.sce1_strong_equilibrium.regret_matching.AP_B;

figure;

subplot(2,2,1);
plot(dataEgreedyA.action, 'LineWidth', 2);
hold on
plot(dataEgreedyB.action, '--', 'LineWidth', 2);
%title('Action Selection over Time (Sce1 - e-greedy - AP A)');
ylabel('Action Index', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
xlabel('Iteration', 'Interpreter', 'latex');
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 12)

subplot(2,2,2);
plot(dataRmA.action, 'LineWidth', 2);
hold on
plot(dataRmB.action, '--', 'LineWidth', 2);
%title('Action Selection over Time (Sce1 - Regret Matching - AP A)');
ylabel('Action Index', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
xlabel('Iteration', 'Interpreter', 'latex');
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 12)

subplot(2,2,3);
plot(dataEgreedyA.throughput, 'LineWidth', 2);
hold on
plot(dataEgreedyB.throughput, '--', 'LineWidth', 2);
%title('Throughput Performance');
ylabel('Throughput (Mbps)', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');
grid on;
set(gca, 'fontsize', 12)

subplot(2,2,4);
plot(dataRmA.throughput, 'LineWidth', 2);
hold on
plot(dataRmB.throughput, '--', 'LineWidth', 2);
%title('Throughput Performance');
ylabel('Throughput (Mbps)', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');
grid on;
set(gca, 'fontsize', 12)

%% PLOT 2: Sce2
dataEgreedyA = results.sce2_weak_equilibrium.egreedy.AP_A;
dataEgreedyB = results.sce2_weak_equilibrium.egreedy.AP_B;
dataRmA = results.sce2_weak_equilibrium.regret_matching.AP_A;
dataRmB = results.sce2_weak_equilibrium.regret_matching.AP_B;

figure;

subplot(2,2,1);
plot(dataEgreedyA.action, 'LineWidth', 2);
hold on
plot(dataEgreedyB.action, '--', 'LineWidth', 2);
%title('Action Selection over Time (Sce1 - e-greedy - AP A)');
ylabel('Action Index', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
xlabel('Iteration', 'Interpreter', 'latex');
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 12)

subplot(2,2,2);
plot(dataRmA.action, 'LineWidth', 2);
hold on
plot(dataRmB.action, '--', 'LineWidth', 2);
%title('Action Selection over Time (Sce1 - Regret Matching - AP A)');
ylabel('Action Index', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
xlabel('Iteration', 'Interpreter', 'latex');
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 12)

subplot(2,2,3);
plot(dataEgreedyA.throughput, 'LineWidth', 2);
hold on
plot(dataEgreedyB.throughput, '--', 'LineWidth', 2);
%title('Throughput Performance');
ylabel('Throughput (Mbps)', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');
grid on;
set(gca, 'fontsize', 12)

subplot(2,2,4);
plot(dataRmA.throughput, 'LineWidth', 2);
hold on
plot(dataRmB.throughput, '--', 'LineWidth', 2);
%title('Throughput Performance');
ylabel('Throughput (Mbps)', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');
grid on;
set(gca, 'fontsize', 12)

%% PLOT 3: Both scenarios, only actions

rm_color_1 = [0.29,0.86,0.25];
rm_color_2 = [0.93,0.69,0.13];
eg_color_1 = [0.95,0.40,0.77];
eg_color_2 = [0.52,0.09,0.82];

dataEgreedyA_1 = results.sce1_strong_equilibrium.egreedy.AP_A;
dataEgreedyB_1 = results.sce1_strong_equilibrium.egreedy.AP_B;
dataRmA_1 = results.sce1_strong_equilibrium.regret_matching.AP_A;
dataRmB_1 = results.sce1_strong_equilibrium.regret_matching.AP_B;

dataEgreedyA_2 = results.sce2_weak_equilibrium.egreedy.AP_A;
dataEgreedyB_2 = results.sce2_weak_equilibrium.egreedy.AP_B;
dataRmA_2 = results.sce2_weak_equilibrium.regret_matching.AP_A;
dataRmB_2 = results.sce2_weak_equilibrium.regret_matching.AP_B;


figure('Position',[600 100 300 200]);
plot(dataEgreedyA_1.action, 'LineWidth', 2, 'Color', eg_color_1);
hold on
plot(dataEgreedyB_1.action, '--', 'LineWidth', 2, 'Color', eg_color_2);
%title('Action Selection over Time (Sce1 - e-greedy - AP A)');
ylabel('Action Index', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
xlabel('Iteration', 'Interpreter', 'latex');
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 15, 'TickLabelInterpreter', 'latex')
legend({'AP A', 'AP B'}, 'Interpreter', 'latex')
saveas(gca, 'fig2a_sce1_eg.fig');

figure('Position',[600 100 300 200]);
plot(dataRmA_1.action, 'LineWidth', 2, 'Color', rm_color_1);
hold on
plot(dataRmB_1.action, '--', 'LineWidth', 2, 'Color', rm_color_2);
%title('Action Selection over Time (Sce1 - Regret Matching - AP A)');
ylabel('Action Index', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
xlabel('Iteration', 'Interpreter', 'latex');
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 15, 'TickLabelInterpreter', 'latex')
legend({'AP A', 'AP B'}, 'Interpreter', 'latex')
saveas(gca, 'fig2b_sce1_rm.fig');

figure('Position',[600 100 300 200]);
plot(dataEgreedyA_2.action, 'LineWidth', 2, 'Color', eg_color_1);
hold on
plot(dataEgreedyB_2.action, '--', 'LineWidth', 2, 'Color', eg_color_2);
%title('Throughput Performance');
ylabel('Action Index', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 15, 'TickLabelInterpreter', 'latex')
legend({'AP A', 'AP B'}, 'Interpreter', 'latex')
saveas(gca, 'fig2c_sce2_eg.fig');

figure('Position',[600 100 300 200]);
plot(dataRmA_2.action, 'LineWidth', 2, 'Color', rm_color_1);
hold on
plot(dataRmB_2.action, '--', 'LineWidth', 2, 'Color', rm_color_2);
%title('Throughput Performance');
ylabel('Action Index', 'Interpreter', 'latex');
xlabel('Iteration', 'Interpreter', 'latex');
yticks(0:3)
yticklabels(1:4)
axis([0 400 -0.1 3.1])
grid on;
set(gca, 'fontsize', 15, 'TickLabelInterpreter', 'latex')
legend({'AP A', 'AP B'}, 'Interpreter', 'latex')
saveas(gca, 'fig2d_sce2_rm.fig');
