% How to run this script:
%
%  time matlab -nodisplay -nodesktop -r "run timeSeries_AOA.m"
%
% Start time
%-----------
tic

vName = 'aoa';
begYear = 1990;
endYear = 2009;

numDays = 0;
numThreads = 1;

dirY = '/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/';

dataVal = [];

% Loop over the years
%--------------------
for year = begYear:endYear
    fprintf('Processing files for Year %5g \n', year)

    % Loop over the months
    %---------------------
    for month = 1:12
        dirM = strcat(dirY, num2str(year), sprintf('%02d', month), '/');
        listFiles = dir(strcat(dirM, 'AOArun.TR.', num2str(year), sprintf('%02d', month), '*_1200z.nc4'));

        numFiles = length(listFiles);
    
        numDays = numDays + numFiles;
        fprintf('Number of days: %d \n', numDays)

        %tempVar = [];
        tempVar = zeros(72, numFiles);

        % Loop over the daily files
        %--------------------------
        my_pool = parcluster('local');
        my_pool.NumWorkers = numThreads
        parpool('local', my_pool.NumWorkers);
        %my_pool = parpool('local', numThreads);

        fprintf('Number of files: %5g \n', numFiles)
        parfor idx = 1:numFiles
            tempVar(:,idx) = getData_from_file(fullfile(dirM,  listFiles(idx).name), idx);
            %tempVar(:,idx) = getData_from_file(filepath, idx);
            %tempVar(:,idx) = getData_from_file([dirM,  listFiles(idx).name]);
        end

        delete(my_pool);

    end
end

exit;

filepath = fullfile(dirM,  listFiles(1).name);
levs = get_levels(filepath);

%-----------------------------------
% Plot the mean at a specified level
%-----------------------------------

% x-axis ticks and labels
x_ticks = [];
for k = 1:numDays
    if mod(k,365) == 0
       x_ticks = [x_ticks k];
    end
end

%figure
[X Y] = meshgrid(1:numDays, levs);

contour(X, Y, dataVal);
set(gca,'yscale','log')
set(gca,'xgrid','on')
title('Age-of-Air (years) at  $86^o$  S', 'Interpreter','latex');
ylabel('Pressure (hPa)')
xlabel('Year')
set(gca,'XTick', x_ticks)
set(gca,'XTickLabel', sprintf('%4d\n',begYear+(1:length(x_ticks))))
set(gca, 'Fontsize',10)
saveas(gcf,'fig_TimeSeries_AgeOfAir_m.png')


% End time
%-----------
toc
