function allKids = readTreeParses(fileName)
    fid = fopen(fileName);
    line = fgets(fid);
    allKids = {};
    while(line > 0)
        % Skip empty lines
        if(~isempty(line))
            % Check if sentence line
            % Split the line "SENTENCE: i"
            lineWords = textscan(line,'%s','delimiter',' ');
            if(strcmp(lineWords{1}{1}, 'SENTENCE:')
                % Insert previous kids
                allKids = {allKids; Kids};
                % Start new kids
                Kids = [];
            else
                % Append to the current sentence Kids
                Kids = [Kids; eval(line)];
            end            
        end

        % Get next line
        line = fgets(fid);
    end
end