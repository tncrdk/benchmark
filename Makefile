parallel = /home/thorb/Code/Sandkasse/Benchmarking/parallel
arithmetic = /home/thorb/Code/Sandkasse/Benchmarking/arithmetic
disk = /home/thorb/Code/Sandkasse/Benchmarking/disk
memory = /home/thorb/Code/Sandkasse/Benchmarking/memory

docker_parallel = /home/ubuntu/Code/parallel/
docker_arithmetic = /home/ubuntu/Code/arithmetic/
docker_disk = /home/ubuntu/Code/disk/
docker_memory = /home/ubuntu/Code/memory/

.PHONY: build_test
define build_test
	rm -rf $1/build/*
	cmake -S $1 -B $1/build -DCMAKE_BUILD_TYPE=Release
	cmake --build $1/build
	cmake --install $1/build --prefix=$1/install
endef

.PHONY: rebuild
rebuild:
	rm -rf build/*
	cmake -B build \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="$(parallel)/install;$(arithmetic)/install;$(disk)/install;$(memory)/install"
	cmake --build build

.PHONY: rebuild_all
rebuild_all:
	$(call build_test,$(parallel))
	$(call build_test,$(arithmetic))
	$(call build_test,$(disk))
	$(call build_test,$(memory))
	rm -rf build/*
	cmake -B build \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="$(parallel)/install;$(arithmetic)/install;$(disk)/install;$(memory)/install"
	cmake --build build

# ======================================================

.PHONY: docker_rebuild
docker_rebuild:
	rm -rf build/*
	cmake -B build \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="$(docker_parallel);$(docker_arithmetic);$(docker_disk);$(docker_memory)"
	cmake --build build

.PHONY: docker_rebuild_all
docker_rebuild_all:
	$(call build_test,$(docker_parallel))
	$(call build_test,$(docker_arithmetic))
	$(call build_test,$(docker_disk))
	$(call build_test,$(docker_memory))
	rm -rf build/*
	cmake -B build \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="$(docker_parallel)/install;$(docker_arithmetic)/install;$(docker_disk)/install;$(docker_memory)/install"
	cmake --build build
