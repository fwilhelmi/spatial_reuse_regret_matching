clear all
clc

% Define the main folder
mainFolders = {'simulation_results/sce1_strong_equilibrium', 'simulation_results/sce2_weak_equilibrium'};

% Define the approaches under study
approaches = {'static', 'egreedy', 'regret_matching'};

% Initialize variables to store throughput values
throughputA = [];
throughputB = [];

% Loop through each subfolder
for j = 1 : length(mainFolders)
    for i = 1:length(approaches)
        folderPath = [mainFolders{j} '\' approaches{i}];
        filePath = fullfile(folderPath, 'output_test.txt');    
        % Check if the file exists
        if isfile(filePath)
            % Read the file content
            fileContent = fileread(filePath);        
            % Get values from file based on patterns
            tokens = regexp(fileContent, '{([\d\.]+),([\d\.]+)}', 'tokens', 'once');        
            % Extract values from tokens
            throughputA(j, i) = str2double(tokens{1});
            throughputB(j, i) = str2double(tokens{2});
            meanThroughput(j,i) = mean([throughputA(j, i) throughputB(j, i)]);
        end
    end
end

% Calculate average and aggregate throughput
averageThroughput = mean([throughputA; throughputB]);
aggregateThroughput = sum([throughputA; throughputB]);

% Prepare data for plotting
approaches = {'static', 'e-greedy', 'regret-matching'};
scenarios = {'Strong equilibrium', 'Weak equilibrium'};

% Create a bar plot to compare average and aggregate throughput
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
figure;
bar(meanThroughput, 'grouped', 'Interpreter', 'latex');
set(gca, 'XTickLabel', scenarios);
ylabel('Throughput (Mbps)', 'Interpreter', 'latex');
%title('Throughput Comparison of AP A and AP B');
lgnd = legend({'Static', '$\varepsilon$-greedy', 'Regret-matching'}, 'Interpreter', 'latex');
set(gca, 'fontsize', 15)
grid on;
grid minor;

%saveas(gca, 'file.pdf');
