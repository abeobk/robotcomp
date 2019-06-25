function json_obj = json_read(filename)
%JSON_READ Read json file
%read json file

fid = fopen(filename,'rt');
tmp = textscan(fid,'%s');
fclose(fid);

%combine all line
line_count = length(tmp{1});
jtxt=strjoin(tmp{1});

%parse
json_obj = parse_json(jtxt);

end

