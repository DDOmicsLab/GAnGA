**GAnGA Tutorial**

In this tutorial, you will get to learn to
    - Find a reference genome
    - Set up and execute GAnGA for short, long and hybrid - sequencing data
    - Understand Report and navigate between the results

Let us start with short reads data

For this we are considering 3 different genomes : ***Bifidobacterium longum*** (probiotic), ***Eshcherichia coli K-12*** (non-probotic, non-pathogenic) and ***Klebsiella pneumoniae*** (pathogenic)

Please run the following bash script ```get_sra.sh``` to download the raw reads

```
cd tutorial
bash get_sra.sh
```

Once you have your raw-reads ready, it's time to move ahead with setting up the config files


### GAnGA installation

If you install GAnGA in ```/home/user/```, the installation directory will be ```/home/user/GAnGA```.
For simplicity, throughout this tutorial we will refer to the GAnGA installation directory as:

```/home/user/GAnGA```

In this tutorial, all required tools and databases will also be downloaded into ```/home/user/GAnGA``` for convenience. The complete setup requires approximately 105 GB of disk space (≈85 GB for databases and ≈20 GB for tools).

Please ensure that your ```$HOME``` directory has sufficient free space available. If adequate space is not available in ```$HOME```, you may specify alternative directories where sufficient storage is available. Just make sure to provide the correct paths in the ```setup_config.yaml``` file.


```
cd path/to/GAnGA
cp configfiles/setup_config.yaml snakefiles/envs_snakefile snakefiles/tools_snakefile snakefiles/db_snakefile ./
```

```
# setup_config.yaml
#Set parameters or options for setup
#these are the default parameters, only change if you know what you're doing
parameters:
  path_to_db_dir: "/home/user/GAnGA" # Mention path of the directory where you want to store databases which take up around 85GB space
  path_to_tools_dir: "/home/user/GAnGA" # Mention path of the directory where you want to store tools which take up around 20GB space
  mobileog_db_download_path: "/home/user/Downloads/beatrix-1-6_v1_all.zip"  # Replace with the actual path to the mobileOG file downloaded
```

After configuring the ```setup_config.yaml``` file, run the following commands to complete the installation:

```
snakemake -s envs_snakefile --use-conda --cores 8
snakemake -s tools_snakefile --configfile setup_config.yaml --use-conda --cores 8
snakemake -s db_snakefile --configfile setup_config.yaml --use-conda --cores 8
mv setup_config.yaml configfiles/
mv envs_snakefile tools_snakefile db_snakefile snakefiles/
```

### GAnGA execution

For executing GAnGA, we need to provide information about the raw reads, reference genome and taxonomic information such as genus and species of the genome to be analysed in the config files. For this you need to know the reference genome for your test genomes first. If you already know it, it's a CHERRY ON CAKE! Just be ready with the FASTA file of complete reference genome. But if you dont, NO WORRIES! We've got you covered. Go to the ```Finding the Reference Genome``` section to find a reference genome for your test genome.

<details>
  <summary><b>🧬 Finding the Reference Genome</b></summary>

### Short Reads  
#### 1. Set the output directory and add genome information as given below in ```16S_config.yaml file``` file present in the ```configfiles``` directory
```
#Directory where the output is expected
outdir: "/home/user/GAnGA/tutorial/output"
path_to_db_dir: "/home/user/GAnGA" #Directory where you have stored databases 
path_to_tools_dir: "/home/user/GAnGA" #Directory where you have stored tools

#List all the samples with the global path to their raw reads
samples:
  B_longum:
    R1: "/home/user/GAnGA/tutorial/short_reads/B_longum/SRR13205517_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/B_longum/SRR13205517_2.fastq.gz"
  E_coli:
    R1: "/home/user/GAnGA/tutorial/short_reads/E_coli/SRR1770413_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/E_coli/SRR1770413_2.fastq.gz"
  K_pneumoniae:
    R1: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/SRR4046827_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/SRR4046827_2.fastq.gz"

```
#### 2. Run the pipeline
Note: Make sure that your environment is activated
```conda activate ganga```
```
cd /home/user/GAnGA
cp snakefiles/16S_snakefile configfiles/16S_config.yaml ./
snakemake -s 16S_snakefile --configfile 16S_config.yaml --use-conda --cores 20
```
```B_longum_rrna.fa``` file saved in ```11_barrnap``` directory in the ```/home/user/GAnGA/tutorial/output/short_reads/B_longum``` will contain the 16S rRNA sequence of B_longum genome 

