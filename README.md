ExScaliburViz
=============

Reporting and visualization tool for ExScaliburSMD and ExScaliburGMD

## Getting Started

After you have successfully run an ExScalibur project, you will need to move the `report` directory to your local computer. Once, you have moved the directory, you will need to download the `ExScaliburViz` zip file from the github web page and unzip it to you local computer.

## Running ExScaliburViz

ExScaliburViz runs in two modes: command line or loading through a source file.

### Command Line Interface

blah blah

### R Source File

First, you need to open up an R instance. Then, you can follow this example code:

```
exdir <- "/Path/to/ExScaliburViz"
setwd(exdir)
source("/Path/to/ExScaliburViz/ExScaliburVizFunc.R")
myYamlFile <- "/Path/to/reporter/project.yml"

# Load the Vizualizer
ExScaliburViz(myYamlFile, reporter.type = "GMD")
```
