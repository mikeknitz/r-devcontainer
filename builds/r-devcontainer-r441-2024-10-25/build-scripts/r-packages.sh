#!/bin/bash

set -e

R -q -e 'install.packages("tidyverse")'
R -q -e 'install.packages("devtools")'
R -q -e 'install.packages("languageserver")'
R -q -e 'devtools::install_github("nx10/httpgd@b0a5ec38638ca69e3adbc7b24d815757e5f74817")' # 2024-09-18
R -q -e 'install.packages("extrafont")'
R -q -e 'install.packages("Cairo")'
R -q -e 'install.packages("BiocManager")'
R -q -e 'install.packages("hexbin")' # Recommended for vsn or impute I think

R -q -e 'BiocManager::install(version = "3.20",       update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("SummarizedExperiment", update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("AnnotationDbi",        update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("org.Hs.eg.db",         update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("org.Mm.eg.db",         update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("DESeq2",               update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("clusterProfiler",      update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("ComplexHeatmap",       update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("limma",                update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("PhosR",                update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("vsn",                  update = TRUE, ask = FALSE, checkBuilt = TRUE)'
R -q -e 'BiocManager::install("impute",               update = TRUE, ask = FALSE, checkBuilt = TRUE)'

R -q -e 'extrafont::font_import(prompt = FALSE); extrafont::loadfonts()'

R -q -e 'install.packages("imputeLCMD")' # Relies on impute I think
R -q -e 'install.packages("Hmisc")'
R -q -e 'install.packages("magick", repos = "https://packagemanager.posit.co/cran/2024-09-23", type = "source")'
R -q -e 'BiocManager::install("ggkegg", update = TRUE, ask = FALSE, checkBuilt = TRUE)'

R -q -e 'install.packages("Seurat")'
R -q -e 'devtools::install_github("immunogenomics/presto@7636b3d0465c468c35853f82f1717d3a64b3c8f6")' # 2024-03-18
R -q -e 'install.packages("clustree")'
R -q -e 'install.packages("DT")'
R -q -e 'install.packages("ggh4x")'
R -q -e 'install.packages("ggsci")'
R -q -e 'install.packages("ggpubr")'
R -q -e 'install.packages("ggplotify")'
R -q -e 'install.packages("HGNChelper")'
R -q -e 'install.packages("openxlsx")'
R -q -e 'install.packages("ggnewscale")'
R -q -e 'install.packages("ggbeeswarm")'
R -q -e 'install.packages("dendsort")'
R -q -e 'install.packages("msigdbr")'
R -q -e 'install.packages("hdf5r")'
R -q -e 'devtools::install_github("10XGenomics/loupeR@a169417e7a0d59ae7ebba042a4f100de8efb8101")' # 2024-10-29

# Compile Seurat and SeuratObject from source to avoid
  # "built under a different version" warning when loading
# Currently no binaries for arm builds from Posit so this part
  # doesn't matter for arm architecture
R -q -e 'remove.packages("Seurat")'
R -q -e 'install.packages("Seurat", repos = "https://packagemanager.posit.co/cran/2024-09-23", type = "source")'
R -q -e 'remove.packages("SeuratObject")'
R -q -e 'install.packages("SeuratObject", repos = "https://packagemanager.posit.co/cran/2024-09-23", type = "source")'

R -q -e 'install.packages("officer")'
R -q -e 'install.packages("rsvg")'
