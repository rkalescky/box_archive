# box_archive
Scripts to tar, compress, and upload large datasets to Box. The scripts use GNU Tar's multivolume feature to keep each file's size less than 15 GB and Slurm to parallelize uploading the archives.

# Use
1. Setup Box for use with curl if you have not done so already
   1. [In Box, create unique password for use with external applications](https://community.box.com/t5/How-to-Guides-for-Account/Box-SSO-Working-with-External-Passwords/ta-p/52034)
   2. `touch ~/.netrc && chmod 600 ~/.netrc`
   3. Edit `~/.netrc` such that first first line is `machine ftp.box.com`, the second line is `login <your_smu_email_address`, and the third line is `password <your_unique_box_password>`
2. Edit `tar_data.sbatch` such that `<directory_to_tar>` is directory to be archived, `<archive_prefix>` the prefix of the archive files, and `<temp_directory>` is directory for archive files before upload.
3. Submit `tar_data.sbatch` and wait for archives to be created
4. Edit `upload_data.sbatch` such that `<box_directory>` is Box directory for archive files, `<archive_prefix>` the prefix of the archive files, and `<temp_directory>` is directory for archive files before upload
5. Submit `upload_data.sbatch` and wait for archives to be uploaded

