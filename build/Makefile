BUILD_DIR = $(RPI_ENV_TOP_DIR)/build
KERN_DIR = $(RPI_ENV_TOP_DIR)/linux
BR_DIR = $(RPI_ENV_TOP_DIR)/buildroot
UBOOT_DIR = $(RPI_ENV_TOP_DIR)/u-boot-arm
UBOOT_TOOLS = $(UBOOT_DIR)/tools

OUTPUT_DIR = $(BUILD_DIR)/output

NFS_ROOTFS = /srv/nfs4/rpi
TFTP_SRV = /srv/tftpboot

KERN_OPTIONS := ARCH=$(BUILD_TARGET_ARCH) \
    CROSS_COMPILE=$(BUILD_TARGET_CC) \
    INSTALL_MOD_PATH=$(BUILD_DIR)/configs/buildroot/rootfs-overlay

BR_OPTIONS := HOSTCC=gcc
UBOOT_OPTIONS := CROSS_COMPILE=$(BUILD_TARGET_CC)

CONFIGS_DIR := $(BUILD_DIR)/configs
CONFIGS_UBOOT := $(CONFIGS_DIR)/u-boot


# KERNEL build
# ================================================================
kernel:
	make -C $(KERN_DIR) $(KERN_OPTIONS) all modules modules_install
	cp -rvf $(KERN_DIR)/arch/arm/boot/Image $(OUTPUT_DIR)/kernel-Image
	cp -rvf $(KERN_DIR)/arch/arm/boot/zImage $(OUTPUT_DIR)/kernel-zImage
	sudo cp -rvf $(OUTPUT_DIR)/kernel-Image $(TFTP_SRV)
	sudo cp -rvf $(OUTPUT_DIR)/kernel-zImage $(TFTP_SRV)

kernel-config:
	make -C $(KERN_DIR) $(KERN_OPTIONS) bcmrpi_defconfig

kernel-menuconfig:
	make -C $(KERN_DIR) $(KERN_OPTIONS) menuconfig

kernel-clean:
	make -C $(KERN_DIR) $(KERN_OPTIONS) clean
	sudo rm -rf $(BR_DIR)/output/target/lib/modules/*

# BUILDROOT build
# ================================================================
br:
	make -C $(BR_DIR) $(BR_OPTIONS)
	cp -rvf $(BR_DIR)/output/images/rootfs.tar $(OUTPUT_DIR)
	sudo rm -rf $(NFS_ROOTFS)/*
	sudo tar xf $(BR_DIR)/output/images/rootfs.tar -C $(NFS_ROOTFS)
	cp -rfv \
	    $(BR_DIR)/output/images/rpi-firmware/bcm2708-rpi-b-plus.dtb \
	    $(OUTPUT_DIR)
	sudo cp -rfv \
	    $(BR_DIR)/output/images/rpi-firmware/bcm2708-rpi-b-plus.dtb \
	    $(TFTP_SRV)

br-config:
	make -C $(BR_DIR) $(BR_OPTIONS) raspberrypi_defconfig

br-menuconfig:
	make -C $(BR_DIR) $(BR_OPTIONS) menuconfig

br-clean:
	make -C $(BR_DIR) $(BR_OPTIONS) clean

br-mmc:
	sudo umount /dev/mmcblk0p1 && umount /dev/mmcblk0p2
	sudo dd bs=4M \
	    if=$(BR_DIR)/output/images/rootfs.ext2 \
	    of=/dev/mmcblk0p2 \
	    && sync


# U-BOOT build
# ==================================================================
uboot:
	make -C $(UBOOT_DIR) $(UBOOT_OPTIONS)
	cp -rvf $(UBOOT_DIR)/u-boot.bin $(OUTPUT_DIR)

uboot-config:
	make -C $(UBOOT_DIR) $(UBOOT_OPTIONS) rpi_defconfig

uboot-menuconfig:
	make -C $(UBOOT_DIR) $(UBOOT_OPTIONS) menuconfig

uboot-clean:
	make -C $(UBOOT_DIR) $(UBOOT_OPTIONS) clean

uboot-mmc-scr:
	$(UBOOT_TOOLS)/mkimage  -A arm -O linux -T script -C none \
	    -n $(CONFIGS_UBOOT)/boot_mmc.scr \
	    -d $(CONFIGS_UBOOT)/boot_mmc.scr \
	    $(OUTPUT_DIR)/boot.scr.uimg

uboot-net-scr:
	$(UBOOT_TOOLS)/mkimage  -A arm -O linux -T script -C none \
	    -n $(CONFIGS_UBOOT)/boot_net.scr \
	    -d $(CONFIGS_UBOOT)/boot_net.scr \
	    $(OUTPUT_DIR)/boot.scr.uimg

