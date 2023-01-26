# Barcoded Nanoparticles
Hello! Welcome to the Barcoded Nanoparticles repository, here you can find the codes and datasets described in the manuscript ***"Identification of fluorescently-barcoded nanoparticles using machine learning"*** *[Paper](paste here link when published)*.

## Content
### Code

This folder contains all the scripts used to analyse and characterize the nanoparticles and also the script used to classify the different barcodes encoded into these nanoparticles.

Contains:
* *PCA_v3.m* --> MATLAB script to perform a PCA analysis on barcode data. Use and description can be found in the file's header.
* *DataPreprocessing.ipynb* --> Jupyter notebook to prepare the raw data into Pycaret's format.
* *pycaret.ipynb* --> Jupyter notebook to create a machine-learning classification model using [Pycaret](https://pycaret.org/).
* *virtualMixtureCreator.m* --> MATLAB script to create virtual mixtures with different classes (mix datasets).

### Datasets

This folder contains the preprocessed datasets used to train the machine-learning classification model.

Contains:
* *dataset.csv* --> Full 26-classes dataset
* *unseen_data_model10.csv* --> 10-classes dataset, unseen by the model (to test).
* *mixture\*.csv* --> Virtual class mixtures datasets, described in the manuscript.
* sizeComparison:
⋅⋅* 10 classes datasets with different sample sizes, cut in a stratified way, not balanced.

### Models

This folder contains the final 10 classes model, not balanced, used in the manuscript for further analysis.
Also contains the MATLAB figure for the 26 barcodes PCA.

## Installation

The easiest is to import the [conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html#) the authors used for this paper. You can find it in (refer to repository dir).
 1. *export conda environment* contains [Pycaret](https://pycaret.org/ "Pycaret's Homepage") --> add comands in markdown


## Notes

If you have any question feel free to open an *Issue* or email the main authors:
  * Ana Ortiz Pérez (a.ortiz.perez@tue.nl)
  * Cristina Izquierdo Lozano (c.izquierdo.lozano@tue.nl)
