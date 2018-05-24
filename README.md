# Ischemic-changes-analysis
Ischemic changes analysis (ST-segment depression) program with test signals

# Basic Overview
Program detects ST-segment changes like in image below.
![cad012 ecg st depression](https://user-images.githubusercontent.com/36335477/40440207-167beb00-5ec6-11e8-868b-f1c2a0af0fea.png)

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
```
Matlab r2017a or later -> https://www.mathworks.com
Matlab Signal Processing Toolbox -> https://www.mathworks.com/products/signal.html
```
### Installing
```
Load all files in same folder
Open Kurs.m
Push "Run" button
Push "Change Folder" if needed
```
## Running the tests
```
Push "Load ECG" button and load one of the *.mat files
In settings:
 1. Choose name of the patient
 2. Check filter if needed
 3. Choose sampling frequency
 4. Choose signal duration to work with
 5. Check "Ok"
You can load new signal choosing "Load new signal" button
You can see steps of ecg analyse checking buttons:
 1. Baseline
 2. Averaging
 3. ST-analys
 4. Results
```
# Methods

## Baseline drifting
First thing to do - we must remove baseline drifting.

```
Program uses Pan-Tompkins algorithm for R-peaks detecting 
Then program calculates T-peak location relative to the R-peak
Now we know characteristic points of signal and can remove baseline using cubic spline interpolation
```
<img width="1266" alt="2018-05-23 21 12 23" src="https://user-images.githubusercontent.com/36335477/40443241-5eb8604e-5ece-11e8-8773-1ee645d4267c.png">

## Averaging signal
We average signal to remove noise and find mean ST-change

```
Program detects boards of each QRS-complex
Then we need to sum all QRS-complexes and divide to the count of QRS
```
<img width="1140" alt="2018-05-23 21 24 08" src="https://user-images.githubusercontent.com/36335477/40443670-bbe9ba14-5ecf-11e8-8ce4-f094b5a0bae5.png">

## ST-change graphics
```
Program analysis 3 points of ST-segment (60 ms, 80 ms, 100 ms offset from R-peak)
Now we can use these graphics to classify type of ischemic change
ST-change graphics are represented in image below
```
<img width="1264" alt="2018-05-23 21 30 04" src="https://user-images.githubusercontent.com/36335477/40443959-972e6cfa-5ed0-11e8-8009-11e3c27cdafe.png">

# Authors

* Eldar Shayahmetov, eldarsharpey@gmail.com
