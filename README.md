# Barcoded Nanoparticles
Hello! Welcome to the Barcoded Nanoparticles repository, here you can find the codes and datasets described in the manuscript ***"Identification of fluorescently-barcoded nanoparticles using machine learning"***.

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

The easiest is to import the [conda environment](https://docs.conda.io/projects/conda/en/latest/user-guide/concepts/environments.html#) the authors used for this paper. You can find it in this repository as ```pycaret_env.yml```. From a cmd terminal, go to your desired file location and type the following commands:
 1. Create conda environment from file
   ```conda env create -f pycaret_env.yml```
 2. Activate conda environment 
   ```conda activate pycaret_env```
 3. Open Jupyter Notebook
   *(In environment)* ```jupyter notebook```

Now you are all ready to run the script from the browser notebook!

## Notes

If you have any question feel free to open an *Issue* or email the main authors:
  * Ana Ortiz Pérez (a.ortiz.perez@tue.nl)
  * Cristina Izquierdo Lozano (c.izquierdo.lozano@tue.nl)

## LICENSE

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.
