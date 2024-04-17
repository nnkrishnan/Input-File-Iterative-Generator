# Abaqus Input File Iterative Editing Script
## Overview
This script is designed to assist users in generating multiple iterations of Abaqus input files with variations in specific parameters. It aims to simplify the process of creating input files for iterative simulations, where small changes need to be made to the input file for each simulation run.

## Requirements
Operating System: Linux (Debian or Ubuntu recommended)
Dependencies: bc utility for floating-point arithmetic
Installation
Ensure that the bc utility is installed on your system. If not, you can install it using the following command on Debian or Ubuntu:
```sudo apt-get install bc```

Download the inpIterativeGen script and make it executable:
```chmod +x inpIterativeGen.sh```

## Usage
Place your original Abaqus input file (filename.inp) in the same directory as the script or you can add the script to your system or user path and use if from any directory.
```inpIterativeGen```

Follow the prompts to specify the input file, line number, new text with ^i placeholder, initial value of i, maximum value of i, and step size.

The script will create multiple copies of the input file with appended filenames based on the variations of i and edit each copy with the specified new text.


## Notes
Ensure that the input file and script are in the same directory.
Verify the bc utility is installed before running the script.
Make sure to provide valid inputs for a smooth execution.
No warranty. Please verify the files generated before using
⚠ The script will overwrite files in the directory if a conflict exists