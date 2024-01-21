# Helper scripts

random_seed <- 42

#' Add gene_id with description to the Seurat object
#' @param seu: Seurat object
#' @return Annotation as DataFrame 
#' @importFrom dplyr "%>%"
get_annotation <- function(seu) {
  
  features <- data.table::fread(
      "~/ulf-citeseq/data/processed/200910_A00642_0101_AHTJW3DRXX-5000_cells/outs/filtered_feature_bc_matrix/features.tsv.gz", 
      header = F, 
      col.names = c("ensembl_id", "gene_symbol", "other"),
    ) %>% as.data.frame
  features$gene_symbol <- make.unique(features$gene_symbol)
  rownames(features) <- features$gene_symbol
  features <- features[intersect(rownames(seu), features$gene_symbol), ]
  
  annot_file <- "~/ulf-citeseq/data/raw/annotation.tsv"
  if (file.exists(annot_file)) {
    annot <- read.table(annot_file)
  } else {
    mart <- biomaRt::useDataset(
      dataset = "hsapiens_gene_ensembl",
      mart    = biomaRt::useMart("ENSEMBL_MART_ENSEMBL",
                                 host    = "www.ensembl.org")
    )

    annot <- biomaRt::getBM(
      attributes = c("ensembl_gene_id", "description"),
      mart       = mart)

    rownames(annot) <- annot$ensembl_gene_id
    write.table(annot, file = annot_file)
  }
  features$description <- annot[features$ensembl_id, "description"]
  features[is.na(features$description), "description"] <- ""

  return (features)
}