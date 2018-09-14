set -e
#export CC=/usr/bin/clang
#export CXX=/usr/bin/clang
rm -rf cmake-gcc
mkdir -p cmake-gcc
pushd cmake-gcc
#cmake .. -DCMAKE_BUILD_TYPE=Release
cmake .. -DCMAKE_BUILD_TYPE=Debug
make -j4

#export ASAN_OPTIONS=verbosity=1:print_stats=1:symbolize=1:fast_unwind_on_malloc=0
#export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer
#export LSAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer
#export MSAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer

#	print_stats
#	fast_unwind_on_check - If available, use the fast frame-pointer-based unwinder on internal CHECK failures.
#	fast_unwind_on_fatal - If available, use the fast frame-pointer-based unwinder on fatal errors.
#	fast_unwind_on_malloc - If available, use the fast frame-pointer-based unwinder on malloc/free.
#	verbosity - Verbosity level (0 - silent, 1 - a bit of output, 2+ - more output).
#	detect_leaks - Enable memory leak detection.

./janus
