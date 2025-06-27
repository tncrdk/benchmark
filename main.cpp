#include "disk_benchmark.h"
#include "memory_benchmark.h"
#include "arithmetic_benchmark.h"
#include "parallel_benchmark.h"

int main() {
    arithmetic_benchmark::run();
    memory_benchmark::run();
    disk_benchmark::run();
    parallel::run();

    return 0;
}
