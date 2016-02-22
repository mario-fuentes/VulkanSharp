GENDARME_URL = https://cloud.github.com/downloads/spouliot/gendarme/gendarme-2.10-bin.zip
VK_XML_URL = https://raw.githubusercontent.com/KhronosGroup/Vulkan-Docs/1.0/src/spec/vk.xml

CONFIGURATION = Debug
BIN_PATH = bin/$(CONFIGURATION)
BIN_PATH_RELEASE = bin/Release

all: $(BIN_PATH)/vk.xml $(BIN_PATH)/Vulkan.dll

$(BIN_PATH)/vk.xml:
	mkdir -p $(BIN_PATH)
	curl -o "$@" $(VK_XML_URL)
	cp "$@" $(BIN_PATH_RELEASE)

$(BIN_PATH)/Vulkan.dll: $(wildcard src/Vulkan/*.cs src/Vulkan/*/*.cs tools/Generator/*cs)
	xbuild /p:Configuration=$(CONFIGURATION)

clean:
	rm -Rf $(BIN_PATH)

fxcop: lib/gendarme-2.10/gendarme.exe
	mono --debug $< --html $(BIN_PATH)/gendarme.html \
		$(if @(GENDARME_XML),--xml $(BIN_PATH)/gendarme.xml) \
		--ignore gendarme-ignore.txt \
		$(BIN_PATH)/Vulkan.dll

lib/gendarme-2.10/gendarme.exe:
	-mkdir -p `dirname "$@"`
	curl -o lib/gendarme-2.10/gendarme-2.10-bin.zip $(GENDARME_URL)
	(cd lib/gendarme-2.10 ; unzip gendarme-2.10-bin.zip)