### Long Reads
Example:

#### 1. Set the paramters, output directory and add genome information as given below in ```16S_longconfig.yaml file``` file present in the ```configfiles``` directory
```
parameters:
  Chopper:
    quality: "7"
    min_length: "500"
  Flye: 
    options: "-t 8"
    sequencing_type: "--nano-corr" 
  Minimap2:
    options: "-t 8"
    ax: "map-ont" #enter map-ont or map-pb based on the sequencing platform used (map-ont for Oxford-Nanopore and map-pb for Pacific Biosciences)
  Racon: 
    options: "-t 8"
  Barrnap: ""

#Directory where the output is expected
outdir: "/home/user/GAnGA/tutorial/output/long_reads"

#list all the samples with their information
samples:
  B_longum:
    R1: "/home/user/GAnGA/tutorial/long_reads/B_longum/SRR24651278_1.fastq.gz"
  E_coli:
    R1: "/home/user/GAnGA/tutorial/long_reads/E_coli/SRR33397843.fastq.gz"
  K_pneumoniae:
    R1: "/home/user/GAnGA/tutorial/long_reads/K_pneumoniae/SRR33323135.fastq.gz"
```
Note: For long-read data, use the ```16S_longsnakefile``` and ```16S_longconfig.yaml``` files.

#### 2. Run the pipeline
Note: Make sure that your environment is activated
```conda activate ganga```
```
cd /home/user/GAnGA
cp snakefiles/16S_longsnakefile configfiles/16S_longconfig.yaml ./
snakemake -s 16S_longsnakefile --configfile 16S_longconfig.yaml --use-conda --cores 20
```
```B_longum_rrna.fa``` file saved in ```11_barrnap``` directory in the ```/home/user/GAnGA/tutorial/output/long_reads/B_longum``` will contain the 16S rRNA sequence of the B_longum genome

3. Run ```blastn``` against rRNA/ITS databases at [NCBI BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome) or [NCBI Genomes](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastSearch&BLAST_SPEC=MicrobialGenomes) with the 16S rRNA sequence as the query sequence
4. Select and download the complete reference genome in **FASTA format**.
</details>



<details>
  <summary><b>📘 Short Reads</b></summary>

```
cd /home/user/GAnGA
cp snakefiles/short_snakefile configfiles/short_config.yaml snakefiles/long_snakefile configfiles/long_config.yaml snakefiles/hybrid_snakefile configfiles/hybrid_config.yaml ./
```

#### 1. Copy the following information in ```short_config.yaml``` file 
```
#Enter complete paths for the following:
outdir: "/home/user/GAnGA/tutorial/output/short_reads" #Directory where the output is expected
path_to_db_dir: "/home/user/GAnGA" #Directory where you have stored databases 
path_to_tools_dir: "/home/user/GAnGA" #Directory where you have stored tools

#List all the genomes with their information (Mention the global paths of R1, R2 and reference_fasta)
samples:
  B_longum:
    R1: "/home/user/GAnGA/tutorial/short_reads/B_longum/SRR13205517_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/B_longum/SRR13205517_2.fastq.gz"
    genus: "Bifidobacterium"
    species: "longum"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/B_longum/Bifidobacterium_longum_subsp_longum_JCM_1217_reference.fasta"
  E_coli:
    R1: "/home/user/GAnGA/tutorial/short_reads/E_coli/SRR1770413_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/E_coli/SRR1770413_2.fastq.gz"
    genus: "Escherichia"
    species: "coli"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/E_coli/E_coli_K12_ref.fasta"
  K_pneumoniae:
    R1: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/SRR4046827_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/SRR4046827_2.fastq.gz"
    genus: "Klebsiella"
    species: "pneumoniae"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/K_pneumoniae_ref.fasta"

```

#### 2. Run the pipeline

##### Dry run is recommended (To check for any missing files, indentation errors or rule blocks)
```
snakemake -s short_snakefile --configfile short_config.yaml --use-conda --cores 20 --dry-run
```

##### Actual run
```
snakemake -s short_snakefile --configfile short_config.yaml --use-conda --cores 20
```
</details>




<details> 
  <summary><b>📗 Long Reads</b></summary>
  
