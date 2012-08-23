classdef RFCode < Code
    properties (Access = protected)
        Centers;
        Radii;
    end
    
    methods (Access = public)
        function code = RFCode(arg1, r)
            if isscalar(arg1)
                nCenters = arg1;
                mtxCenters = rand(nCenters, 2);
            elseif ismatrix(arg1)
                assert(size(arg1, 2) == 2, ...
                       'The provided matrix must have exactly two columns');
                
                nCenters = size(arg1, 1);
                mtxCenters = arg1;
            else
                % throw an error.
            end
            
            if isscalar(r)
                assert(r > 0, 'The given radius must be positive.');
                cvRadii = r * ones(nCenters, 1);
            elseif isvector(r)
                assert(length(r) == nCenters, ...
                       ['The list of radii must be of the same length as ' ...
                        'the number of centers.']);
                assert(min(r) > 0, ...
                       ['All of the given radii must be positive.']);
                
                % Store the radii as a column vector.
                cvRadii = reshape(r, nCenters, 1);
            else
                % throw an error.
            end
            
            cllnWords = RFCode.GenerateWords(mtxCenters, cvRadii);
            code = code@Code(cllnWords);
            
            code.Centers = mtxCenters;
            code.Radii = cvRadii;
        end
        
        PlotRF(this)
    end
    
    methods (Access = public)
        cllnCenters = GetCenters(this)
        cllnRadii = GetRadii(this)
    end
    
    methods (Static, Access = protected)
        % This method (by which I mean this method and all of the other
        % methods that were created just for this method to work) is
        % disgusting.  Fix it.
        cllnWords = GenerateWords(mtxCenters, cvRadii)

        cllnTriangles = EmptyTriangles(clln, mtxCenters, cvRadii)
        
        mtxCuspOne, mtxCuspTwo] = FindCusps(mtxCenters, cvRadii, cvCenters1, cvCenters2)
        
        cvBool = IsInTriangle(X, P, Q, R)
    end
end