function mtxCenters = DropCenters(cvRadii, iGridSize)
    
    % Set a default grid size if one wasn't provided.
    if nargin < 2
        iGridSize = 1001;
    end
    
    % Store the number of centers and initilize the grid to keep track of
    % which points have not been covered.
    iCenters = length(cvRadii);
    mtxIsUncovered = true(iGridSize);
    
    % So that we don't have to recompute these values, store the x- and
    % y-values of the grid points.
    x = linspace(0, 1, iGridSize);
    y = linspace(0, 1, iGridSize)';
    
    % We have placed zero centers, but we want to have enough room to store
    % all of the centers' coordinates.
    iNumDropped = 0;
    mtxCenters = NaN(iCenters, 2);
    
    % As long as there is an uncovered grid point and we have not placed
    % enough centers, we want to keep placing the centers.
    while (nnz(mtxIsUncovered) > 0) && (iNumDropped < iCenters)
        % Increment the number of centers have have been placed.
        iNumDropped = iNumDropped + 1;
        
        % Select a random grid point that hasn't been covered, and place the
        % new center close to it.
        [rows, cols] = find(mtxIsUncovered);
        idx = randi(length(rows));
        mtxCenters(iNumDropped, :) = [x(cols(idx)), y(rows(idx))] ...
            + (rand(1, 2) - 0.5) / iGridSize;
        
        % Determine which grid points are still uncovered.
        mtxIsUncovered = (mtxIsUncovered & ...
                          bsxfun(@plus, ...
                                 (x - mtxCenters(iNumDropped, 1)).^2, ...
                                 (y - mtxCenters(iNumDropped, 2)).^2) ...
                          >= cvRadii(iNumDropped)^2);
        
        imagesc(mtxIsUncovered);
        axis equal;
        hold on;
        plot(iGridSize * mtxCenters(iNumDropped, 1), ...
             iGridSize * mtxCenters(iNumDropped, 2), ...
             'go');
    end
    
    % If the grid has been completely covered, we might still need to place
    % some more centers.  In this case, just place the centers uniformly at
    % random.
    if iNumDropped < iCenters
        mtxCenters(iNumDropped + 1 : iCenters, :) = rand(iCenters - iNumDropped, 2);
    end
end