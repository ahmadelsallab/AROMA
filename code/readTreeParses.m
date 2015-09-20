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
                    if(~isempty(Kids))
                        % Insert previous kids
                        allKids = [allKids; Kids];
                        % Start new kids
                        Kids = [];
                    end
                else
                    % Append to the current sentence Kids
                    Kids = [Kids; eval(line)];
                end            
            end
        end

        % Get next line
        line = fgets(fid);
    end
end