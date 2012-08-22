function s = Sparsity(this)
    s = nnz(ToMatrix(this)) / (Size(this) * Length(this));
end