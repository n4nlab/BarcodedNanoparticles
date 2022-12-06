%Create barcodes mixtures

%% Read file
[file,filePath] = uigetfile('*.*','Multiselect','on'); %look for file
filePath = char(strcat(filePath, file)); %concat file name to path
data = readmatrix(filePath); 

%% Preprocess data

%Drop index column
data(:,1) = []; %remove first column
writematrix(data,'mixtureAll.csv');

%% Define virtual mixtures

%Introduce numbers according to unseen data csv (classes from 1 to 10)
%Hardest mixture
barcodesH = [7,9];

%Mild mixture
barcodesM = [1,3];

%Easiest mixture
barcodesE = [2,6];

%% Create virtual mixtures

%initialize matrixes
mixtureHardest = [];
mixtureMild = [];
mixtureEasiest = [];

tmpMatrix = []; %temporal variable to read data

%look for barcodes
for i=1:length(data)
    %Hardest
    if ismember(data(i,1), barcodesH)
        tmpMatrix = data(i,:); %save whole row
        mixtureHardest = [mixtureHardest;tmpMatrix]; % append matrixes
    end
    %Mild
    if ismember(data(i,1), barcodesM)
        tmpMatrix = data(i,:); %save whole row
        mixtureMild = [mixtureMild;tmpMatrix]; % append matrixes
    end
    %Easiest
    if ismember(data(i,1), barcodesE)
        tmpMatrix = data(i,:); %save whole row
        mixtureEasiest = [mixtureEasiest;tmpMatrix]; % append matrixes
    end
end

%% Save output

writematrix(mixtureHardest,'mixtureHardest.csv');
writematrix(mixtureMild,'mixtureMild.csv');
writematrix(mixtureEasiest,'mixtureEasiest.csv');