function normalized_high_matrix = high_size_normalisation(desired_mat,size_matrix)


normalized_mat = desired_mat;
max_size = size_matrix;

size_before_nor = length(normalized_mat);
if  size_before_nor == max_size/2 % 281
    normalized_high_matrix = low_size_normalisation(normalized_mat);
else
    nec_column = abs(max_size -(size_before_nor )); % 561
    if nec_column ~= 1
        nec_column = nec_column +1;
    end
    %create the value which is needed to add
    adding_mat2 = zeros(3,nec_column);
    
    
    
    for i = 1:1: nec_column
        for j = 1:1:3
            adding_mat2(j,i) = (abs( normalized_mat(j,i)+ normalized_mat(j,i+1)))/2;
        end
    end
    
    if nec_column ~= 1
        % adding zero between every column
        n = 1;
        nc = floor(nec_column);
        for c=1:nc
            C(:,(n*c+c-n):(n*c+c-1)) = normalized_mat(:,(n*(c-1)+1):n*c);
        end
        for i = (nec_column+1):1:size_before_nor
            C(:,(i+(nec_column-1))) = normalized_mat(:,i);
        end
        normalized_mat = C;
        
    else
        
        normalized_mat = [normalized_mat(:,1:1) zeros(3,1) normalized_mat(:,1+1:end)];
    end
    
    if nec_column ~= 1
        % adding new coordinate to the orginal matrix
        for j = 1:1:length(adding_mat2)
            normalized_mat(:,2*j)  = adding_mat2(:,j);
        end
    else
        normalized_mat(:,2*nec_column)  = adding_mat2(:,nec_column);
        
    end
    
    normalized_high_matrix = normalized_mat;
    
end


end