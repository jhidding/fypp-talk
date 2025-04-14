.RECIPEPREFIX = >
.PHONY: all update-symlink clean clean-all

target ?= GNU
sort_enable := $(sort $(enable))

hash := $(shell printf '%s' "$(sort_enable)" | md5sum | cut -c1-8)
build_dir = build/$(target)-$(hash)

ifeq ($(target), GNU)
compile := gfortran

ifeq ($(findstring OPENMP,$(enable)), OPENMP)
$(info Enabling OpenMP)
f90_flags += -fopenmp
endif

else ifeq ($(target), NVIDIA)
compile := nvfortran
fypp_flags += -DOPENACC
f90_flags += -fast -Minfo=all -Mvect=levels:5 -Minline

ifeq ($(findstring OPENMP,$(enable)), OPENMP)
f90_flags += -mp=gpu
endif

else
$(error Unknown target: $(target))
endif

$(info Build target: $(target))
$(info Selected modules: [$(sort_enable)])
$(info Config hash: $(hash))
$(info Build directory: $(build_dir))

sources := $(wildcard src/*.fpp)
$(info Source files: $(sources))

obj_files := $(sources:src/%.fpp=$(build_dir)/obj/%.o)
$(info Object files: $(obj_files))

# enable line numbering markers
fypp_flags += -n
# forward `enable` parameter
fypp_flags += $(foreach flag,$(sort_enable),-D$(flag))

f90_flags += -ffree-form -fimplicit-none -O3 -Wall -nocpp

$(info Fypp flags: $(fypp_flags))
$(info Compiler: $(compile))
$(info Flags: $(f90_flags))
$(info =======================)

link := $(compile)
link_flags = $(f90_flags)
compile_flags = -c $(f90_flags)

all: update-symlink $(build_dir)/compute_pi

clean:
> @echo -e "Removing latest build"
> @rm -rf $$(readlink -f build/latest)
> @rm -f build/latest

clean-all:
> @echo -e "Removing build dir"
> @rm -rf build

update-symlink:
> @echo -e "Symlink \\e[1;34mbuild/latest\\e[m -> \\e[1;34m$(build_dir)\\e[m"
> @mkdir -p $(build_dir)
> @rm -f build/latest
> @ln -s $(target)-$(hash) build/latest

$(build_dir)/compute_pi: $(obj_files)
> @mkdir -p $(@D)
> @echo -e "Linking \\e[1;35m$@\\e[m"
> @$(link) $(link_flags) $^ -o $@

.PRECIOUS: $(build_dir)/f90/%.f90

$(build_dir)/f90/%.f90: src/%.fpp
> @mkdir -p $(@D)
> @echo -e "Preprocessing \\e[1;32m$<\\e[m"
> @fypp $(fypp_flags) $< $@

$(build_dir)/obj/%.o: $(build_dir)/f90/%.f90
> @mkdir -p $(@D)
> @echo -e "Compiling \\e[1;32m$<\\e[m"
> @$(compile) $(compile_flags) $< -o $@

