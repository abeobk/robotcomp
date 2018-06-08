function options=opt_parser(varargin)
% Parse varargin into key-value map container
% Usage: options=opt_parser(varargin)
%   options.isKey(key) - test if key exist
%   options(key)       - return value associated with key

    options=containers.Map;
    args=varargin{1};
    nargs= round(length(args)/2);
    for i=1:nargs
       options(args{i*2-1})=args{i*2};
    end
end