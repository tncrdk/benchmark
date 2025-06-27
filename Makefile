.PHONY: clean_rebuild
clean_rebuild:
	rm -rf build/*
	cmake -B build \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH="/home/thorb/Code/Sandkasse/Benchmarking/parallel/install;/home/thorb/Code/Sandkasse/Benchmarking/arithmetic/install;/home/thorb/Code/Sandkasse/Benchmarking/disk/install;/home/thorb/Code/Sandkasse/Benchmarking/memory/install"
	cmake --build build
