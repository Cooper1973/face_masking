clear;clc;
ana_dir = 'E:\IPCAS_DATA\test\maskface\IXIdeface';
sub_list = [ana_dir,'\subs.list'];
data = importdata(sub_list);

for i = 1:length(data)
    sub = char(data(i));
    
    cn200 = load_nifti([ana_dir,'/recn200/de',sub]);
    cn2020 = load_nifti([ana_dir,'/recn2020/de',sub]);
    en = load_nifti([ana_dir,'/reen/de',sub]);
    o = load_nifti([ana_dir,'/reo/re',sub]);
    
    %188*256*256 150*256*256
    o_vol = round(reshape(o.vol,[150*256*256,1]));
    cn200_vol = reshape(cn200.vol,[150*256*256,1]);
    cn2020_vol = reshape(cn2020.vol,[150*256*256,1]);
    en_vol = reshape(en.vol,[150*256*256,1]);
    
    %% m2
    tmpcn200 = o_vol-cn200_vol;
    tmpcn2020 = o_vol-cn2020_vol;
    tmpen = o_vol-en_vol;
    
        mask200 = find(o_vol>cn200_vol);
        mask2020 = find(o_vol>cn2020_vol);
        masken = find(o_vol>en_vol);
%     mask200 = find(tmpcn200~=0);
%     mask2020 = find(tmpcn2020~=0);
%     masken = find(tmpen~=0);
    
    cn200_mask = cn200_vol(mask200,:);
    cn2020_mask = cn2020_vol(mask2020,:);
    en_mask = en_vol(masken,:);
    
    ocn200_mask = o_vol(mask200,:);
    ocn2020_mask = o_vol(mask2020,:);
    oen_mask = o_vol(masken,:);
    
    % normalized mutual information
    tmp200 = nmi(ocn200_mask-cn200_mask,ocn200_mask);
    sim_cn200(i,1) = tmp200;
    
    tmp2020 = nmi(ocn2020_mask-cn2020_mask,ocn2020_mask);
    sim_cn2020(i,1) = tmp2020;
    
    tmpen = nmi(oen_mask-en_mask,oen_mask);
    sim_en(i,1) = tmpen;
    
end

cd(ana_dir);
clearvars -except sim_cn200 sim_cn2020 sim_en ;

save facemask_nmi_ixi.mat
