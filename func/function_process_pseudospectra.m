function ps=function_process_pseudospectra(ps)

switch ps.param.pstype
    case 'isa'
        ps.z=zscore(ps.isa);
        fn=fullfile(ps.param.dir_source,'z.tsv');
        fi=fopen(fn,'w');  
        for j = 1:size(ps.z,1)
            for k = 1:size(ps.z,2)
                fprintf(fi,'%.4f\t',ps.z(j,k));
            end
            fprintf(fi,'\n');
        end
        fclose(fi);
    otherwise
        return
end

end