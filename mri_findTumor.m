%eac84@drexel.edu : TA
function mri_findTumor()

choice = input('MRI image: '); 
switch(choice)
    case 1
        im = imread('C:/Users/liamh/OneDrive/Desktop/tumor/mri1.jpg');
    case 2
        im = imread('C:/Users/liamh/OneDrive/Desktop/tumor/mri2.jpg');
    case 3
        im = imread('C:/Users/liamh/OneDrive/Desktop/tumor/mri3.jpg');
    case 4
        im = imread('C:/Users/liamh/OneDrive/Desktop/tumor/mri4.jpg');
    case 5
        im = imread('C:/Users/liamh/OneDrive/Desktop/tumor/mri5.jpg');
    otherwise
        error('Program error, use a number w/in [1, 3]!')
end

%Make sure the images are of similiar sizes
imsize = size(im); max = 900;
if (imsize(1) < max)
    im = imresize(im, (max/imsize(1))); 
end
%figure('Name', 'Original image') 
%imshow(im)

gray = rgb2gray(im);
imbr_reduce = imadjust(gray);
redFact = 0.35;
imbr_reduce = imbr_reduce * redFact;

imbr_redcopy = imbr_reduce; 
imbr_redcopy = mat2gray(imbr_redcopy);
lvl = multithresh(imbr_redcopy, 2);
level = lvl(2); disp(level);
binary = im2bw(imbr_redcopy, level); 

cc = bwconncomp(binary);
stats = regionprops(binary, 'Area', 'Perimeter');
perim = cat(1,stats.Perimeter);
area = cat(1,stats.Area);

%circularity testing, closer to circle -> closer to 1 from > 1
circularityA = (perim.^2)./(4*pi*area); maxCirc = 1.5;
%circularity testing, closer to circle -> closer to 1 from < 1
circularityB = (4*pi*area)./(perim.^2); minCirc = 0.7;
idx = find(circularityB > minCirc);
BW2 = ismember(labelmatrix(cc), idx);

%figure, imshow(BW2); %don't include in final

x = bwperim(BW2);
imagesc(x)

p = 3500;
bim = bwareaopen(BW2, p);
brem = imclearborder(bim); 

figure('Name', 'Final, overlayed')
final = imbr_reduce;
final(:,:,1) = double(final(:,:,1)) + (256 * brem);
imshow(final)
