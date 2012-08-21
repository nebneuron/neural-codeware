function obj = RandomConstantWeight(iLength, iNumWords, iWeight)
    % obj = Code.RandomConstantWeight(iLength, iNumWords, iWeight)
    assert(nchoosek(iLength, iWeight) >= iNumWords, ...
        ['The number of possible codewords of length ' num2str(iLength) ...
         ' and weight ' num2str(iWeight) ' is less than the number of desired' ...
         ' codewords (' num2str(iNumWords) ').  Please choose new parameters.']);

    [~, perm] = sort(rand(iNumWords, iLength), 2);
    indices = perm(:, 1:iWeight);
    mtxCode = zeros(iNumWords, iLength);
    mtxCode(sub2ind(size(mtxCode), [1:iNumWords]' * ones(1, iWeight), indices)) = 1;
    mtxCode = unique(mtxCode, 'rows');

    ii = 0;
    while size(mtxCode, 1) < iNumWords
        [~, perm] = sort(rand(iNumWords, iLength), 2);
        indices = perm(:, 1:iWeight);
        temp = zeros(iNumWords, iLength);
        temp(sub2ind(size(temp), [1:iNumWords]' * ones(1, iWeight), indices)) = 1;

        temp = unique(temp, 'rows');
        mtxCode = unique([mtxCode; temp], 'rows');
        ii = ii + 1;
    end

    mtxCode = mtxCode(1:iNumWords, :);
    obj = Code(mtxCode);
end