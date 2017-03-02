function ps = function_import_correlation(ps)
% FUNCTION_IMPORT_CORRELATION  Import feature-feature correlation matrix

if ps.param.decorr_lambda<1
    try 
        ps.correlation=csvread(fullfile(ps.param.dir_source,'correlation.csv'));        
    catch
        error('metabomatching:importCorrelation','correlation file %s not found',...
            fullfile(ps.param.dir_source,'correlation.csv'));
    end
end