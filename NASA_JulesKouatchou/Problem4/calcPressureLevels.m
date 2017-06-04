function phPa = calcPressureLevels(nlevs)
%    """
%      This function takes the number of vertical levels
%      to read a file that contains the values of ak and bk.
%      It then computes the pressure levels using the formula:
%
%          0.5*(ak(i)+ak(i+1)) + 0.1*1.0e5*(bk(i)+bk(i+1))
%
%      Input Varialble:
%        nlevs: number of vertical levels
%
%      Returned Value:
%        phPa: pressure levels from bottom to top
%    """
    ak   = zeros(1,nlevs+1);
    bk   = zeros(1,nlevs+1);
    phPa = zeros(1,nlevs);
    
    fileName = strcat(num2str(nlevs), '-layer.p');

    M = dlmread(fileName, '', 2, 0);

    for k = 1:size(M,1)
        ak(k)   = M(k, 2);
        bk(k)   = M(k, 3);
    end

    for k = 1:nlevs
        phPa(k) = 0.50*((ak(k)+ak(k+1))+0.01*1.00e+05*(bk(k)+bk(k+1)));
    end
    %phPa = flip(phPa);
end
