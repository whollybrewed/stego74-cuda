# stego74-cuda
We propose a GPU-based implementation of the (7,4) Hamming steganographic scheme. The scheme features in a high embedded payload with a trade-off of slightly lower visual quality. We further improve its throughput by applying parallel programming using CUDA. The loop-level and instruction-level parallelism are exploited in order to maximize the speedup. The result shows a considerable speedup compared to its original serial version. While increasing the input image size, the acceleration is still able to sustain.

image size|embed speedup|decode speedup
----------|-------------|--------------
256P      |64           |90
512P      |70           |95
1024P     |71           |104

A detailed full [report](https://github.com/whollybrewed/stego74-cuda/blob/master/report.pdf) is available.  