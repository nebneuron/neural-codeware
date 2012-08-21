function display(this, iNumToDisplay)
    if nargin < 2
        iNumToDisplay = 20;
    end

    disp(' ');
    disp([inputname(1),' = ']);
    disp(' ');

    disp(['   `Collection` object of dimension ' num2str(Dimension(this)) ...
          ' with elements...']);

    for i = 1 : min(iNumToDisplay, Size(this))
        disp(['      ' num2str(find(this.Sets(i, :)))]);
    end

    disp(' ');

    if iNumToDisplay < Size(this)
        disp(['   ...displaying ' num2str(iNumToDisplay) ' of ' ...
              num2str(Size(this)) ' elements.']);

        disp(' ');
    end
end