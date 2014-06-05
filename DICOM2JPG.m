function DICOM2JPG(dicomFilePath, newFileName, path)
% This funciton will take Dicom file name, New file name and Path as input
% and as outpout it wil save image as jpeg file to the specified path

[Dic_data] = dicomread(dicomFilePath);

name = strcat(newFileName, '.jpg');
new_name = fullfile(path, name);
Y = Dic_data;
% convert to a double positive image
P = im2double(Y);
% save adjusted posative as jpg
imwrite(imadjust(P), new_name, 'jpg');

%Help taken from
%http://www.mathworks.fr/matlabcentral/newsreader/view_thread/172321