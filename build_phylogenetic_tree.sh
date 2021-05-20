# compbio-trial - Build phylogenetic trees
##########################################

# installing augur via conda
############################

conda update conda

conda create -n nextstrain
conda activate nextstrain

conda install -c conda-forge -c bioconda augur

conda install -c conda-forge -c bioconda auspice

# test (works)
augur --version
# augur 12.0.0

auspice --version
# 2.23.0


# begining of the pipeline

# USER DEFINED VARIABLES #
##########################

export WORKING_DIR=<path to working dir>
export ALIGNMENT_ID="north-america-small"

#########################

conda activate nextstrain

# extract_id from 
REGION_ID=ALIGNMENT_ID%'-small'

mkdir $WORKING_DIR/results

# using augur to build a tree with default parameters (method : iqtree, substitution model : GRT)

augur tree \
  --alignment $WORKING_DIR/$ALIGNMENT_ID'_alignment.fasta' \
  --output $WORKING_DIR/results/tree_raw.nwk

# Refine the tree using sequence metadata.

augur refine \
  --tree $WORKING_DIR/results/tree_raw.nwk \
  --alignment $WORKING_DIR/$ALIGNMENT_ID'_alignment.fasta' \
  --metadata $WORKING_DIR/$ALIGNMENT_ID'_metadata.tsv' \
  --output-tree $WORKING_DIR/results/tree_refined.nwk \
  --output-node-data $WORKING_DIR/results/branch_lengths.json \
  --timetree \
  --coalescent opt \
  --date-confidence \
  --date-inference marginal


# augur refine is using TreeTime version 0.8.1


# Export the tree in JSON files suitable for visualization with auspice

mkdir $WORKING_DIR/auspice

augur export v2 \
  --tree $WORKING_DIR/results/tree_refined.nwk \
  --metadata $WORKING_DIR/$ALIGNMENT_ID'_metadata.tsv' \
  --title 'Sars cov2 from $REGION_ID' \
  --node-data $WORKING_DIR/results/branch_lengths.json \
  --output $WORKING_DIR/auspice/$ALIGNMENT_ID.json \
  --colors $WORKING_DIR/config/country_colors.tsv \
  --auspice-config $WORKING_DIR/config/auspice_config.json



# visualize the results with auspice :

auspice view --datasetDir $WORKING_DIR/auspice
