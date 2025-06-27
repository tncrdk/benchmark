# main_project/CMakeLists.txt
cmake_minimum_required(VERSION 3.10)
project(benchmark_project VERSION 1.0.0 LANGUAGES CXX)

# Search for memory_benchmark
# find_package will look in CMAKE_PREFIX_PATH/lib/cmake/<PackageName>
# and CMAKE_PREFIX_PATH/<PackageName>/cmake/
find_package(memory_benchmark CONFIG REQUIRED)

# Search for disk_benchmark
find_package(disk_benchmark CONFIG REQUIRED)

# Search for arithmetic_benchmark
find_package(arithmetic_benchmark CONFIG REQUIRED)
#
# Search for parallel_benchmark
find_package(parallel_benchmark CONFIG REQUIRED)

add_executable(benchmarks main.cpp)

# Link the executable with the imported libraries
# The targets lib_a::lib_a and lib_b::lib_b are provided by the installed Config files
target_link_libraries(benchmarks PRIVATE
    memory_benchmark::memory_benchmark
    disk_benchmark::disk_benchmark
    arithmetic_benchmark::arithmetic_benchmark
    parallel_benchmark::parallel_benchmark
)

# Ensure include directories are added for the executable if not already handled by target_link_libraries
# For imported targets, their public include directories are usually propagated automatically,
# but it's good to explicitly add them if there's any doubt or if headers are used directly.
target_include_directories(benchmarks PRIVATE
    ${memory_benchmark_INCLUDE_DIRS}
    ${disk_benchmark_INCLUDE_DIRS}
    ${arithmetic_benchmark_INCLUDE_DIRS}
    ${parallel_benchmark_INCLUDE_DIRS}
)

# Optional: Add rpath for development, not usually needed for installed executables
# set_target_properties(benchmarks PROPERTIES
#     BUILD_RPATH "$ORIGIN/../lib" # Linux/macOS
# )
