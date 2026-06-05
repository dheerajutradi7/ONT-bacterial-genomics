# Walkthrough - ONT Bacterial Genome Assembly & AMR Analysis

This guide walks you through setting up and running the complete pipeline on your own bacterial ONT sequencing data.

## Prerequisites
- Ubuntu 20.04+ Linux
- 32GB RAM minimum (64GB recommended)  
- 50GB free disk space

## 1. Install Dependencies

### Java
    sudo apt-get update && sudo apt-get install -y default-jdk

### Nextflow
    curl -s https://get.nextflow.io | bash
    sudo mv nextflow /usr/local/bin/

### Docker
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo usermod -aG docker $USER

### R packages
    R -e "install.packages(c('ggplot2','dplyr','tidyr','RColorBrewer','pheatmap'), repos='https://cran.r-project.org')"

## 2. Download Demo Dataset

Download link:
https://ont-exd-int-s3-euwst1-epi2me-labs.s3.amazonaws.com/wf-bacterial-genomes/wf-bacterial-genomes-demo.tar.gz

    mkdir -p ~/ont_project && cd ~/ont_project
    wget https://ont-exd-int-s3-euwst1-epi2me-labs.s3.amazonaws.com/wf-bacterial-genomes/wf-bacterial-genomes-demo.tar.gz
    tar -xzvf wf-bacterial-genomes-demo.tar.gz

Dataset contains:
- barcode01/myco.fastq.gz - Mycobacterium tuberculosis ONT reads
- barcode02/salmonella.fastq.gz - Salmonella enterica ONT reads

## 3. Run the Pipeline

### Demo dataset:
    NXF_VER=23.10.0 nextflow run epi2me-labs/wf-bacterial-genomes \
        --fastq wf-bacterial-genomes-demo/isolates_fastq \
        --isolates \
        --sample_sheet wf-bacterial-genomes-demo/isolates_sample_sheet.csv \
        --out_dir ./results \
        -work-dir ./work \
        --flye_genome_size 5000000 \
        --flye_asm_coverage 50 \
        -profile standard

### Your own sample:
    NXF_VER=23.10.0 nextflow run epi2me-labs/wf-bacterial-genomes \
        --fastq /path/to/your/fastq_folder \
        --isolates \
        --sample YOUR_SAMPLE_NAME \
        --out_dir ./results \
        -work-dir ./work \
        -profile standard

| Parameter | Description |
|-----------|-------------|
| --fastq | Path to FASTQ files |
| --isolates | Enable AMR + MLST + serotyping |
| --flye_genome_size | Estimated genome size (reduces RAM) |
| --flye_asm_coverage | Target coverage for subsampling |
| -profile standard | Use Docker for all tools |

Expected runtime: 10-40 minutes

## 4. View Results

    xdg-open results/wf-bacterial-genomes-report.html
    cat results/SAMPLE_resfinder_results/ResFinder_results_tab.txt
    cat results/SAMPLE_sourmash_taxonomy.csv
    cat results/SAMPLE.mlst.json

## 5. Visualize in R

    git clone https://github.com/dheerajutradi7/ONT-bacterial-genomics.git
    cd ONT-bacterial-genomics
    Rscript visualize.R
    Rscript visualize2.R

## 6. Interpreting Results

### Species Identification (Sourmash)
- Match above 90% = high confidence identification
- Match 50-90% = moderate confidence, check manually
- Match below 50% = novel or mixed sample

### AMR Results (ResFinder)
- Identity 100% = exact resistance gene match
- Identity 90-99% = likely resistance gene variant
- Check pheno_table.txt for clinical antibiotic interpretation

### Assembly Quality
- M. tuberculosis expected genome: ~4.4 Mb
- Salmonella expected genome: ~4.8 Mb
- Coverage above 30x = reliable assembly

## 7. Troubleshooting

### Out of memory error:
    --flye_genome_size 5000000 --flye_asm_coverage 50

### Docker disk space error:
    sudo systemctl stop docker
    sudo mv /var/lib/docker /large/partition/docker
    sudo systemctl start docker

### Resume failed run:
    nextflow run epi2me-labs/wf-bacterial-genomes ... -resume
