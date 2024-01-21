# Helpers
import numpy as np
import pandas as pd
import scanpy as sc
import scvelo as scv

random_seed = 12345

def run_scvelo(adata):
    """Run basic workflow for computing velocities."""
    scv.pp.filter_and_normalize(adata, min_shared_counts=20, n_top_genes=2000)
    sc.tl.pca(adata, random_state=random_seed)
    sc.pp.neighbors(adata, n_pcs=30, n_neighbors=30, random_state=random_seed)
    scv.pp.moments(adata, n_pcs=30, n_neighbors=30)

    scv.tl.recover_dynamics(adata, n_jobs=8)
    scv.tl.velocity(adata, mode='dynamical')
    scv.tl.velocity_graph(adata)

    return adata