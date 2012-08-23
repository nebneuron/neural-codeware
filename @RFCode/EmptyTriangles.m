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