################################################################################
#
# ncftp
#
################################################################################

NCFTP_VERSION = 3.2.6
# use .gz as upstream .xz tarball has changed after the hash was added for
# 2017.02. Can be changed back to .xz when version is bumped
NCFTP_SOURCE = ncftp-$(NCFTP_VERSION)-src.tar.gz
NCFTP_SITE = https://www.ncftp.com/public_ftp/ncftp/older_versions
NCFTP_TARGET_BINS = ncftp
NCFTP_LICENSE = ClArtistic
NCFTP_LICENSE_FILES = doc/LICENSE.txt

NCFTP_DEPENDENCIES = host-autoconf
NCFTP_CONF_OPTS = --disable-ccdv

# The bundled configure script is generated by autoconf 2.13 and doesn't
# detect cross-compilation correctly. Therefore, we have to regenerate it.
# We need to pass -I because of the non-standard m4 directory name, and
# none of the other autotools are used, so the below is the easiest.
define NCFTP_RUN_AUTOCONF
	(cd $(@D); $(AUTOCONF) -I$(@D)/autoconf_local/)
endef
NCFTP_PRE_CONFIGURE_HOOKS += NCFTP_RUN_AUTOCONF

ifeq ($(BR2_PACKAGE_NCFTP_GET),y)
NCFTP_TARGET_BINS += ncftpget
endif

ifeq ($(BR2_PACKAGE_NCFTP_PUT),y)
NCFTP_TARGET_BINS += ncftpput
endif

ifeq ($(BR2_PACKAGE_NCFTP_LS),y)
NCFTP_TARGET_BINS += ncftpls
endif

ifeq ($(BR2_PACKAGE_NCFTP_BATCH),y)
NCFTP_TARGET_BINS += ncftpbatch
NCFTP_INSTALL_NCFTP_BATCH = \
	ln -sf /usr/bin/ncftpbatch $(TARGET_DIR)/usr/bin/ncftpspooler
endif

ifeq ($(BR2_PACKAGE_NCFTP_BOOKMARKS),y)
NCFTP_TARGET_BINS += ncftpbookmarks
NCFTP_DEPENDENCIES += ncurses
endif

define NCFTP_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(addprefix $(NCFTP_DIR)/bin/, $(NCFTP_TARGET_BINS)) $(TARGET_DIR)/usr/bin
	$(NCFTP_INSTALL_NCFTP_BATCH)
endef

$(eval $(autotools-package))
