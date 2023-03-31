# eppfinalproject_moritzraykowski
The path switches I make in my files are built on Path.home / 'Desktop' / 'epp_repo'
I did not get a automated pytask template running, thus I tried to build as automated files as possible. 
So if you clone this repository into a folder named epp_repo on your desktop everything should run smoothly!

I provide a comparison in data management/manipulation and analysis (regressions) and their plotting between python and stata to see which utilities from each program might be missing in the other one and might be helpful for the future.



This repository contains the following:

1. a raw data excel file containing survey answers from a survey experiment extracted from qualtrics in src under data

2. a stata do file for data mangement in which the raw data is cleaned, outputs a ready to be used .dta file for analysis in src under data_management

3. a python file for data management in which the raw data is cleaned, outputs a ready to be used .xls file for analysis in src under data_management

4. a stata do file for statistics in src under analysis calculating treatment effects for the survey data, outputs .jpg pictures of the regression results and lee bounds table in bld under tables_statapython and figures_statapython

5. a python file for statistics in src under analysis calculating treatment effects for the survey data, outputs .jpg pictures of the regression results in bld under figures_statapython

6. a .tex file in which I discuss the main differences I found between the used python libraries and stata in paper folder

7. Output directories for the cleaned dta sets in src under data_cleaned as well as the output tables and figures of the analysis in bld

# How to use the repository 

Since I did not get cookiecutters going correctly, I tried to automate my project as much as possible through code within the files and brought the effort of someone replicating my work down to ~15 clicks.

1. You clone the repository into a folder named epp_repo on your desktop. This is the easiest way to not have to replace paths manually within the files. I used pathlib and os in python to access the root and specified Desktop and epp_repo as parent folders of the repository. In stata All code used to switch directories in stata is currently made active to work on macOS and Linux, I wrote the windows equivalents right next to the code each time but deactivated.

2. You activate the environment epp_finpro_env.yml. Select it as a kernel for the ipynb files for data management 
and analysis. 

3. You open the file datamanagementpython.ipynb and select the environment as a kernel. Then you run the file, then exit. Cleaned data is created.


4. You open the stata file statadatamanagement.do and execute it (on the top menu is a play button) then exit.  Cleaned data is created again but via stata as .dta.

5. You open the analysispython.ipynb and run it, then exit. Graphs are created and stored.

6. You open the stata file analysisstata.do and execute it, then exit. Graphs and tables are created and stored.

Cleaned data and outputs by both softwares are now in their dedicated folders.

7. You open the .tex in the paper folder and convert it to pdf. It contains the generated plots and tables. 

