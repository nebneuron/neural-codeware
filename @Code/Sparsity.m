function s = Sparsity(this)
    s = nnz(this.Words.ToMatrix()) / (this.Words.Size * this.Words.Dimension);
end