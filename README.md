# eppfinalproject_moritzraykowski
I provide a comparison in data management/manipulation and analysis (regressions) and their plotting between python and stata to see which utilities from each program might be missing in the other one and might be helpful for the future.


This repository contains the following:

1. a raw data excel file containing survey answers from a survey experiment extracted from qualtrics in src under data

2. a stata do file for data mangement in which the raw data is polished, outputs a ready to be used .dta file for analysis in src under data_management

3. a python file for data management in which the raw data is polished, outputs a ready to be used .xls file for analysis in src under data_management

4. a stata do file for analysis calculating treatment effects for the survey data, outputs .jpg pictures of the regression results in src under analysis

5. a python file for analysis calculating treatment effects for the survey data, outputs .jpg pictures of the regression results in src under analysis

6. a .tex file in which I discuss the main differences I found between the used python libraries and stata in paper folder

7. Output directories for the cleaned dta sets in src under data_cleaned as well as the output tables and figures of the analysis in bld


# How to use the repository 

You open the stata do file for datamanagement (and change the directory to data?) and execute it. You open the jpnb for datamanagement (put in the links for your paths on top and bottom?) and run it.
You open the stata do file for analysis (and change the directory to data_cleaned?) and execute it. You open the jpnb for analysis (put in the links for your paths on top and bottom to data_cleanend?) and run it.
You open the .tex in the paper folder and convert it to pdf.  



