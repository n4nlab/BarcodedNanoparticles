function [covMatrix, scores, dataMatrixL]=PCA_v3(iniColumn, endColumn, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% by Ana Ortiz & Cristina Izquierdo
%%%%%% for questions or feedback contact us to (a.ortiz.perez@tue.nl or
%%%%%% c.izquierdo.lozano@tue.nl)
%%%%%% 
%%%%%% PCA_v1: This function runs a PCA analysis on the input data and
%%%%%% plots the result in a 2D and 3D scatter.
%%%%%% You can load 1 or more csv files (one file/sample). It is important
%%%%%% that the rows correspond to observations and the columns to
%%%%%% variables. 
%%%%%% You can have metadata in your columns, since you must specify in 
%%%%%% which column your variables start (iniColumn) and end (endColumn).  
%%%%%% This algorithm uses the pca default values. 
%%%%%% For more info refer to the pca MatLab documentation.

%%%%%% PCA_v2: Some code refactoring and small bugs fixed. Scree plot and biplot added.
%%%%%% z-scores standardization added as an optional feature. Saves data for
%%%%%% classification toolbox as classData.mat

%%%%%% PCA_v3: added comments, fixed some bugs, refactor loops for
%%%%%% efficiency. Now reads and builds the matrix at the same time and
%%%%%% doesn't need the csvimport.m file. NaN values are accepted, however,
%%%%%% pca function will ignore them (if all the instances contain NaN
%%%%%% values the output will be empty and could lead to errors when
%%%%%% plotting.

%%%%%% REQUIRED INPUTS:
%%%%%% iniColumn: First column where your variables start in the csv file.
%%%%%% endColumn: Last column where your variables end in the csv file.

%%%%%% OPTIONAL INPUTS:
%%%%%% numComponents: number of principal components for the PCA. Default: All
%%%%%% standardization: default == 0 (not standardized). Uses z-scores. 

%%%%%% OUTPUTS:
%%%%%% covMatrix: covariance matrix with the principal components. 
%%%%%% scores: representations of X in the principal component space.
%%%%%% dataMatrixL: Data matrix before the PCA, rows correspond to observations and columns to variables.

%%%%% BONUS: 
%%%%% Uncoment text at the end of the script to run k-means clustering
%%%%% For more info refer to the kmeans Matlab documentation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read parameters

p = inputParser; %init parser object
validNum = @(x) isnumeric(x) && (x > 0); %define valid inputs: positive num

%define defaults values for optional param:
defaultNumComponents = 0; %user wants to compute all principal components
defaultStandardization = 0; %user doesn't want to normalize the dataset

%define required and optional input parameters:
addRequired(p,'iniColumn',validNum);
addRequired(p,'endColumn',validNum); 

addParameter(p,'numComponents', defaultNumComponents, validNum);
addParameter(p, 'standardization',defaultStandardization, validNum);
%read input values:
parse(p,iniColumn, endColumn, varargin{:});

%assign the parsed values:
numComponents = p.Results.numComponents; %number of principal components
standardization=p.Results.standardization;

%% Upload csv files to workspace 

[file,file_path]=uigetfile('*.*','Multiselect','on'); % specify file to analyze --> char vector for 1 file, cell array for multiple

NumSheets = length(file);
disp(['You are including ', num2str(NumSheets), ' samples (barcodes) in your analysis! ']);

% Treat exception for only one file
if iscellstr(file) % if it's a cell array
    NumSheets = length(file); % user input multiple files
else
    NumSheets = 1; % user input only 1 file
end

PCAmatrix1=[]; % matrix with sample indexes and data for PCA
columns=(endColumn-iniColumn)+2; % calculate number of columns

disp('Building data matrix...');
for i=1:NumSheets
 % Build file name
    if NumSheets==1 % if there's only one file then it's a character vector (read all)
        filePath = char(strcat(file_path, file)); %File name with path for matlab to find it in the file structure
    else % if there's more than one file then it's a cell array (read only corresponding cell)
        filePath = char(strcat(file_path, file(:,i)));
    end
    % Read data
    data=readmatrix(filePath);
    datset_indx(i,1)=length(data); %save index
    % Add data to matrix
    dataset=(data(:,iniColumn:endColumn)); % Drop non-predictors columns
    dataset(:,2:columns)=dataset;
    dataset(:,1)=i; %add barcode index
    
    PCAmatrix1=[PCAmatrix1;dataset]; % append matrixes
    dataset=[]; % reset temporal
end

%% Prepare PCA matrix 
 
PCA_indx=PCAmatrix1(:,1); %vector that contains the indexes from samples 1-n. 
PCAmatrix=PCAmatrix1(:,2:columns); % matrix with data for PCA (observations,variables)

if (standardization == 1)
    PCAmatrix=zscore(PCAmatrix); %Scale the data before PCA
end

%%%%%%%%%%%%% save data in workspace for ML classification toolbox %%%%%%%%%%%%%%%
name = strcat('dataset_nb_NaN_', num2str(NumSheets),'.csv');                   %%%
disp(name);                                                                    %%%
index = num2cell(PCA_indx); % cast to cell array for classification toolbox    %%%
save('classData','PCAmatrix1','PCAmatrix', 'index');                           %%%
writematrix(PCAmatrix1, name);  % Full dataset for HPC                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PCA analysis

disp("PCA analysis...");

if (numComponents == 0) %default option, compute all components
    [coeff, score, latent] = pca(PCAmatrix); 
else
    [coeff, score, latent] = pca(PCAmatrix, 'NumComponents', numComponents); 
end

disp(coeff);
disp(score);
disp(latent);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  PCA Plots  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Automatic generation of legend

disp("Plotting..");

labels=['class01'];
labelX='class0%d';
labelY='class%d';

for i=2:NumSheets
    if i <10
    label=sprintf(labelX,i);
    labels=[labels; label];
    else
    label=sprintf(labelY,i);
    labels=[labels; label]; 
    end
end

%% Split Z to plot

S=ones(12,1);
E=zeros(12,1);
E(1)=datset_indx(1);

for q3=1:NumSheets-1
    q4=q3+1;
    S(q4)=[1+E(q3)]; 
    S;
    E(q4)=[E(q3)+datset_indx(q4)];
    E;
end

%% Colors

cmap=colormap(jet(NumSheets)); %colors randomly selected, you can make your own vector

%% Scatter 2D

figure(1)
for q2=1:NumSheets
    ss=S(q2);
    ee=E(q2);
    color=cmap(q2,:);
    scatter(score(ss:ee,1), score(ss:ee,2), 3, color, 'filled');
    hold on
end
hold off

xlabel('PCA1');
ylabel('PCA2');
zlabel('PCA3');
legend(labels, 'Interpreter', 'none'); 

%% Scatter 3D

figure(2)
for q2=1:NumSheets
    ss=S(q2);
    ee=E(q2);
    color=cmap(q2,:);
    scatter3(score(ss:ee,1), score(ss:ee,2), score(ss:ee, 3), 3, color, 'filled');
    hold on
end
hold off

xlabel('PCA1');
ylabel('PCA2');
zlabel('PCA3');
legend(labels, 'Interpreter', 'none'); 

%% Scree-plot

figure(3)
plot(latent); % plot eigenvalues in PCA (principal components variances)

%% Bi-plot

figure(4)
biplot(coeff(:,1:3),'Scores',score(:,1:3)); % biplot of the first 2 principal components (using the coefficients)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Bonus (k-means)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% k-means
% k=12;
% [cluster_ind, C]=kmeans(score,k);

%% visualization of found clusters (kmeans)
% figure(5); 
% gscatter3b(score(:,1), score(:,2),score(:,3), cluster_ind); %the data to be clustered
% hold on 
% scatter3(C(:,1),C(:,2),C(:,3), 50, 'kx'); %the centroids of the cluster "x"
% hold off

%% export variables

covMatrix = coeff;
scores = score;
dataMatrixL = PCAmatrix1;

end