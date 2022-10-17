function normalized_low_matrix = low_size_normalisation(desired_mat)


            normalized_mat = desired_mat;
           
            size_before_nor = length(normalized_mat);
            nec_column  = size_before_nor-1;
            adding_mat = zeros(3,nec_column);
            for i = 1:1:(nec_column)
                for j = 1:1:3
                    adding_mat(j,i) = (abs( normalized_mat(j,i)+ normalized_mat(j,i+1)))/2;
                end
            end
            
            % adding zero between every column
            n = 1;
            nc = floor(size_before_nor);
            for c=1:nc
                B(:,(n*c+c-n):(n*c+c-1)) = normalized_mat(:,(n*(c-1)+1):n*c);
            end
            % adding new coordinate to the orginal matrix
            normalized_mat = B;
            for j = 1:1:length(adding_mat)
                normalized_mat(:,2*j)  = adding_mat(:,j);
            end
            normalized_low_matrix = normalized_mat;








end