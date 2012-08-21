function GenerateFacets(this)
    % Generate the facets (maximal faces).  This is a protected function so
    % that the user doesn't accidentally regenerate the set of maximal faces.
    this.SetFacets(this.Generators.MaximalElements());
end