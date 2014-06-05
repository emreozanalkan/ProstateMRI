function AnonymizeDICOM(inputPath, outputPath)
% This fuinciton will Anonymize the Input Dicom File
dicomanon(inputPath, outputPath);
%dicomanon(inputPath, outputPath, 'keep', {'StudyID', 'StudyDate', 'SliceLocation', 'InstanceNumber'})