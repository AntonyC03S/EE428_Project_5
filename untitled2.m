% Making polygonal region
for x = 1:20
    I = imread(sprintf('Images/s%d.JPG', x));
    BW = roipoly(I);
    figures
    BW = imresize(BW, [275 183]);
    imshow(BW);
    save(sprintf('Output/s%d_mask.mat', x), 'BW');
end

% Making Histgram graph
I_straw = zeros(256,3);
I_no_straw = zeros(256,3);
for x = 1:20
    I = imread(sprintf('Images/s%d.JPG', x));
    I = imresize(I, [275 183]);
    mask = load(sprintf('Output/s%d_mask.mat', x));
    mask = mask.BW;

    for RGB = 1:3
        I_RGB = I(:,:,RGB);
        I_straw(:,RGB)    = I_straw(:,RGB)    + histcounts(I_RGB(mask),  0:256).';
        I_no_straw(:,RGB) = I_no_straw(:,RGB) + histcounts(I_RGB(~mask), 0:256).';
    end
    R = I(:,:,1);
    [N,edges] = histcounts(R(mask),  0:256);
end

RGB_title= ["R", "G", "B"];
for i  = 1:3
    subplot(3,2,2*i-1)
    histogram('BinEdges', edges, 'BinCounts', I_straw(:,i), 'EdgeColor', 'none');
    title("With Strawberry "+RGB_title(i))
    
    subplot(3,2,2*i)
    histogram('BinEdges', edges, 'BinCounts', I_no_straw(:,i), 'EdgeColor', 'none');
    title("Without Strawberry "+RGB_title(i))
end