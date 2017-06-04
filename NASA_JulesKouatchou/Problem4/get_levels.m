function levs = get_levels(fileName)
%
%
    levs = ncread(fileName, 'lev');
    [nlevs m] = size(levs);
    levs = calcPressureLevels(nlevs);

end
