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
    otherwise
        error('Program error, use a number w/in [1, 3]!')
end

figure('Name', 'Original image') 
imshow(im)

gray = rgb2gray(im);
imbr_reduce = imadjust(gray);
redFact = 0.25;
imbr_reduce = imbr_reduce * redFact;

imbr_redcopy = imbr_reduce; 
imbr_redcopy = mat2gray(imbr_redcopy);
lvl = multithresh(imbr_redcopy, 2);
level = lvl(2); disp(level);
binary = im2bw(imbr_redcopy, level); 

%TODO: work on calculating LEVEL

cc = bwconncomp(binary);
data = regionprops(binary, 'Eccentricity');
eccMin = 0.7;
idx = find([data.Eccentricity] < eccMin);
BW2 = ismember(labelmatrix(cc), idx); 
figure, imshow(BW2);

p = 4000;
bim = bwareaopen(BW2, p);
brem = imclearborder(bim);

figure('Name', 'Final, overlayed')
final = imbr_reduce;
final(:,:,1) = double(final(:,:,1)) + (256 * brem);
imshow(final)
