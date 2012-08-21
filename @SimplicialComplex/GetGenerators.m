function cllnGenerators = GetGenerators(this)
    %------------------------------------------------------------
    % Usage:
    %    cllnGenerators = cpx.GetGenerators()
    % Description:
    %    Retrieve the generating set of the given object.
    % Return values:
    %    cllnGenerators
    %       A `Collection` containing the generators of the calling object.
    %------------------------------------------------------------

    % Just return the stored generating set.
    cllnGenerators = this.Generators;
end