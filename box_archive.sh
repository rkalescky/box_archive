function tar_directory {
  target=${1}
  prefix=${2}
  temp_directory=${3}
  mkdir -p ${temp_directory}
  tar -h --ignore-failed-read -M -L 15G -F "./next_volume.sh ${prefix} ${temp_directory}" -cf "${prefix}.tar" ${target}
  ./next_volume.sh ${prefix} ${temp_directory}
}

function upload_archive {
  target=${1}
  prefix=${2}
  temp_directory=${3}
  index_current=${4}
  index_max=${5}
  
  index=$(printf %04d ${index_current})
  archive_file="${temp_directory}/${prefix}.tar.${index}"
  listings_directory="${temp_directory}/${prefix}_listings"
  hash_directory="${temp_directory}/${prefix}_sha512sums"
  sha512_file="${hash_directory}/${archive_file}.sha512sum"
  archive_contents_file="${listings_directory}/${archive_file}.txt"
  archive_compressed_file="${temp_directory}/${archive_file}.gz"
  mkdir -p ${listings_directory} ${hash_directory}
  
  tar -tf ${archive_file} > ${archive_contents_file}
  gzip ${archive_file}
  openssl dgst -sha512 ${archive_compressed_file} > ${sha512_file}
  curl -n --ftp-ssl "ftp://ftp.box.com/${target}" -T ${archive_compressed_file}
  local_size=$(ls -l ${archive_compressed_file} | cut -d' ' -f5)
  remote_size=$(curl -s -n --ftp-ssl --head "ftp://ftp.box.com/${target}${archive_compressed_file}" | awk '/Content-Length/{print $2}' | tr -d '[:space:]')
  if [ "$remote_size" -eq "$local_size" ]; then echo "Archive upload complete."; fi
  
  if [ "${index_current}" -eq "${index_max}" ]
  then
    tar -czf "${temp_directory}/${listings_directory}.tgz" ${listings_directory}
    tar -czf "${temp_directory}/${hash_directory}.tgz" ${hash_directory}
    curl -n --ftp-ssl "ftp://ftp.box.com/${target}" -T "${temp_directory}/${listings_directory}.tgz"
    curl -n --ftp-ssl "ftp://ftp.box.com/${target}" -T "${temp_directory}/${hash_directory}.tgz"
  fi
}

function slurm_upload_archive {
  target=${1}
  prefix=${2}
  temp_directory=${3}
  index_current=${SLURM_ARRAY_TASK_ID}
  index_max=${SLURM_ARRAY_TASK_MAX}

  upload_archive ${target} ${prefix} ${temp_directory} ${index_current} ${index_max}
}

