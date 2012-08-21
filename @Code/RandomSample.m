
function obj = Random(iLength, iNumWords, fSparsity)
    assert(iNumWords < 2^iLength, ...
        'First and second arguments are not compatible.')

    % Generate a random code, and remove repeated codewords.
    mtxCode = unique(rand(iNumWords, iLength) < fSparsity, 'rows');

    % If there are not enough unique codewords, generate more codewords
    % until enough codewords have been generated.
    while size(mtxCode, 1) < iNumWords
        temp = (rand(iNumWords, iLength) < fSparsity);
        mtxCode = unique([mtxCode; temp], 'rows');
    end

    % The above process could have produced too many codewords; select
    % only the first `iNumWords` that were generated.
    mtxCode = mtxCode(1:iNumWords, :);
    obj = Code(mtxCode);
endfunction cllnRand = RandomSample(this, iSize)
[~, I] = max(bsxfun(@le, ...
                rand(iSize, 1), ...
                cumsum(this.Distribution)), ...
         [], 2);

cllnRand = this.Words(I);
end