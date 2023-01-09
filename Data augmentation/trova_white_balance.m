function [im_deg_new,im_deg,i_wR,i_wG,i_wB] = trova_white_balance(im_deg_new,im_deg)

    addpath(genpath(pwd))

    BRI_deg = brisque(im_deg);
    BRI_cc=[];
    PSNR_cc=[];
    wR_cc=[];
    wG_cc=[];
    wB_cc=[];

    % max-RGB
    %[wR,wG,wB,out]=general_cc_truncated(double(im_deg),0,-1,0,-1);
    %im_tmp = double(im_deg_new);
    %im_tmp(:,:,1) = im_deg_new(:,:,1)*(wR*sqrt(3));
    %im_tmp(:,:,2) = im_deg_new(:,:,2)*(wG*sqrt(3));
    %im_tmp(:,:,3) = im_deg_new(:,:,3)*(wB*sqrt(3));
    %im_tmp = uint8(im_tmp);
    %BRI = brisque(im_tmp);
    %BRI_cc=[BRI_cc; BRI];
    %PSNR = psnr(im_deg,im_tmp);
    %PSNR_cc=[PSNR_cc; PSNR];
    %wR_cc=[wR_cc; wR];
    %wG_cc=[wG_cc; wG];
    %wB_cc=[wB_cc; wB];

    % gray world
    %[wR,wG,wB,out]=general_cc_truncated(double(im_deg),0,1,0,-1);
    %im_tmp = double(im_deg_new);
    %im_tmp(:,:,1) = im_deg_new(:,:,1)*(wR*sqrt(3));
    %im_tmp(:,:,2) = im_deg_new(:,:,2)*(wG*sqrt(3));
    %im_tmp(:,:,3) = im_deg_new(:,:,3)*(wB*sqrt(3));
    %im_tmp = uint8(im_tmp);
    %BRI = brisque(im_tmp);
    %BRI_cc=[BRI_cc; BRI];
    %PSNR = psnr(im_deg,im_tmp);
    %PSNR_cc=[PSNR_cc; PSNR];
    %wR_cc=[wR_cc; wR];
    %wG_cc=[wG_cc; wG];
    %wB_cc=[wB_cc; wB];

    % shades of gray
    [wR,wG,wB,out]=general_cc_truncated(double(im_deg),0,5,0,-1);
    im_tmp = double(im_deg_new);
    im_tmp(:,:,1) = im_deg_new(:,:,1)*(wR*sqrt(3));
    im_tmp(:,:,2) = im_deg_new(:,:,2)*(wG*sqrt(3));
    im_tmp(:,:,3) = im_deg_new(:,:,3)*(wB*sqrt(3));
    im_tmp = uint8(im_tmp);
    BRI = brisque(im_tmp);
    BRI_cc=[BRI_cc; BRI];
    PSNR = psnr(im_deg,im_tmp);
    PSNR_cc=[PSNR_cc; PSNR];
    wR_cc=[wR_cc; wR];
    wG_cc=[wG_cc; wG];
    wB_cc=[wB_cc; wB];

    % general gray world
    [wR,wG,wB,out]=general_cc_truncated(double(im_deg),0,5,2,-1);
    im_tmp = double(im_deg_new);
    im_tmp(:,:,1) = im_deg_new(:,:,1)*(wR*sqrt(3));
    im_tmp(:,:,2) = im_deg_new(:,:,2)*(wG*sqrt(3));
    im_tmp(:,:,3) = im_deg_new(:,:,3)*(wB*sqrt(3));
    im_tmp = uint8(im_tmp);
    BRI = brisque(im_tmp);
    BRI_cc=[BRI_cc; BRI];
    PSNR = psnr(im_deg,im_tmp);
    PSNR_cc=[PSNR_cc; PSNR];
    wR_cc=[wR_cc; wR];
    wG_cc=[wG_cc; wG];
    wB_cc=[wB_cc; wB];

    % gray edge (1st order)
    [wR,wG,wB,out]=general_cc_truncated(double(im_deg),1,5,2,-1);
    im_tmp = double(im_deg_new);
    im_tmp(:,:,1) = im_deg_new(:,:,1)*(wR*sqrt(3));
    im_tmp(:,:,2) = im_deg_new(:,:,2)*(wG*sqrt(3));
    im_tmp(:,:,3) = im_deg_new(:,:,3)*(wB*sqrt(3));
    im_tmp = uint8(im_tmp);
    BRI = brisque(im_tmp);
    BRI_cc=[BRI_cc; BRI];
    PSNR = psnr(im_deg,im_tmp);
    PSNR_cc=[PSNR_cc; PSNR];
    wR_cc=[wR_cc; wR];
    wG_cc=[wG_cc; wG];
    wB_cc=[wB_cc; wB];

    % gray edge (2nd order)
    [wR,wG,wB,out]=general_cc_truncated(double(im_deg),2,5,2,-1);
    im_tmp = double(im_deg_new);
    im_tmp(:,:,1) = im_deg_new(:,:,1)*(wR*sqrt(3));
    im_tmp(:,:,2) = im_deg_new(:,:,2)*(wG*sqrt(3));
    im_tmp(:,:,3) = im_deg_new(:,:,3)*(wB*sqrt(3));
    im_tmp = uint8(im_tmp);
    BRI = brisque(im_tmp);
    BRI_cc=[BRI_cc; BRI];
    PSNR = psnr(im_deg,im_tmp);
    PSNR_cc=[PSNR_cc; PSNR];
    wR_cc=[wR_cc; wR];
    wG_cc=[wG_cc; wG];
    wB_cc=[wB_cc; wB];

    % calcolo coefficienti migliori
    BRI_cc = abs(BRI_cc - BRI_deg);    
    minimum=min(BRI_cc);
    u=find(BRI_cc==minimum);

    %maximum=max(PSNR_cc);
    %u=find(PSNR_cc==maximum);

    u=u(1); % per più elementi minimi
    i_wR=wR_cc(u);
    i_wG=wG_cc(u);
    i_wB=wB_cc(u);
    im_deg_new = double(im_deg_new);
    im_deg_new(:,:,1) = im_deg_new(:,:,1)*(i_wR*sqrt(3));
    im_deg_new(:,:,2) = im_deg_new(:,:,2)*(i_wG*sqrt(3));
    im_deg_new(:,:,3) = im_deg_new(:,:,3)*(i_wB*sqrt(3));
    im_deg_new = uint8(im_deg_new);

end