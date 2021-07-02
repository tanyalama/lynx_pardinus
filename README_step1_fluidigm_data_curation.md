---
title: 'fluidigm_SNP_data_curation'
disqus: hackmd
---

Fluidigm Data Curation
===
Fluidigm es una plataforma que....chipseq 96 muestras x 96 SNPs...(cite David TFM). Este es un pipeline bioinformatico para extraer raw data de la plataforma fluidigm y biomark. Curation del formato y calculación de tasas de error de genotipado y generación de genotipos consenso. 

## Objective
Execute a data extraction and curation pipeline for chipseq data (cite Objective of proyecto LIFE) monitoreo no-invasivo de populaciones de lince iberico etc etc.

## Table of Contents
[TOC]

## Dependencies
1. [Biomark & EP1 Software](https://fluidigm-owncloud.s3-us-west-2.amazonaws.com/Biomark.zip) (Fluidigm Corporation, San Francisco, CA, USA) (PC only or Mac with parallels) 
2. [GIMLET v1.3.3 ](https://pbil.univ-lyon1.fr/software/Gimlet/gimlet%20frame1.html) (PC only) Valière N. 2002. GIMLET: a computer program for analysing genetic individual identification data.
Molecular Ecology Notes. 2(3): 377-379
3. [RStudio version 1.4.1717](https://www.rstudio.com/) 

## References
paper
paper
paper
## Step 0. Sample and Assay Setup.
Previusly of running the assay you can design a setup and annotate your sample, tag and allele names using a provided Microsoft Excel in the Biomark™ System, Biomark™ HD System, or EP1™ system computer. 
### Sample Setup

Follow the instructions of the guide: 

1. On your Biomark™ System, Biomark™ HD System, or EP1™ system computer, go to C:\Program Files\Fluidigm\BiomarkGenotypingAnalysis\ApplicationData\FileFormts.

2.  Open the file labeled “SamplePlateDefinitionForMoreS”.
 
 - You may have to enable Active X. To do so:
 Click on the Options tab. Select “Enable this content” from the Microsoft Office Security Options dialog box.

3. Edit the Microsoft Excel template to match your experiment.

    ![](https://i.imgur.com/ZS345Al.png)

4.  Click Create Plate CSV File button.

    ![](https://i.imgur.com/Y0pAcIO.png)

5. Open the new tab and double check your annotations.
6. Click Save to a CSV file button to save the file and select a convenient location for future retrieval

This setup method is highly recommended in order to have a great organized sample setup. You would have in the final csv file a huge ammount of useful information about the run for the post analysis; Well location, Sample Name, Sample concentration, Sample type. 

Once you have created the sample setup you can easily import it to the SNP Genotyping Software of Fluidigm; click Sample Setup> New > (Window: Are you sure that you want to erase the current sample setup and creat a new one?) click yes > (Window: Sample Plate Setup Wizard) click ok. 
Then you just have to copy the cells in your .csv file with the names of the samples and then paste it into the sample setup window, providing the next information to the software.

![](https://i.imgur.com/TF7O8yg.png)

In Data item you can select 
 
 - Sample Name. e.g: "S01_Nairobi"
 - Sample ID 
 - Sample Type. 3 possibilities: "Unknown" "NTC" "Control"

Also you need to provide a proper "sampling Map" *.dsp (dispense mapping file) In our particular case for a Juno 96.96 genotyping IFC run, we used "Juno96x96-Sample-SBS96.dsp" map file. 

### Assay Setup 

1. On your Biomark™ System, Biomark™ HD System, or EP1™ system computer, go to C:\ProgramFiles\Fluidigm\BiomarkGenotypingAnalysis\ApplicationData\FileFormats.
2. Open the file labeled “AssayPlateDefinitionForMoreS”.

![](https://i.imgur.com/frFi2HX.png)

3. Edit the Microsoft Excel file to match your experiment.
4. Click Create Plate CSV File button.
A new tab labeled “CSV file” will be added to the Excel file.
5. Open the new tab and double check your annotations.
6. Click Save to a CSV file button to save the file and select a convenient location for future retrieval.

Once you have created the assay setup you can import it to the SNP Genotyping Software of Fluidigm with similar method of sample setup. You just have to copy the allele X and Y names and paste in the software plate and the same for Assay names. 

## Step 1. Data Extracton 
Data is extracted directly from the desktop computer in LEM3. <working directory is /pcr. In particular we need input files *.bml < describe contents of PCR folder> 

## Step 2. SNP Genotype data analysis. 


(see SNP Genotyping User Guide (68000098 Rev.18) in the github repository for instructions)
Launch Biomark & EP1 Software and open the run results using File>Open>*/ChipRun.bml

1. Click Sample Summary View. 
2. Set Confidence Threshold and click Analyze. The Sample Summary should then populate with genotypes

You can scroll through each SNP to review discriminant analysis plots (clusters) for all heterozygous, homozygous, homozygous alternate, NO CALL and INVALID CALL calls at each sample x snp. 


#### Normalize data and plot views. 
We can adjust de data normalization method using the window on the left "Analysis settings". 
![](https://i.imgur.com/PSfdggR.png)



* **SNPtype normalization**: is the default option for chip runs using Fluidigm SNP
Type Assays. This option determines a global NTC setting from the NTCs
across the chip run. In cases where there are no NTCs defined, this option
will estimate the location of the NTC.


Plot view - hiding invalids 

![](https://i.imgur.com/wM7n8ia.png)


Plot view - showing invalids 

![](https://i.imgur.com/m0SDstY.png)

* **NTC normalization** : This option
makes viewing assays on the plotted graphs easier, because it normalizes the
position of the no template control cells. The no template control cells are
aligned to the x = 0.1 and y = 0.1 location on the plotted graph. It also
normalizes the intensities of the assays so that they are roughly plotted in a
square.

Plot view - Hiding invalids

![](https://i.imgur.com/HQFciTh.png)
 
Plot view - showing invalids

![](https://i.imgur.com/nSbdbGc.png)

Using this method the NTC cluster shows more relatedness within the global of NTC samples. Furthermore, the allele clusters are also better defined. 

In both methods our run showed a lot of invalid chambers (meaning of invalid explained bellow). This invalids "corresponden" with a group of failed assays (SNPs - see the picture bellow)

![](https://i.imgur.com/GzdlXqv.png)

The orange vertical lines are the SNPs amplification falied assays. 
    


## Step 3. Export raw data output from Fluidigm SNP genotyping software.
Using File>Export we can export data from Fluidigm in one of four formats: 
* Summary table view 
* Detailed table view -- **this is the type that we want**
* Call Map View
* Detailed table view, with raw data

Export the raw data in *.csv and save as "All Files". 

Rather than opening directly, open a blank excel sheet and go to Data>Get External Data> from Text to load the fluidigm data into excel with columns delimited by ";". Start import on line 16.


## Step 4. Convert *.csv to GENEPOP format
This can easily be performed manually following the example in /github/data/*.csv

¡Important! 

Allele correspondeces from A,G,T,C to GENEPOP format 0,1,2,3,4. No Call and Invalid Call are both treated as missing (000)


| A   | G   | C   | T   | Missing | 
| --- | --- | --- | --- | ------- | 
| 001   | 002   | 003   | 004   | 000       | 


### Step 5. Install GIMLET software
download the normal (non beta version) of gimlet
unzip with WINZIP
choose a directory (change to another directory)
click the little computer icon (there is no other button, it's a little weird)

Generating consensus genotypes is the process that allows researchers to determine the genotype of a SNP locus from non invasive, low quality and replicated samples, for instance scats, hair, ... (Cite). The procces requires a minimun of two reads for a single individual to call a heterozygote and a minimum of three reads to make a homozygous or homozygous alternete SNP call (decission-based). 
 
## Step 3. Calculating genotyping error in Gimlet
<luis></luis>

## Summary of results
    ###comparing thresh 1 and thresh 2
    ###genotyping error
    ### Godoy unexpected matches

## Next Steps
likelihood-based match pairing (Tanya)
Joining 22.06.2021 data with David's data from  2019.





## Appendix and FAQ
## 1. Genotype Consensus and Genotyping Error Rate in R
<Tanya> </Tanya>
:::info
**Find this document incomplete?** Leave a comment!
:::

###### tags: `lynx pardinus` `fluidigm` `genotyping` `SNP` `match probability`
