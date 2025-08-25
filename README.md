# GAnGA

**GAnGA** is an automated, open-source, and user-friendly command-line pipeline built with [Snakemake](https://snakemake.github.io/) for assembling and annotating bacterial whole-genome sequencing (WGS) data. It enables minimal manual intervention, hassle-free installation, and multi-genome analysis in a single step.

The pipeline performs:
- Preprocessing of raw reads
- _De novo_ assembly
- Quality analysis of draft genomes
- Gene prediction
- Taxonomic and functional annotation

**GAnGA** supports:
- Paired-end short reads, single-end long reads, and hybrid sequencing data
- Illumina, Oxford Nanopore, and PacBio platforms
- Analysis of unlimited genomes in one go

It produces a comprehensive, human-readable **HTML report** summarizing all results.

## System Requirements
- Atleast 130 Gb disk space where you are installing GAnGA
- Minimum 16 Gb memory
- Minimum 8 cores
- Uninterupted internet is difficult to get but you have it you will be though in no time! (>50 mbps speed)

## Requirements

###  Install miniconda3
To install ```miniconda3```, use the following commands:
```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
~/miniconda3/bin/conda init bash
```

###  Add Channels
To configure your Conda environment with the necessary channels, run the following commands in the specified order:
```
conda config --add channels https://repo.anaconda.com/pkgs/r
conda config --add channels https://repo.anaconda.com/pkgs/main
conda config --add channels defaults
conda config --add channels ursky
conda config --add channels bioconda
conda config --add channels conda-forge
```
### Important:
The order of channels matters. The correct order should be: ```conda-forge``` → ```bioconda``` → ```ursky``` → ```defaults``` → ```https://repo.anaconda.com/pkgs/main``` → ```https://repo.anaconda.com/pkgs/r```. You can verify the current order using:
```
conda config --show channels
```
If the order is incorrect, re-add them starting from ```https://repo.anaconda.com/pkgs/r``` and add up to ```conda-forge``` last.

If the terms of service have not been accepted for any channel, they should be accepted before proceeding. To accept a channel's Terms of Service, run the following and replace `CHANNEL` with the channel name/URL:
```
conda tos accept --override-channels --channel CHANNEL
Example: conda tos accept --override-channels --channel  https://repo.anaconda.com/pkgs/main
```

###  Update Conda
```
conda update -n base -c conda-forge conda -y
```

###  Install System Dependencies (for R and Bioinformatics Tools)

### Ubuntu / Debian

```bash
# Install system dependencies
sudo apt-get update && sudo apt-get upgrade
sudo apt install python3-pip build-essential cmake gfortran gobjc gobjc++ gnustep gnustep-devel libbz2-dev liblzma-dev libpcre2-dev libcurl4-openssl-dev libcairo2-dev libtiff5-dev libreadline-dev libxml2-dev libharfbuzz-dev libfribidi-dev libglpk-dev libgsl-dev libgmp-dev libmpc-dev libudunits2-dev libgdal-dev libmagick++-dev

# Additional image libraries
sudo apt install libfreetype6-dev libpng-dev libjpeg-dev gcc g++

# Required to install LaTex
sudo apt-get update && sudo apt-get install -y texlive-full pandoc

# Conda-based install
conda install -c conda-forge pkg-config
```

## Installation 
### 1. Download the repository
Download the repository in the location where you have atleast 130 GB of disk space
```
git clone https://github.com/DDOmicsLab/GAnGA.git
cd GAnGA
```

### 2. Use the yaml file to create environment
```
conda env create -f environment.yaml -n ganga
```
### 3. Activate the environment 
```
conda activate ganga
```

### 4. Pipeline Setup

#### i) MobileOG-db download (Mandatory)
  Download the mobileOG database from the [mobileOG](https://mobileogdb.flsi.cloud.vt.edu/entries/database_download) website.
  
  Click on ```Download All Data``` under the ```Beatrix 1.6 v1 Current Version``` tab
  
#### ii) Installation (Recommended)
Run the following command to install all required tools and databases.
Make sure you have atleast 50GB of space for the installation. 
This steps installs all the necessary softwares and required databases inside the GAnGA directory


Replace ```/path/to/mobileOGdb/beatrix-1-6_v1_all.zip``` with the actual path to the file downloaded in Step i:
```
cd path/to/GAnGA
snakemake -s setup_snakefile --use-conda --cores 8 --config mobileog_db_download_path=/path/to/mobileOGdb/beatrix-1-6_v1_all.zip
```
### OR
#### ii) Alternative: Two-Step Installation (for Slow Internet)
 
If you have a weak or unstable internet connection, install GAnGA in two separate steps:
  1) Install tools
```
  snakemake -s tools_snakefile --use-conda --cores 8 --config mobileog_db_download_path=/path/to/mobileOGdb/beatrix-1-6_v1_all.zip
```
  2) Install databases
