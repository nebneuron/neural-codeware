function i = CodeLength(this)
    if length(this.Codes) > 0
        i = Length(this.Codes{1});
    else
        i = 0;
    end
end