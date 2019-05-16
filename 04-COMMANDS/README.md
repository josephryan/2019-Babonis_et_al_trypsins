# Commands

### Protein domain analysis

    hmmsearch --tblout NVJ_Trypsin_2.tab -A NVJ_Trypsin_2.aln Trypsin_2.hmm /NVJ.fa

    hmmscan --domtblout Ccrux_scan_domtab.tab Pfam-A.hmm Ccrux_aa.fa 

### Phylogenetics

    hmm2aln.pl --hmm=Trypsin.hmm --name=trypsin --fasta_dir=01-FASTA_DIR --threads=1 > MCB_tryp.aln.fa

    Gblockswrapper MCB_tryp.aln.fa

    perl -pi -e 's/ //g' MCB_tryp.aln.fa-gb

    perl -pi -e 's/\|/_/g' MCB_tryp.aln.fa-gb

    iqtree-omp -nt AUTO -s MCB_tryp.aln.fa-gb -m MF

    raxmlHPC-PTHREADS-SSE3 -T 12 -p 12345 -# 25 -m PROTGAMMAVT -s MCB_tryp.aln.fa-gb -n tryp_mp &

    raxmlHPC-PTHREADS-SSE3 -d -T 12 -p 12345 -# 25 -m PROTGAMMAVT -s MCB_tryp.aln.fa-gb  -n tryp_rt &

    iqtree-omp -nt AUTO -s MCB_tryp.aln.fa-gb -m VT -pre tryp_iqVT &

    raxmlHPC -f e -m PROTGAMMAVT -t tryp_iqVT.treefile -s MCB_tryp.aln.fa-gb -n iq.compare

    raxmlHPC-PTHREADS-SSE3 -d -T 44 -p 12345 -m PROTGAMMAVT -s MCB_tryp.aln.fa-gb -n tryp_boots -# 1000 -x 54321

    raxmlHPC -m PROTGAMMAVT -p 12345 -f b -t RAxML_bestTree.MCB_tryp_mp -z RAxML_bootstrap.mlei_cnid_bilat_tryp_boots -n bestTree_MCB_tryp_boots

### prune trees with phyutility

### make tree of Nvec seqs only by pruning other cnidarians (only the first three pruned sequences are listed)

    java -jar phyutility.jar -pr -in cnid_tryp_cp_boots.tre -out Nvec_only_tryp.tre -names Adig_a00087403.t1 Adig_a00161801.t1 Adig_a00151501.t1.1 ... 

### remove duplicate Nvec sequences from animal trypsin phylogeny

    java -jar phyutility.jar -pr -in RAxML_bipartitions.RAxML_bestTree.tryp_corr_mp_bootstraps_applied  -out MCB_tryp_boots_pruned.tre -names NVJ_144191 NVJ_149919.1 NVJ_149919.2 NVJ_124644.1 NVJ_124644.2 NVJ_97944 NVJ_95672 NVJ_127469.1 NVJ_127469.2 NVJ_127469.3 NVJ_127472.1 NVJ_127472.2 NVJ_127472.3 NVJ_14047

### remove partial/non-significant trypsin_2 domain from trypsin_2 tree

    java -jar phyutility.jar -pr -in RAxML_bipartitions.bestTree_MCB_tryp2_boots -out MCB_tryp2_boots_pruned.tre -names NVJ_23745.1