```
  snakemake -s db_snakefile --use-conda --cores 8 
```

## Usage
To get started, you’ll need just two things:

**1) Raw reads**

**2) Reference genome (required for assembly improvement and taxonomic identification)**
   
If you already know the reference genome — _VOILÀ_! — you can move directly to the execution step.

But if you don’t, no worries — we’ve got you covered! Follow the steps below to identify your reference genome.

### Finding the reference genome
#### 1. Set the output directory and add genome information in ```16S_config.yaml file``` file present in the ```configfiles``` directory
Example:
```
#Directory where the output is expected
outdir: "/path/to/output/directory"

#List all the samples with the global path to their raw reads
samples:
  Name_of_genome_1:
    R1: "/path/to/short_raw_reads/R1.fastq.gz"
    R2: "/path/to/short_raw_reads/R2.fastq.gz"
```
#### 2. Run the pipeline
Note: Make sure that your environment is activated
```conda activate ganga```
```
cd path/to/installation/directory/GAnGA
mv snakefiles/16S_snakefile configfiles/16S_config.yaml ./
snakemake -s 16S_snakefile --configfile 16S_config.yaml --use-conda --cores 8
```
```{genome}_rrna.fa``` saved in ```11_barrnap``` directory in the ```output_directory``` will contain the 16S sequence

Note: For long-read data, use the ```16S_longsnakefile``` and ```16S_longconfig.yaml``` files.

3. Run ```blastn``` against rRNA/ITS databases at [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) or [NCBI Genomes](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&BLAST_SPEC=MicrobialGenomes) with the 16S rRNA sequence as the query sequence
4. Select and download the complete reference genome in **FASTA format**.

### Execution
Tip: You can add the --dry-run flag to any snakemake command to verify that everything is configured correctly before actual execution. This helps detect missing files, incorrect paths, or rule mismatches without running any jobs.
### Short Reads
#### 1. Set the output directory and add genome information in ```short_config.yaml``` file present in the ```configfiles``` directory
Example:
```
#Directory where the output is expected
outdir: "/path/to/output/directory"

#List all the genomes with their information (Mention the global paths of R1, R2 and reference_fasta)
samples:
  Name_of_genome_1:
    R1: "/path/to/short_raw_reads/R1.fastq.gz"
    R2: "/path/to/short_raw_reads/R2.fastq.gz"
    genus: "Genus"
    species: "species"
    reference_fasta: "/path/to/ref/reference.fasta"

```
**Note: Make sure that the reference file are in FASTA format only (.fasta)**

#### 2. Run the pipeline
```
cd path/to/installation/directory/GAnGA
mv snakefiles/short_snakefile configfiles/short_config.yaml ./
snakemake -s short_snakefile --configfile short_config.yaml --use-conda --cores 8
```

