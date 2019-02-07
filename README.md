# box_archive
Scripts to tar, compress, and upload large datasets to Box. The scripts use GNU Tar's multivolume feature to keep each file's size less than 15 GB and Slurm to parallelize uploading the archives.
