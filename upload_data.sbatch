#!/bin/bash
#SBATCH -J upload
#SBATCH -o upload_%a.out
#SBATCH -p dtn
#SBATCH --mem=6G
#SBATCH -n 1
#SBATCH --array=0-n # Range of 0 to n-number of archive files

source ./box_archive.sh

# <box_directory> is Box directory for archive files
# <archive_prefix> the prefix of the archive files
# <temp_directory> is directory for archive files before upload
slurm_upload_archive <box_directory> <archive_prefix> <temp_directory>

