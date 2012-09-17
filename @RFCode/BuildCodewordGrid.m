function arrWords = BuildCodewordGrid(this, iPoints)
    % Build a grid of codewords.
    n = size(ToMatrix(this), 2);
    arrWords = zeros(iPoints, iPoints, n);
    
    cvRadii = GetRadii(this);
    
    mtxCenters = GetCenters(this);
    mtxCentersX = mtxCenters(:, 1);
    mtxCentersY = mtxCenters(:, 2);
    
    x = linspace(0, 1, iPoints);
    y = linspace(0, 1, iPoints)';
    
    for i = 1 : size(mtxCenters, 1)
        arrWords(:, :, i) = (sqrt(bsxfun(@plus, ...
                                         (x - mtxCentersX(i, :)).^2, ...
                                         (y - mtxCentersY(i, :)).^2)) ...
                             < cvRadii(i));
    end
end