### Long reads 
#### 1. Mandatory Configuration Before Running the Pipeline
In the config.yaml, you must specify the ```sequencing type``` for Flye and the ```ax``` preset for Minimap2.
If these are not set correctly, the pipeline execution will fail.
Example:
```
  Flye: 
    options: "-t 8"
    sequencing_type: ""# REQUIRED: set sequencing type
                       # Options:
                       #   --nano-raw   : raw Oxford Nanopore reads
                       #   --nano-corr  : corrected Nanopore reads
                       #   --pacbio-raw : raw PacBio reads
                       #   --pacbio-corr: corrected PacBio reads
                       #
                       # Refer to Flye documentation for more details for raw and corrected reads:
                       # https://github.com/mikolmogorov/Flye/blob/flye/docs/USAGE.md
  Minimap2:
    options: "-t 8"
    ax: ""# REQUIRED: set preset depending on sequencing platform
          #   map-ont : for Oxford Nanopore
          #   map-pb  : for PacBio
```
#### 2. Set the output directory and add genome information in ```long_config.yaml``` file present in the ```configfiles``` directory
Example:
```
#Directory where the output is expected
outdir: "/path/to/output/directory"

#List all the genomes with their information (Mention the global paths of R1 and reference_fasta)
samples:
  Name_of_genome_1:
    R1: "/path/to/long_raw_reads/R1.fastq.gz"
    genus: "Genus"
    species: "species"
    reference_fasta: "/path/to/ref/reference.fasta"

```
#### 3. Run the pipeline
```
cd path/to/installation/directory/GAnGA
mv snakefiles/long_snakefile configfiles/long_config.yaml ./
snakemake -s long_snakefile --configfile long_config.yaml --use-conda --cores 8
```

### Hybrid reads
#### 1. Set the output directory and add genome information in ```hybrid_config.yaml``` file present in the ```configfiles``` directory
Example:
```
#Directory where the output is expected
outdir: "/path/to/output/directory"

#List all the genomes with their information (Mention the global paths of R1, R2, L1 and reference_fasta)
samples:
  Name_of_genome_1:
    R1: "/path/to/short_raw_reads/R1.fastq.gz"
    R2: "/path/to/short_raw_reads/R1.fastq.gz"
    L1: "/path/to/long_raw_reads/R1.fastq.gz"
    genus: "Genus"
    species: "species"
    reference_fasta: "/path/to/ref/reference.fasta"

```
#### 2. Run the pipeline
```
cd path/to/installation/directory/GAnGA
mv snakefiles/hybrid_snakefile configfiles/hybrid_config.yaml ./
snakemake -s hybrid_snakefile --configfile hybrid_config.yaml --use-conda --cores 8
```

## Required dependencies: will be automatically installed while executing the pipeline
* [FastQC](https://github.com/s-andrews/FastQC)
* [Trimmomatic](https://github.com/timflutre/trimmomatic)
* [Unicycler](https://github.com/rrwick/Unicycler)
* [CheckM](https://github.com/Ecogenomics/CheckM)
* [FastANI](https://github.com/ParBLiSS/FastANI)
* [pocp](https://github.com/hoelzer/pocp)
* [EzAAI](https://github.com/endixk/ezaai)
* [RagTag](https://github.com/malonge/RagTag)
* [BWA](https://github.com/lh3/bwa)
* [Pilon](https://github.com/broadinstitute/pilon)
* [Barrnap](https://github.com/tseemann/barrnap)
* [Prodigal](https://github.com/hyattpd/Prodigal)
* [Bakta](https://github.com/oschwengers/bakta)
* [RGI](https://github.com/arpcard/rgi)
* [Phigaro](https://github.com/bobeobibo/phigaro)
* [mlst](https://github.com/tseemann/mlst)
* [mobileOG](https://github.com/clb21565/mobileOG-db?tab=readme-ov-file)
* [CRISPRcasIdentifier](https://github.com/BackofenLab/CRISPRcasIdentifier)
* [PanViTa](https://github.com/dlnrodrigues/panvita)
* [GenoVi](https://github.com/robotoD/GenoVi)
* [chopper](https://github.com/wdecoster/chopper)
* [Flye](https://github.com/mikolmogorov/Flye)
* [Minimap2](https://github.com/lh3/minimap2)
* [Racon](https://github.com/isovic/racon)








