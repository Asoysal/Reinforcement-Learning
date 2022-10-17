function   [normalized_matrix1]=normalisation(normalized_mat1, size_mat)



normalized_mat = normalized_mat1;
max_size = size_mat;
size_before_nor = length(normalized_mat);
if size_before_nor == max_size%561 
    normalized_matrix1 = normalized_mat;
end
if size_before_nor ==  max_size/2 %281
    normalized_matrix1 = low_size_normalisation(normalized_mat);
end
if size_before_nor < max_size/2 %281
    loop = 1;
    while loop
        normalized_mat = low_size_normalisation(normalized_mat);
        if (length(normalized_mat)+ length(normalized_mat)+1) > max_size  %561
            loop = 0;
        end
    end
    normalized_matrix1 = high_size_normalisation(normalized_mat,max_size);
end
if size_before_nor >  max_size/2  %281
    normalized_matrix1 = high_size_normalisation(normalized_mat,max_size);
end% firs if
% this path is default. in every moment of the simulation
% leader path are not going to change





end

