#!/usr/bin/env bash

declare -a gather_vars=( "proj_dir" "fasta_read_1" "fasta_read_2" "bam_read_1" "bam_read_2")
declare -a defaults=( $( dirname $PWD ) "subreads1.fasta" "subreads2.fasta" "subreads1.bam" "subreads2.bam" )

for (( i=0; i < ${#gather_vars[@]}; i++ )); do
    read -p "Please enter value for ${gather_vars[$i]} (default value is ${defaults[$i]}): " line
    if [[ "${line}" ]]; then
        eval export ${gather_vars[$i]}="${line}"
    else
        eval export ${gather_vars[$i]}="${defaults[$i]}"
    fi
done

echo "Setting up Falcon"

### Leave only preparation of the falcon repo, container, conda env and nextflow input in ansible
### as this only needs to be run once
ansible-playbook ansible.yaml -i vars_list --extra-vars "dir=${proj_dir} home=${HOME}"

status=$?
if [[ $status != 0 ]]; then
    echo "Falcon deployment failed"
    exit 1
fi

### Move input creation to bash script - these files will need to be recreated for each run of the workflow
echo "${proj_dir}/ansible-falcon/falcon/${fasta_read_1}" > ${proj_dir}/ansible-falcon/falcon/subreads.fasta.fofn
echo "${proj_dir}/ansible-falcon/falcon/${fasta_read_2}" >> ${proj_dir}/ansible-falcon/falcon/subreads.fasta.fofn
echo "${proj_dir}/ansible-falcon/falcon/${bam_read_1}" > ${proj_dir}/ansible-falcon/falcon/subreads.bam.fofn
echo "${proj_dir}/ansible-falcon/falcon/${bam_read_2}" >> ${proj_dir}/ansible-falcon/falcon/subreads.bam.fofn

### Move conda activation to inside sbatch_nextflow.sh - Necessary for support at NCI, by default PBS
### does not import the user environment (and we do not recommend enabling it)
cd ${proj_dir}/ansible-falcon
### nextflow.config will read $dir from the environment
export dir=${proj_dir}/ansible-falcon/falcon
${proj_dir}/ansible-falcon/falcon/sbatch_nextflow.sh