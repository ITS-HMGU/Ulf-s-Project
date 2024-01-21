# ulf-citeseq

10X + CITE-seq

* CITE-seq experiment
* project directory: `cortex:/home/fdb589/ulf-citeseq`

## Preprocessing

```bash
bash scripts/preprocessing.sh
```

## Velocyto

```bash
bash scripts/velocyto.sh
```

## Jupyter

```bash
# cortex
jupyter lab --no-browser --port=9999
# local computer
ssh -fNL localhost:9999:localhost:9999 cortex
kill <PID>
```

## Environments

```bash
conda env create -f citeseq-count-1.4.3
```

## References

* https://satijalab.org/seurat/v3.0/hashing_vignette.html
* https://satijalab.org/seurat/v3.1/multimodal_vignette.html
* https://satijalab.org/seurat/v3.1/hashing_vignette.html
