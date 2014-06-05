function [patientName, patientID, patientBirthDate, studyID, studyDate, sliceLocation, instanceNumber] = GetDICOMInfo(filename)
info = dicominfo(filename);
%patientName = info.Patientsname;
patientName = 'Joseph Forier';
patientID = info.PatientID;
% PatientBirthDate = info.PatientsBirthDate;
% as we dont have any Patients Birrth Info so Setting it our self
patientBirthDate = [num2str(19), 'March', num2str(1988)];
studyID = info.StudyID;
studyDate = info.StudyDate;
sliceLocation = info.SliceLocation;
instanceNumber = info.InstanceNumber;