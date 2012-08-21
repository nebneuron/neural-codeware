function SetWeights(this, cvWeights)
    assert(this.FacesAreGenerated);
    assert(iscolumn(cvWeights));
    assert(isnumeric(cvWeights));
    assert(this.Faces.Size == length(cvWeights));

    this.Weights = cvWeights;
end