OPENSCAD ?= openscad
BLENDER ?= blender
ESPHOME ?= esphome
CXX ?= c++
PARTS = base deck esp32_cap hx711_cap
MESHES = $(addprefix printable/,$(addsuffix .stl,$(PARTS)))

.PHONY: meshes images check firmware
meshes: $(MESHES)

$(MESHES): printable/%.stl: cad/scale.scad
	$(OPENSCAD) --export-format asciistl -o $@ -D 'part="$*"' $<

images: $(MESHES)
	$(OPENSCAD) -o docs/exploded.png --imgsize=1200,800 --camera=0,-80,20,58,0,25,900 --colorscheme=Tomorrow -D explode=22 cad/scale.scad
	$(BLENDER) --background --factory-startup --python cad/render.py
	jpegtran -copy none -outfile docs/assembled.jpg docs/assembled.jpg

check:
	$(CXX) -std=c++17 -Wall -Wextra -Werror tests/readings_test.cpp -o tests/readings_test
	tests/readings_test
	python3 tests/check_meshes.py
	$(ESPHOME) config firmware/scale.yaml

firmware:
	$(ESPHOME) compile firmware/scale.yaml
