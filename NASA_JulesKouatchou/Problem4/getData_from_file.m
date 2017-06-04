function tempVar = getData_from_file(filepath, k)
%
%
    vName = 'aoa';
    coef = 365.5;
    ref_lat = -86.0;
    k1 = k

    lats = ncread(filepath, 'lat');

    % Latitude index at ref_lat
    %--------------------------
    lat_index = find(lats == ref_lat);

    % Read the daily average age of air
    %----------------------------------
    var = ncread(filepath, vName, [1 lat_index 1 1], [Inf 1 Inf 1], [1 1 1 1]);

    % Determine the zonal mean
    %-------------------------
    tempVar = mean(var,1);
    tempVar = squeeze(tempVar);

end
