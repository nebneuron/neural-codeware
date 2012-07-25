classdef RFCode < Code
    properties (GetAccess = public, SetAccess = protected)
        Centers;
        Radii;
    end
    
    methods (Access = public)
        function obj = RFCode(arg1, r)
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
            obj = obj@Code(cllnWords);
            
            obj.Centers = mtxCenters;
            obj.Radii = cvRadii;
        end
        
        function PlotRF(this)
            figure();
            hold on;
            
            for i = 1 : size(this.Centers, 1)
                Utils.PlotCircle(this.Centers(i, :), this.Radii(i), 100);
            end
            
            hold off;
            axis equal;
            axis([0, 1, 0, 1]);
        end
    end
    
    methods (Static, Access = protected)
        % This method (by which I mean this method and all of the other
        % methods that were created just for this method to work) is
        % disgusting.  Fix it.
        function cllnWords = GenerateWords(mtxCenters, cvRadii)
            X = mtxCenters(:, 1);
            Y = mtxCenters(:, 2);
            
            % Build the matrix of cofirings.
            mtxCofire = (sqrt(bsxfun(@minus, X, X').^2 + ...
                              bsxfun(@minus, Y, Y').^2) ...
                         < bsxfun(@plus, cvRadii, cvRadii'));
            
            G = Graph(mtxCofire);
            objComplex = G.CliqueComplex();

            cllnEmptyTriangles = ...
                RFCode.EmptyTriangles(objComplex.GetFaces(), ...
                                      mtxCenters, ...
                                      cvRadii);
            
            objComplex.RemoveFaces(cllnEmptyTriangles);
            
            cllnWords = objComplex.GetFaces();
        end

        function cllnTriangles = EmptyTriangles(clln, mtxCenters, cvRadii)
            mtxClln = clln.ToMatrix();
            cvLogicalTriangleIdxs = (sum(mtxClln, 2) == 3);
            cvTriangleIdxs = find(cvLogicalTriangleIdxs);
            
            % The three lines below were originally the following for-loop.  The code
            % was changed to increase efficiency, but the original code remains here as
            % a comment to aid in understanding the current code.
            % 
            % mtxTriangles = zeros(length(cvTriangleIdxs), 3);
            % for i = 1 : iNumTriangles
            %     mtxTriangles(i, :) = find(mtxClln(cvTriangleIdxs(i), :));
            % end
            mtxLogicalTriangles = mtxClln(cvLogicalTriangleIdxs, :);
            [I, ~] = find(mtxLogicalTriangles');
            mtxTriangles = reshape(I, 3, length(cvTriangleIdxs))';

            mtxFirstPoint = mtxCenters(mtxTriangles(:, 1), :);
            mtxSecondPoint = mtxCenters(mtxTriangles(:, 2), :);
            mtxThirdPoint = mtxCenters(mtxTriangles(:, 3), :);
            
            % Find the two cusp points of intersection of the first two
            % place fields.
            [mtxCusp1, mtxCusp2] = ...
                RFCode.FindCusps(mtxCenters, ...
                                 cvRadii, ...
                                 mtxTriangles(:, 1), ...
                                 mtxTriangles(:, 2));
            
            % We can now do the first test for a nonempty intersection
            % of the three place fields: If neither of the two cusp
            % points that we just found lies inside the convex hull
            % defined by the three centers of the place fields, then the
            % triple intersection is nonempty.
            cvNonEmpty = ...
                ~or(RFCode.IsInTriangle(mtxCusp1, mtxFirstPoint, ...
                                        mtxSecondPoint, mtxThirdPoint), ...
                    RFCode.IsInTriangle(mtxCusp2, mtxFirstPoint, ...
                                        mtxSecondPoint, mtxThirdPoint));
            
            % Now for the second test.  This only needs to be done for
            % the indices where the first test failed, 
            cvNonEmpty = cvNonEmpty ...
                | (sqrt(sum((mtxThirdPoint - mtxCusp1).^2, 2)) ...
                   < cvRadii(mtxTriangles(:, 3))) ...
                | (sqrt(sum((mtxThirdPoint - mtxCusp2).^2, 2)) ...
                   < cvRadii(mtxTriangles(:, 3)));
            
            mtxEmptyTriangles = mtxClln(cvTriangleIdxs(~cvNonEmpty), :);
            cllnTriangles = Collection(mtxEmptyTriangles);
        end
        
        function [mtxCuspOne, mtxCuspTwo] = FindCusps(mtxCenters, cvRadii, cvCenters1, cvCenters2)
            % We have lists of points `P` and `Q` along with lists of radii `Rp`
            % and `Rq`.
            P = mtxCenters(cvCenters1, :);
            Rp = cvRadii(cvCenters1);
            Q = mtxCenters(cvCenters2, :);
            Rq = cvRadii(cvCenters2);
            
            % Find the distances between the points and the normalized vectors
            % pointing from `P` to `Q`.
            mtxPQVects = Q - P;
            cvDists = sqrt(sum(mtxPQVects.^2, 2));
            mtxPQVects = bsxfun(@rdivide, mtxPQVects, cvDists);
            
            % Use the Law of Cosines to compute the distances from `P` to the
            % midpoint of the two cusp points.  In conjunction with the vectors
            % found above, this gives us the midpoints of the cusp pairs.
            cvDistFromPToCuspMidpoint = (Rp.^2 + cvDists.^2 - Rq.^2) ./ (2 .* cvDists);
            mtxCuspMidpoint = P + bsxfun(@times, ...
                                         cvDistFromPToCuspMidpoint, ...
                                         mtxPQVects);
            
            % A vector pointing from the midpoint of the cusp pairs to one of the
            % cusps is orthogonal to the normal vectors found above.  Use these
            % normal, orthogonal vectors to find the vector pointing from the
            % cusps' midpoint to one of the cusps.
            mtxCuspVectors = ...
                bsxfun(@times, ...
                       sqrt(Rp.^2 - cvDistFromPToCuspMidpoint.^2), ...
                       [mtxPQVects(:, 2), -mtxPQVects(:, 1)]);
            
            % We now know exactly where the cusp points are.
            mtxCuspOne = mtxCuspMidpoint + mtxCuspVectors;
            mtxCuspTwo = mtxCuspMidpoint - mtxCuspVectors;
        end
        
        function cvBool = IsInTriangle(X, P, Q, R)
            % I think that this basically compares slopes of lines.  I don't
            % know.  It's Vladimir's algorithm.  I'm sure that there's a better
            % way to do this (in terms of the code duplication, at least).
            cvBool ...
                =  ((-P(:, 2) + Q(:, 2)) .* (Q(:, 1) - R(:, 1)) ...
                    + (P(:, 1) - Q(:, 1)) .* (Q(:, 2) - R(:, 2))) ...
                .* ((-P(:, 2) + Q(:, 2)) .* (Q(:, 1) - X(:, 1)) ...
                    + (P(:, 1) - Q(:, 1)) .* (Q(:, 2) - X(:, 2))) ...
                > 0;

            cvBool = cvBool ...
                     .* ((-P(:, 2) + R(:, 2)) .* (R(:, 1) - Q(:, 1)) ...
                         + (P(:, 1) - R(:, 1)) .* (R(:, 2) - Q(:, 2))) ...
                     .* ((-P(:, 2) + R(:, 2)) .* (R(:, 1) - X(:, 1)) ...
                         + (P(:, 1) - R(:, 1)) .* (R(:, 2) - X(:, 2))) ...
                     >0;

            cvBool = cvBool ...
                     .* ((-R(:, 2) + Q(:, 2)) .* (Q(:, 1) - P(:, 1)) ...
                         + (R(:, 1) - Q(:, 1)) .* (Q(:, 2) - P(:, 2))) ...
                     .* ((-R(:, 2) + Q(:, 2)) .* (Q(:, 1) - X(:, 1)) ...
                         + (R(:, 1) - Q(:, 1)) .* (Q(:, 2) - X(:, 2))) ...
                     > 0;
        end
    end
end