function [pB_mean, pB_stdev ] = calc_calib_board_error( Hr,Hc, X )
%CALC_ERROR_AX_XB Compute error stats
%   Detailed explanation goes here
    pBs =[];
    for i=1:length(Hr)
        HB_ = Hr(:,:,i)*X*Hc(:,:,i);
        pB_ = HB_(1:3,4)';
        pBs=[pBs; pB_];
    end
    pB_mean = mean(pBs);
    pB_stdev = std(pBs);
end

