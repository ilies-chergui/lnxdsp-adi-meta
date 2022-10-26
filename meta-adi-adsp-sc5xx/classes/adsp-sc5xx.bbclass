inherit core-image extrausers adsp-sc5xx-compatible

SUMMARY = "Minimal image for Analog Devices ADSP-SC5xx boards"
LICENSE = "MIT"

ICC = " \
	rpmsg-echo-example \
	rpmsg-utils \
"

#Not currently compiling for 64 bit -- skip for now
def crypto(d):
  CRYPTO = ""
  MACHINE = d.getVar('MACHINE')
  if MACHINE == 'adsp-sc598-som-ezkit':
    CRYPTO = ""
  else:
    CRYPTO = "cryptodev-module crypto-tests"
  return CRYPTO

CRYPTO = " \
	openssl \
	openssl-bin \
	cryptodev-linux \
	${@crypto(d)} \
"
ADI_AUDIO_BINARIES = "${@bb.utils.contains_any('DISTRO_FEATURES', 'adi_hybrid_audio adi_sharc_alsa_audio', 'sharc-audio', '', d)}"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    packagegroup-base \
    ${CORE_IMAGE_EXTRA_INSTALL} \
	${ADI_AUDIO_BINARIES} \
	alsa-utils \
    openssh \
    openssl \
    iproute2 \
    iproute2-tc \
    ncurses \
    busybox-watchdog-init \
    util-linux \
    rng-tools \
    spidev-test \
    spitools \
    ${ICC} \
    ${CRYPTO} \
"

IMAGE_INSTALL_append_adsp-sc589-ezkit = " \
    remoteproc-examples-sc589 \
"

IMAGE_INSTALL_append_adsp-sc594-som-ezkit = " \
	remoteproc-examples-sc594 \
"

EXTRA_USERS_PARAMS = " \
	usermod -P adi root; \
"
