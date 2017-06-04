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

firstFile = 0;

numDays = 0;
coef = 365.5;

ref_lat = -86.0;

dirY = '/discover/nobackup/jkouatch/GEOSctmProduction/AOArun_new/holding/TR/';

% Loop over the years
%--------------------
for year = begYear:endYear
    fprintf('Processing files for Year %5g \n', year)

    % Loop over the months
    %---------------------
    for month = 1:12
        dirM = strcat(dirY, num2str(year), sprintf('%02d', month), '/');
        listFiles = dir(strcat(dirM, 'AOArun.TR.', num2str(year), sprintf('%02d', month), '*_1200z.nc4'));

        % Loop over the daily files
        %--------------------------
        for idx = 1:numel(listFiles)
            filepath = [dirM,  listFiles(idx).name];
            
            numDays = numDays + 1;

            % Extract information if it is the first file
            %--------------------------------------------
            if firstFile == 0
               lons = ncread(filepath, 'lon'); 
               lats = ncread(filepath, 'lat'); 
               levs = ncread(filepath, 'lev'); 
               [nlons m] = size(lons);
               [nlats m] = size(lats);
               [nlevs m] = size(levs);

               lat_index = find(lats == ref_lat);

               levs = calcPressureLevels(nlevs);
            end;

            % Read the daily average age of air
            %----------------------------------
            var = ncread(filepath, vName, [1 lat_index 1 1], [Inf 1 Inf 1], [1 1 1 1]) /coef; 

            % Determine the zonal mean
            %-------------------------
            tempVar = mean(var,1);
            tempVar = squeeze(tempVar);

            % Stack the daily values into an existing array
            %----------------------------------------------
            if firstFile == 0
               firstFile = 1;
               dataVal = tempVar;
            else
               dataVal = [dataVal,tempVar];
            end
        end
    end
end

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
