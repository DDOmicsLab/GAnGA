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


## Requirements

###  Install miniconda3
To install ```miniconda3```, use the following commands:
```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
~/miniconda3/bin/conda init bash
```

###  Update Conda
```
conda update -n base -c conda-forge conda -y
```

###  Add Channels
```
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels ursky
conda config --add channels defaults
conda config --add channels https://repo.anaconda.com/pkgs/main
conda config --add channels https://repo.anaconda.com/pkgs/r
```

###  Install System Dependencies (for R and Bioinformatics Tools)
<details>
<summary><strong>Ubuntu / Debian</strong></summary>

```bash
# Install system dependencies
sudo apt update
sudo apt install python3-pip build-essential cmake gfortran gobjc gobjc++ gnustep gnustep-devel libbz2-dev liblzma-dev libpcre2-dev libcurl4-openssl-dev libcairo2-dev libtiff5-dev libreadline-dev libxml2-dev libharfbuzz-dev libfribidi-dev libglpk-dev libgsl-dev libgmp-dev libmpc-dev libudunits2-dev libgdal-dev libmagick++-dev

# Additional image libraries
sudo apt install libfreetype6-dev libpng-dev libjpeg-dev gcc g++

# Conda-based install
conda install -c conda-forge pkg-config
```
</details>

<details>
<summary><strong>macOS (Homebrew)</strong></summary>

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew install python@3.12 cmake gcc pcre2 xz bzip2 curl cairo libtiff readline libxml2 harfbuzz fribidi gsl gmp mpc udunits gdal imagemagick libjpeg libpng freetype pkg-config

# Conda-based install
conda install -c conda-forge pkg-config
```

</details>

<details>
<summary><strong>RedHat / CentOS / Fedora</strong></summary>

```bash
# Enable EPEL and install development tools
sudo dnf install epel-release
sudo dnf groupinstall "Development Tools"

# Install required packages
sudo dnf install python3-pip cmake gcc-gfortran gcc-objc gnustep gnustep-make bzip2-devel xz-devel pcre2-devel libcurl-devel cairo-devel libtiff-devel readline-devel libxml2-devel harfbuzz-devel fribidi-devel glpk-devel gsl-devel gmp-devel libmpc-devel udunits2-devel gdal-devel ImageMagick-c++-devel freetype-devel libpng-devel libjpeg-devel

# Conda-based install
conda install -c conda-forge pkg-config
```

</details>

<details>
<summary><strong>openSUSE</strong></summary>

```bash
sudo zypper refresh
sudo zypper install python3-pip gcc-fortran gcc-objc cmake gnustep gnustep-make libbz2-devel xz-devel libpcre2-devel libcurl-devel cairo-devel libtiff-devel readline-devel libxml2-devel harfbuzz-devel fribidi-devel glpk-devel gsl-devel gmp-devel libmpc-devel libudunits2-devel gdal-devel ImageMagick-c++-devel freetype-devel libpng-devel libjpeg-devel

# Conda-based install
conda install -c conda-forge pkg-config
```

</details>

<details>
<summary><strong>Windows (PowerShell)</strong></summary>

```powershell
# Install Chocolatey (run in Administrator PowerShell)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install python cmake mingw imagemagick -y

# Conda-based install
conda install -c conda-forge pkg-config

# Update pip and setuptools
python -m pip install --upgrade pip setuptools wheel
```

```
> For full C/C++ support, you may also need to install Microsoft Build Tools.

> For full C/C++ support, you may also need to install Microsoft Build Tools.
```
</details>

## Installation 
### 1. Download the repository
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

Replace ```/path/to/mobileOGdb/beatrix-1-6_v1_all.zip``` with the actual path to the file downloaded in Step i:
```
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
#### 1. Set the output directory and add genome information in ```16S_config.yaml file```
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
```
snakemake -s 16S_snakefile --configfile 16S_config.yaml --use-conda --cores 8
```
```{genome}_rrna.fa``` saved in ```11_barrnap``` directory in the ```output_directory``` will contain the 16S sequence

Note: For long-read data, use the ```16S_longsnakefile``` and ```16S_longconfig.yaml``` files.

3. Run ```blastn``` against rRNA/ITS databases at [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) with the 16S rRNA sequence as the query sequence
4. Select and download the complete reference genome in **FASTA format**.

### Execution
Tip: You can add the --dry-run flag to any snakemake command to verify that everything is configured correctly before actual execution. This helps detect missing files, incorrect paths, or rule mismatches without running any jobs.
### Short Reads
#### 1. Set the output directory and add genome information in ```short_config.yaml```
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
snakemake -s short_snakefile --configfile short_config.yaml --use-conda --cores 8
```

### Long reads 
#### 1. Set the output directory and add genome information in ```long_config.yaml```
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
#### 2. Run the pipeline
```
snakemake -s long_snakefile --configfile long_config.yaml --use-conda --cores 8
```

### Hybrid reads
#### 1. Set the output directory and add genome information in ```hybrid_config.yaml```
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








