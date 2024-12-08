# EMG_SignalProcessing README File

## Overview

The **EMG_SignalProcessing** MATLAB code provides a comprehensive workflow for processing Electromyographic (EMG) signals. It is also adaptable for other biological signals, such as ECG or EEG. This code was made to design different filters and test them on a specific signal of interest to compare which of these filters will be the more adequate to use for the actual data collection of your study. It offers functionalities for data importation, signal preparation, filtering, and visualization, making it suitable for researchers and practitioners working in biomedical signal processing.

---

## Features

- **Data Importation**: Supports file formats including `.mat`, `.xls`, `.xlsx`, `.csv`, and `.txt`.
- **Signal Preparation**: Isolates specific sections of interest from the raw signal.
- **Signal Analysis**: Performs time domain and frequency domain analysis (amplitude over time, magnitude, power, and phase of the frequency spectrum).
- **Filter Design and Signal Processing**:
   - Linear Envelope generation
   - Band-Stop (Notch) Filters (but can be change to any other type of filter)
   - Band-Pass Filters (but can be change to any other type of filter)
- **Visualization**: Produces detailed plots to compare raw and processed signals as well as the different filter designs between them in the time and frequency domains.
- **Combined Filtering**: Applies multiple filters in sequence and evaluates the combined effect.

---

## Prerequisites
### MATLAB Toolboxes
- Signal Processing Toolbox
### MATLAB Functions Included with this code
- `filtering.m`: Applies Band-Stop or Band-Pass filters and generates processed signals.
- `section1.m`: Handles data importation from supported file formats.
- `section3.m`: Performs frequency-domain analysis of raw signals.
- `section9.m`: Combines multiple filtering methods and generates final outputs.

---

## Installation
0. Install the MATLAB `Signal Processing Toolbox` (see MATLAB website for more indications on the steps to take)
1. Download the MATLAB files: `EMG_SignalProcessing.m`, `filtering.m`, `section1.m`, `section3.m`, `section9.m`.
2. Place all files in the same directory.
3. Open MATLAB and navigate to the directory containing the files.

---

## Usage
1. Open the `EMG_SignalProcessing.m` file in MATLAB.
2. Modify the parameters as needed in all the `DATA PREPARATION` parts, such as:
   - File path of the signal data (`filePath` variable in `DATA PREPARATION` of Section 1).
   - Sampling frequency (`fs` variable in `DATA PREPARATION` of Section 2).
   - Filter parameters (e.g., cutoff frequencies, filter type, ... in `DATA PREPARATION` of Section 5 and 6)
   - And so on
3. Run the script, either the whole code once every `DATA PREPARATION` section is set or section by section

---

## Customization ideas

- Modify `filtering.m` to experiment with even more different filter designs.
- Add your custom visualization in `section9.m`.

---

## Acknowledgments

Developed by **Laurence Poirier** in the context of UBC M.Sc. Class `KIN501` 
Last Updated: **December 7, 2024**

---

## License
EMG_SignalProcessing is licensed under the GNU Affero General Public License v3.0. This code is provided as-is for educational and research purposes. Use and modify at your own risk. Proper citation of this repository in academic work is strongly appreciated, for all the hours and efforts put into this work by the developer. Hope it can help you out with your data processing and analysis!

