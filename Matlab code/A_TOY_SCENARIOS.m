% Define the main folder
mainFolders = {'sce1_strong_equilibrium', 'sce2_weak_equilibrium'};

approaches = {'static', 'egreedy', 'regret_matching'};

% Get a list of all subfolders
%subFolders = dir(mainFolders);
%subFolders = subFolders([subFolders.isdir] & ~startsWith({subFolders.name}, '.'));

% Initialize variables to store throughput values
throughputA = [];
throughputB = [];

% Loop through each subfolder
for j = 1 : length(mainFolders)
    for i = 1:length(approaches)
        folderPath = [mainFolders{j} '\' approaches{i}]; %fullfile(mainFolder, subFolders(i).name);
        filePath = fullfile(folderPath, 'output_test.txt');    
        % Check if the file exists
        if isfile(filePath)
            % Read the file content
            fileContent = fileread(filePath);        
            % Pattern explanation:
            % {       -> Match literal open brace
            % ([\d.]+) -> Capture digits and dots (Group 1)
            % ,       -> Match literal comma
            % ([\d.]+) -> Capture digits and dots (Group 2)
            % }       -> Match literal closing brace
            tokens = regexp(fileContent, '{([\d\.]+),([\d\.]+)}', 'tokens', 'once');        
            % tokens is now a 1x2 cell array: {'59.29', '58.65'}
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
lgnd = legend({'Static', '\varepsilon-greedy', 'Regret-matching'});
lgnd.NumColumns = 3;
set(gca, 'fontsize', 15)
grid on;
grid minor;

%saveas(gca, 'file.pdf');
