function obj = ShiftCode(n, k)
    rv = zeros(1, n);
    cv = zeros(1, n);

    rv(n - k + 1 : end) = 1;
    cv(2 : k + 1) = 1;

    obj = Code(toeplitz(cv, rv));
end