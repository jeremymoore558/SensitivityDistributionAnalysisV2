# SensitivityDistributionAnalysisV2
  ToDo:

 Purpose:
   Matlab Code to extract sensitivity distribution from single-cell FRET data
   This is meant to be an extension of the FRET-data analysis package written by
   Dr. Keita Kamino. His package, with the 'organizing_data_info_prjct2' function
   produces a matlab struct called 'reorgData'. This analysis is designed to work
   with this output.

 Usage:
  The user must provide some basic information about the dataset by editing the
  'datasets' function. This function generates a struct called dataparms which
  is used in subsequent analysis for loading the dataset and controlling some
  plotting parameters that vary from experiment to experiment. These parameters
  are:
    1. backConc: the background concentration the dose-response was measured at.
    This is used for fitting the Hill Function to the data
    2. xlabels: usually the identity of the stimulus. Used simply to change the
    xlabel on plots.
    3. Lplot: the range of ligand concentrations to plot over.
    4. Files: The path from the current directory to the data file. Can include
    multiple files which will be automatically combined.


  This code also currently expects that your experiment alternates between the
  stimulus levels in the same order each time. If this is not true, edit the
  'reorganizeData' function.
