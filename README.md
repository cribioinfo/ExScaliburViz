ExScaliburViz
=============

Reporting and visualization tool for ExScaliburSMD and ExScaliburGMD

## Requirements

You should have R >=3.0.0 installed! In addition, the following packages are required:

* yaml (>= 2.1.13)
* shiny (>=0.11.1)
* shinythemes (>=1.0.1)
* ggplot2
* reshape2
* plyr
* tools

## Getting Started

You will need to clone the ExScaliburViz repository:

```
#!bash

git clone https://kmhernan@bitbucket.org/cribioinformatics/exscaliburviz.git
```


## Running ExScaliburViz

ExScaliburViz runs in two modes: command line or loading through a source file.

### Command Line Interface

```
$ ./ExScaliburVizCLI.R 
[CRI] [INFO] [2015-04-01 15:44:58] - --------------------------------------------------------------
[CRI] [INFO] [2015-04-01 15:44:58] - ExScaliburViz.R - Dynamic reporting of ExScalibur Projects
[CRI] [INFO] [2015-04-01 15:44:58] - Kyle Hernandez, Center for Research Informatics, University of Chicago
[CRI] [INFO] [2015-04-01 15:44:58] - --------------------------------------------------------------

Usage: ExScaliburViz.R --config <config.yml> --type [SMD|GMD]
	config	The FULL path to the configuration YAML file (must be the full path!!)
	type	Either 'SMD' or 'GMD' depending on the type of ExScalibur pipeline
```


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