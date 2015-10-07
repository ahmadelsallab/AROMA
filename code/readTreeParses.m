function allKids = readTreeParses(fileName)
    fid = fopen(fileName);
    line = fgets(fid);
    allKids = {};
    Kids = [];
    num = 0;
    while(line > 0)
        % Skip empty lines
        if(~isempty(line))
            % Check if sentence line
            % Split the line "SENTENCE: i"
            lineWords = textscan(line,'%s','delimiter',' ');
            num = num + 1;
            if(~isempty(lineWords{1}))
                if(strcmp(lineWords{1}{1}, 'SENTENCE:'))
                    % Start new kids
                    Kids = [];
                else
                    % Append to the current sentence Kids
                    % +1 because sentences indices are zero based
                    Kids = [Kids; eval(line) + 1];
                end
            else
                % Insert previous kids
                if(~isempty(Kids))
                    allKids = [allKids; Kids];
                end   
            end   
         else
         
        end

        % Get next line
        line = fgets(fid);
    end
end