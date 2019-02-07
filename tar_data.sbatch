#!/bin/bash
#SBATCH -J tar
#SBATCH -o tar.out
#SBATCH -p archive
#SBATCH --mem=6G

source ./box_archive.sh

# <directory_to_tar> is directory to be archived
# <archive_prefix> the prefix of the archive files
# <temp_directory> is directory for archive files before upload
tar_directory <directory_to_tar> <archive_prefix> <temp_directory>

