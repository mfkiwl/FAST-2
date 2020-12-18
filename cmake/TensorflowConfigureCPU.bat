rem Setup environment variables so that configure command will not ask user for input by keyboard
set CC_OPT_FLAGS "/arch:AVX2"
set TF_NEED_GCP 0
set TF_NEED_HDFS 0
set TF_NEED_OPENCL 0
set TF_NEED_OPENCL_SYCL 0
set TF_NEED_COMPUTECPP 0
set TF_NEED_TENSORRT 0
set TF_NEED_KAFKA 0
set TF_NEED_JEMALLOC 1
set TF_NEED_VERBS 0
set TF_NEED_MKL 0
set TF_NEED_ROCM 0
set TF_SET_ANDROID_WORKSPACE 0
set TF_DOWNLOAD_MKL 0
set TF_DOWNLOAD_CLANG 0
set TF_NEED_MPI 0
set TF_NEED_S3 0
set TF_NEED_GDR 0
set TF_ENABLE_XLA 0
set TF_CUDA_CLANG 0
set TF_NEED_CUDA 0
set TF_NCCL_VERSION " "
set TF_OVERRIDE_EIGEN_STRONG_INLINE 1

python configure.py
