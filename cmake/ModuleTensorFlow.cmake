## TensorFlow module

if(FAST_MODULE_TensorFlow)
    message("-- Tensorflow module enabled.")
    option(FAST_BUILD_TensorFlow_CUDA "Build TensorFlow CUDA/cuDNN version" OFF)
    option(FAST_BUILD_TensorFlow_ROCm "Build TensorFlow ROCm version" OFF)
    option(FAST_BUILD_TensorFlow_CPU "Build TensorFlow CPU version" ON)
    include(${PROJECT_SOURCE_DIR}/cmake/ExternalTensorflow.cmake)

    ## Tensorflow
    #list(APPEND FAST_INCLUDE_DIRS ${Tensorflow_INCLUDE_DIRS})
    set(CMAKE_POSITION_INDEPENDENT_CODE ON)
    add_definitions(-DEIGEN_AVOID_STL_ARRAY)
    if(WIN32)
        # Some definitions needed to compile with tensorflow on windows
        # These are taken from tensorflow/contrib/cmake/CMakeLists.txt
        add_definitions(-DNOMINMAX -D_WIN32_WINNT=0x0A00 -DLANG_CXX11 -DCOMPILER_MSVC -D__VERSION__=\"MSVC\")
        add_definitions(-DWIN32 -DOS_WIN -D_MBCS -DWIN64 -DPLATFORM_WINDOWS)
        add_definitions(-DTENSORFLOW_USE_EIGEN_THREADPOOL -DEIGEN_HAS_C99_MATH -D_ITERATOR_DEBUG_LEVEL=0)
        # Suppress warnings to reduce build log size.
        add_definitions(/wd4267 /wd4244 /wd4800 /wd4503 /wd4554 /wd4996 /wd4348 /wd4018)
        add_definitions(/wd4099 /wd4146 /wd4267 /wd4305 /wd4307)
        add_definitions(/wd4715 /wd4722 /wd4723 /wd4838 /wd4309 /wd4334)
        # To get rid of this error: Not found: No session factory registered for the given session options: {target: "" config: } Registered factories are {}.
        #set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /WHOLEARCHIVE:\"${Tensorflow_LIBRARY}\"")

        set(TensorFlow_LIBRARIES
            tensorflow.lib
            #libprotobuf.lib # For windows we need this protobuf static lib for some reason..
        )
    else()
        set(TensorFlow_CUDA_LIBRARIES
            ${FAST_EXTERNAL_INSTALL_DIR}/lib/libtensorflow_cc_CUDA.so
        )
        set(TensorFlow_CPU_LIBRARIES
            ${FAST_EXTERNAL_INSTALL_DIR}/lib/libtensorflow_cc_CPU.so
        )
    endif()
endif()
