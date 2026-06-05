# Bacterial Genome Assembly & AMR Analysis using Oxford Nanopore Sequencing

## Project Overview
Complete bioinformatics pipeline for bacterial genome assembly, annotation, and antimicrobial resistance (AMR) detection using Oxford Nanopore Technology (ONT) sequencing data.

## Samples Analyzed
| Sample | Species | Sequence Type |
|--------|---------|--------------|
| test1 | Mycobacterium tuberculosis H37Rv | ST-215 |
| test2 | Salmonella enterica Typhimurium | Havana serotype |

## Pipeline Tools
- Flye — De novo genome assembly
- Medaka — Assembly polishing
- Bakta — Genome annotation
- ResFinder — AMR gene detection
- MLST — Sequence typing
- Sourmash — Species identification
- MobSuite — Plasmid detection
- SeqSero2 — Salmonella serotyping

## Key Results
| Sample | AMR Gene | Resistance |
|--------|----------|-----------|
| M. tuberculosis | aac(2')-Ic | Gentamicin, Tobramycin |
| M. tuberculosis | erm(37) | Erythromycin, Clindamycin |
| Salmonella | aac(6')-Iaa | Amikacin, Tobramycin |

## Tools & Languages
- Nextflow | Linux/Bash | R + ggplot2 | Docker

## Author
Dheeraj Kumar — Bioinformatics Analyst
