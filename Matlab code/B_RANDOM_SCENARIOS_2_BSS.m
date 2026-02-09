clear all
clc

% Define the main folder
mainFolders = {'simulation_results/sce3_random'};
approaches = {'static', 'egreedy', 'regretmatching'};
distances = {'d_3.0', 'd_4.0', 'd_5.0', 'd_6.0', 'd_7.0', 'd_8.0', 'd_9.0', 'd_10.0'};

numScenarios = 100;

% Initialize variables to store throughput values
throughputA = [];
throughputB = [];

% Loop through each subfolder
for j = 1 : length(mainFolders)
    folderPath = mainFolders{j};
    for i = 1:length(approaches)
        for k = 1 : length(distances)
            filePath = fullfile(folderPath, ['script_output_2_bss_' approaches{i} '_' distances{k} '.txt']);    
            % Check if the file exists
            if isfile(filePath)
                % Read the file content
                fileContent = fileread(filePath);        
                % Parse elements of interest
                tokens = regexp(fileContent, '{([\d\.]+),([\d\.]+)}', 'tokens');    
                % Filter by metric (1 every 9)
                tokens_throughput = tokens(1:9:end);
                tokens_airtime = tokens(2:9:end);
                tokens_delay = tokens(7:9:end);
                for n = 1 : numScenarios
                    throughputA{j,k}(n, i) = str2double(tokens_throughput{n}{1});
                    throughputB{j,k}(n, i) = str2double(tokens_throughput{n}{2});
                    meanThroughput{j,k}(n, i) = mean([throughputA{j,k}(n, i) throughputB{j,k}(n, i)]);
                    minThroughput{j,k}(n, i) = min([throughputA{j,k}(n, i) throughputB{j,k}(n, i)]);
                    airtimeA{j,k}(n, i) = str2double(tokens_airtime{n}{1});
                    airtimeB{j,k}(n, i) = str2double(tokens_airtime{n}{2});
                    meanAirtime{j,k}(n, i) = mean([airtimeA{j,k}(n, i) airtimeB{j,k}(n, i)]);
                    %delayA{j,k}(n, i) = str2double(tokens_delay{n}{1});
                    %delayB{j,k}(n, i) = str2double(tokens_delay{n}{2});
                    %meanDelay{j,k}(n, i) = mean([delayA{j,k}(n, i) delayA{j,k}(n, i)]);
                end
            end
        end
    end
end

% Prepare data for plotting
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');

% % PLOT CDF (mean throughput)
% for k = 1 : length(distances)
%     figure;
%     h(1) = cdfplot(meanThroughput{1,k}(:,1));
%     hold on
%     h(2) = cdfplot(meanThroughput{1,k}(:,2));
%     h(3) = cdfplot(meanThroughput{1,k}(:,3));
%     set(h(:), 'Linewidth', 2);
%     lgnd = legend({'Static', '\varepsilon-greedy', 'Regret-matching'});
%     %lgnd.NumColumns = 3;
%     set(gca, 'fontsize', 15)
%     xlabel('Throughput (Mbps)')
%     ylabel('F(x)')
%     title(distances{k})
%     grid on;
%     grid minor;
% end

% figure;
% h(1) = cdfplot(minThroughput{1}(:,1));
% hold on
% h(2) = cdfplot(minThroughput{1}(:,2));
% h(3) = cdfplot(minThroughput{1}(:,3));
% set(h(:), 'Linewidth', 2);
% lgnd = legend({'Static', '\varepsilon-greedy', 'Regret-matching'});
% %lgnd.NumColumns = 3;
% set(gca, 'fontsize', 15)
% xlabel('Log Throughput (Mbps)')
% ylabel('F(x)')
% grid on;
% grid minor;

