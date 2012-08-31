classdef RFCode < Code
    % Description:
    %    Subclass of `Code` for creating codes based on overlapping receptive
    %    fields.
    % Methods:
    %    GetCenters
    %    GetRadii
    %    PlotRF
    
    properties (Access = protected)
        Centers;
        Radii;
    end
    
    methods (Access = public)
        function code = RFCode(arg1, r)
            %---------------------------------------------------------------------------
            % Usage:
            %    code = RFCode(mtxCenters, r)
            %    code = RFCode(n, r)
            % Description:
            %    Create a receptive-field code.
            % Arguments:
            %    mtxCenters
            %       A 2-column matrix with each row representing the center of a
            %       circular receptive field.
            %    n
            %       If the first argument is a positive integer, then `n` centers are
            %       generated randomly in the unit square.
            %    r
            %       A vector of radii for the receptive fields.  This may be a
            %       scalar, which is equivalent to `ones(1, r)`.
            %---------------------------------------------------------------------------
            
            % Process the first argument.
            if isscalar(arg1)
                % If the first argument is a scalar, create a random list of
                % centers.
                nCenters = arg1;
                mtxCenters = rand(nCenters, 2);
            elseif ismatrix(arg1)
                assert(size(arg1, 2) == 2, ...
                       'The provided matrix must have exactly two columns');
                
                nCenters = size(arg1, 1);
                mtxCenters = arg1;
            else
                error(['The first argument must be a scalar or a matrix.  See ' ...
                       '`help RFCode.RFCode` for more information.']);
            end
            
            % Process the second argument.
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
                error(['The secont argument must be a scalar or a vector.  See ' ...
                       '`help RFCode.RFCode` for more information.']);
            end
            
            % Generate the collection of words represented by this receptive
            % field, and build a code object using those words.
            cllnWords = RFCode.GenerateWords(mtxCenters, cvRadii);
            code = code@Code(cllnWords);
            
            % Now that the object has been created, we can store the centers
            % and radii.
            code.Centers = mtxCenters;
            code.Radii = cvRadii;
        end
    end
    
    methods (Access = public)
        cllnCenters = GetCenters(this)
        
        cllnRadii = GetRadii(this)
        
        PlotRF(this)
    end
    
    methods (Static, Access = protected)
        % This method (by which I mean this method and all of the other
        % methods that were created just for this method to work) is
        % disgusting.  Fix it.
        cllnWords = GenerateWords(mtxCenters, cvRadii)

        cllnTriangles = EmptyTriangles(clln, mtxCenters, cvRadii)
        
        [mtxCuspOne, mtxCuspTwo] = FindCusps(mtxCenters, cvRadii, cvCenters1, cvCenters2)
        
        cvBool = IsInTriangle(X, P, Q, R)
    end
end