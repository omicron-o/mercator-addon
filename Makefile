.PHONY: all build clean release release-zip release-tar

BUILD_DIR := ./build
RELEASE_DIR := ./release
SRC_DIR := ./src
TEXTURE_DIR := ./textures

all: release-zip release-tar
	

release: build
	mkdir -p $(RELEASE_DIR)

build: clean
	mkdir -p $(BUILD_DIR)
	cp -r $(SRC_DIR) $(BUILD_DIR)/Mercator
	mkdir -p $(BUILD_DIR)/Mercator/textures
	cp -r $(TEXTURE_DIR)/*.tga $(BUILD_DIR)/Mercator/textures
	cp LICENSE.md $(BUILD_DIR)/Mercator/

release-zip: release
	7z a -tzip $(RELEASE_DIR)/mercator.zip -w $(BUILD_DIR)/.

release-tar: release
	tar -cJf $(RELEASE_DIR)/mercator.tar.xz -C $(BUILD_DIR) Mercator
	tar -czf $(RELEASE_DIR)/mercator.tar.gz -C $(BUILD_DIR) Mercator

clean:
	rm -rf $(BUILD_DIR) $(RELEASE_DIR)