% % PLOT CDF (individual throughputs)
% for k = 1 : length(distances)
%     figure;
%     h(1) = cdfplot([throughputA{1,k}(:,1); throughputB{1}(:,1)]);
%     hold on
%     h(2) = cdfplot([throughputA{1,k}(:,2); throughputB{1}(:,2)]);
%     h(3) = cdfplot([throughputA{1,k}(:,3); throughputB{1}(:,3)]);
%     set(h(:), 'Linewidth', 2);
%     lgnd = legend({'Static', '\varepsilon-greedy', 'Regret-matching'});
%     set(gca, 'fontsize', 15)
%     xlabel('Throughput (Mbps)')
%     ylabel('F(x)')
%     title(distances{k})
%     grid on;
%     grid minor;
% end

%% PLOT bars (mean throughputs)
custom_colors = [
    0.07, 0.44, 0.75; % Blue
    0.95, 0.40, 0.77; % Pink/Magenta
    0.29, 0.86, 0.25  % Green
];

bar_plot_data = [];
bar_plot_data_min = [];

for k = 1 : length(distances)
    % Append Mean Data
    bar_plot_data = [bar_plot_data; [mean(meanThroughput{1,k}(:,1)) ...
        mean(meanThroughput{1,k}(:,2)) mean(meanThroughput{1,k}(:,3))]];
    
    % Append Min Data (Corrected variable name here)
    bar_plot_data_min = [bar_plot_data_min; [mean(minThroughput{1,k}(:,1)) ...
        mean(minThroughput{1,k}(:,2)) mean(minThroughput{1,k}(:,3))]];
end

figure;

% 1. Plot MEAN Bars (Solid)
b_mean = bar(bar_plot_data, 'barwidth', 0.5, 'linewidth', 1.5);
hold on

% 2. Plot MIN Bars (Dashed, Transparent)
b_min = bar(bar_plot_data_min, 'barwidth', 0.8, 'linewidth', 2, ...
    'FaceColor', 'none', 'LineStyle', '--');

% 3. Apply Custom Colors
for i = 1:length(b_mean)
    % Set the solid bar color
    b_mean(i).FaceColor = custom_colors(i, :);
    
    % Set the dashed border color to match
    b_min(i).EdgeColor = custom_colors(i, :);
end

h_dummy_mean = bar(nan, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5); 
h_dummy_min = bar(nan, 'FaceColor', 'none', 'EdgeColor', 'k', ...
    'LineStyle', '--', 'LineWidth', 1.5);
legend_handles = [b_mean(1), b_mean(2), b_mean(3), h_dummy_mean, h_dummy_min];
legend_labels = { ...
    'Static', '$\varepsilon$-greedy', 'Regret-matching', ...
    'Mean throughput', 'Min. throughput'};                   
lgnd = legend(legend_handles, legend_labels, 'Interpreter', 'latex');

% --- AXIS STYLING ---
set(gca, 'fontsize', 15)
ylabel('Throughput (Mbps)', 'Interpreter', 'latex')
xlabel('$d_{AP-AP}$ (m)', 'Interpreter', 'latex');
axis([0.5, 8.5, 0, 100])
xtickformat('%.1f')
xticklabels([3:10].*1.12)
grid on;
grid minor;

%saveas(gca, 'file.pdf');
% 
% % PLOT CDF (airtime)
% figure;
% cdfplot([airtimeA{1}(:,1); airtimeB{1}(:,1)])
% hold on
% cdfplot([airtimeA{1}(:,2); airtimeB{1}(:,2)])
% cdfplot([airtimeA{1}(:,3); airtimeB{1}(:,3)])
% lgnd = legend({'Static', '\varepsilon-greedy', 'Regret-matching'});
% lgnd.NumColumns = 3;
% set(gca, 'fontsize', 15)
% xlabel('Airtime (%)')
% ylabel('F(x)')
% grid on;
% grid minor;
% 
% % PLOT CDF (delay)
% figure;
% cdfplot([delayA{1}(:,1); delayB{1}(:,1)])
% hold on
% cdfplot([delayA{1}(:,2); delayB{1}(:,2)])
% cdfplot([delayA{1}(:,3); delayB{1}(:,3)])
% lgnd = legend({'Static', '\varepsilon-greedy', 'Regret-matching'});
% lgnd.NumColumns = 3;
% set(gca, 'fontsize', 15)
% xlabel('Delay (ms)')
% ylabel('F(x)')
% grid on;
% grid minor;