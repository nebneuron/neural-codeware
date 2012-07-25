classdef Metrics
    methods (Static)
        function fcn = Hamming()
            fcn = @(u, v) nnz(xor(u, v));
        end
    end
end