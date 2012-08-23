classdef Channels
    methods (Static)
        function fcn = BAC(p, q)
            fcn = @(v) ...
                  (rand(size(v)) < p) .* (v == 0) + ...
                  (rand(size(v)) > q) .* (v ~= 0);
        end
    end
end