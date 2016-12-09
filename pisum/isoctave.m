function isoct = isoctave()
%Michael Hirsch
% tested with Octave 3.6-4.0 and Matlab R2012a-R2016a

persistent oct;

if isempty(oct)
    oct = exist('OCTAVE_VERSION', 'builtin') == 5;
end

isoct=oct; % has to be a separate line/variable for matlab

end
