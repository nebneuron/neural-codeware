function Compile()
    % Compiles Cliquer and the MEX files using it.
    % Invokes the system 'make' command and the MATLAB command 'mex'.
    
    % The directory in which the Cliquer source code resides.
    strDir = fileparts(which('Cliquer.Compile')); %[fileparts(tmp) '/cliquer/'];
    
    % clean old stuff
    system(['make -C ' strDir '/cliquer/ clean']);
    
    % Build cliquer.
    system(['make -C ' strDir '/cliquer/']);
    
    % A function name.
    strFcn = 'FindCliques';
    
    % Complile each of the individual MEX functions.
    disp('----------------------------------------');
    disp(['Creating MEX file ' strFcn '...']);
    disp(['-I' strDir]);
    disp(['-I' strDir '/cliquer']);
    disp([strDir '/' strFcn '.c']);
    disp([strDir '/cliquer/cliquer.o']);
    disp([strDir '/cliquer/graph.o']);
    disp([strDir '/cliquer/reorder.o']);
    mex(['-I' strDir], ...
        ['-I' strDir '/cliquer'], ...
        [strDir '/' strFcn '.c'], ...
        [strDir '/cliquer/cliquer.o'], ...
        [strDir '/cliquer/graph.o'], ...
        [strDir '/cliquer/reorder.o']);
    
    % The resultant MEX file will be automatically placed in the current
    % working directory.  Move this file to the Cliquer package directory.
    system(['mv ' strFcn '.mex* ' strDir '/']);
    
    % Tell the user that we're done compiling.
    disp('Finished compiling all MEX funtions!');
end