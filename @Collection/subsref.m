function varRet = subsref(this, S)
    switch S(1).type
        case '.'
            varRet = builtin('subsref', this, S);
        case '()'
            if (length(S(1)) < 2)
                if (length(S(1).subs) ~= 1)
                    error('Exactly one index must be provided.');
                end

                if (length(S(1).subs{1}) == 1)
                    varRet = this.Sets(S(1).subs{1}, :);
                else
                    varRet = Collection(this.Sets(S(1).subs{1}, :));
                end

                return;
            else
                varRet = builtin('subsref', this, S);
            end
        case '{}'
            varRet = builtin('subsref', this, S);
    end
end