function codeNew = Shuffle(this)
    mtxOld = this.Words.ToMatrix();

    iSize = this.Words.Size;
    iLength = this.Words.Dimension;

    mtxNew = zeros(iSize, iLength);

    for ii = (1 : this.Words.Size)
        bFoundNewWord = false;

        while ~bFoundNewWord
            rvNewWord = mtxOld(ii, randperm(iLength));

            if ~isempty(setdiff(rvNewWord, mtxNew(1 : ii - 1, :), 'rows'))
                mtxNew(ii, :) = rvNewWord;
                bFoundNewWord = true;
            end
        end
    end

    codeNew = Code(mtxNew);
end