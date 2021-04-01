#!/usr/bin/env nextflow
fasta_ch1 = Channel.fromPath('falcon/subreads.fasta.fofn')
fasta_ch2 = Channel.fromPath('falcon/subreads.fasta.fofn')
fasta_ch3 = Channel.fromPath('falcon/subreads.fasta.fofn')
bam_ch = Channel.fromPath('falcon/subreads.bam.fofn')
hic_ch = Channel.fromPath('hic_reads')
dir = "project_dir"

process fc_run {
    publishDir "${dir}"

    input:
        file x from fasta_ch1

    output:
        file("0-rawreads/") into (rawreads1, rawreads2)
        file("1-preads_ovl/") into (preads1, preads2)
        file("2-asm-falcon/") into (asm1, asm2)

    script:
        """
        sed -i "s/outs.write('/#outs.write('/" ${dir}/nf-work/conda/*/lib/python3.7/site-packages/falcon_kit/mains/ovlp_filter.py
        fc_run ${dir}/fc_run.cfg
        """
}

process fc_unzip {
    publishDir "${dir}"

    input:
        file x from rawreads1
        file x from preads1
        file x from asm1
        file x from bam_ch
        file x from fasta_ch2

    output:
        file("3-unzip/*") into unzip
        file("4-polish/*") into polish

    script:
        """
        fc_unzip.py ${dir}/fc_unzip.cfg &> run1.std
        """
}
