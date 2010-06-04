classdef PGFPlotsPresentationOM < PGFPlotsOutputModule
    %PGFPLOTSPRESENTATIONOM PGFPlots Module for Presentations
    %   This output module differs from the regular PGFPlots module in that it
    %   produces thicker lines and larger fonts, suitable to use in
    %   presentations. 
    
    methods (Access = 'protected')
        function write_extra_headers(obj, fid)
            % Set custom plot styles for lines and fonts.
            fprintf(fid, ...
                '\\pgfplotsset{every axis/.append style={line width=2pt}}\n');
            fprintf(fid, ...
                '\\pgfplotsset{legend style={font=\\sffamily}}\n');
            fprintf(fid, ...
                '\\pgfplotsset{label style={font=\\sffamily\\Large}}\n');
            fprintf(fid, ...
                '\\pgfplotsset{tick label style={font=\\sffamily\\large}}\n');
        end
    end
    
end

