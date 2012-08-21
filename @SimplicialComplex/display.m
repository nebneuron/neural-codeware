function display(this, iNumToDisplay)
    if nargin < 2
        iNumToDisplay = 20;
    end
    
    % Display the variable's name with appropriate spacing.
    disp(' ');
    disp([inputname(1),' = ']);
    disp(' ');
    
    % Display some summary information about the complex.
    disp(['   `SimiplicialComplex` object on ' num2str(NumVerts(this)) ...
          ' vertices with generating set...']);
    
    % Display the first `iNumToDisplay` generators.
    for i = 1 : min(iNumToDisplay, Size(this.Generators))
        disp(['      ' num2str(find(this.Generators.Sets(i, :)))]);
    end
    
    disp(' ');
    
    % Notify the user that the output has been truncated.
    if iNumToDisplay < Size(this.Generators)
        disp(['   ...displaying ' num2str(iNumToDisplay) ' of ' ...
              num2str(Size(GetGenerators(this))) ' generators.']);

        disp(' ');
    end
end