#### 1. Mandatory Configuration Before Running the Pipeline
```
  Flye: 
    options: "-t 8"
    sequencing_type: "--nano-corr"
  Minimap2:
    options: "-t 8"
    ax: "map-ont"
```

```
#Enter complete paths for the following:
outdir: "/home/user/GAnGA/tutorial/output/long_reads" #Directory where the output is expected
path_to_db_dir: "/home/user/GAnGA" #Directory where you have stored databases 
path_to_tools_dir: "/home/user/GAnGA" #Directory where you have stored tools

#List all the genomes with their information (Mention the global paths of R1 and reference_fasta)
samples:
  B_longum:
    R1: "/home/user/GAnGA/tutorial/long_reads/B_longum/SRR24651278_1.fastq.gz"
    genus: "Bifidobacterium"
    species: "longum"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/B_longum/Bifidobacterium_longum_subsp_longum_JCM_1217_reference.fasta"
  E_coli:
    R1: "/home/user/GAnGA/tutorial/long_reads/E_coli/SRR33397843.fastq.gz"
    genus: "Escherichia"
    species: "coli"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/E_coli/E_coli_K12_ref.fasta"
  K_pneumoniae:
    R1: "/home/user/GAnGA/tutorial/long_reads/K_pneumoniae/SRR33323135.fastq.gz"
    genus: "Escherichia"
    species: "coli"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/K_pneumoniae_ref.fasta"

```
#### 3. Run the pipeline
```
snakemake -s long_snakefile --configfile long_config.yaml --use-conda --cores 20
```

</details>




<details>
  <summary><b>📙 Hybrid Reads</b></summary>
  
#### 1. Set the output directory and add genome information in ```hybrid_config.yaml``` file present in the ```configfiles``` directory

```
#Enter complete paths for the following:
outdir: "/home/user/GAnGA/tutorial/output/hybrid_reads" #Directory where the output is expected
path_to_db_dir: "/home/user/GAnGA" #Directory where you have stored databases 
path_to_tools_dir: "/home/user/GAnGA" #Directory where you have stored tools

#List all the genomes with their information (Mention the global paths of R1, R2, L1 and reference_fasta)
samples:
  B_longum:
    R1: "/home/user/GAnGA/tutorial/short_reads/B_longum/SRR13205517_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/B_longum/SRR13205517_2.fastq.gz"
    L1: "/home/user/GAnGA/tutorial/long_reads/B_longum/SRR24651278_1.fastq.gz"
    genus: "Bifidobacterium"
    species: "longum"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/B_longum/Bifidobacterium_longum_subsp_longum_JCM_1217_reference.fasta"
  E_coli:
    R1: "/home/user/GAnGA/tutorial/short_reads/E_coli/SRR1770413_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/E_coli/SRR1770413_2.fastq.gz"
    L1: "/home/user/GAnGA/tutorial/long_reads/E_coli/SRR33397843.fastq.gz"
    genus: "Escherichia"
    species: "coli"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/E_coli/E_coli_K12_ref.fasta"
  K_pneumoniae:
    R1: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/SRR4046827_1.fastq.gz"
    R2: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/SRR4046827_2.fastq.gz"
    L1: "/home/user/GAnGA/tutorial/long_reads/K_pneumoniae/SRR33323135.fastq.gz"
    genus: "Klebsiella"
    species: "pneumoniae"
    reference_fasta: "/home/user/GAnGA/tutorial/short_reads/K_pneumoniae/K_pneumoniae_ref.fasta"

```
#### 2. Run the pipeline
```
snakemake -s hybrid_snakefile --configfile hybrid_config.yaml --use-conda --cores 20
```
</details>



<details>
  <summary><b>📃 Report</b></summary>

The report for B_longum can be found in the following directories depending on the workflow used. Similarly, you can access reports for other genomes by navigating to their corresponding directories within each workflow output folder.

Short reads: ```/home/user/GAnGA/tutorial/output/short_reads/B_longum/20_report```

Long reads: ```/home/user/GAnGA/tutorial/output/long_reads/B_longum/18_report```

Hybrid reads: ```/home/user/GAnGA/tutorial/output/hybrid_reads/B_longum/19_report```

Open ```B_longum_report.html``` file in your web browser to see the consolidated report of the analysed genome. Links to the report files used to make the report are given below. You can hover over and click on the links to see the files in detail. 


</details>

