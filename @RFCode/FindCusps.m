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