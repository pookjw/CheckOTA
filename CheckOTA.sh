#!/bin/sh

VERSION=7
VERBOSE=YES
INTERVAL=1 # 1 second
DEMO_MODE=NO
iOSPublicReleaseURL="http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
iOSDeveloperBetaURL="http://mesu.apple.com/assets/iOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
iOSPublicBetaURL10="http://mesu.apple.com/assets/iOSPublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
watchOSPublicReleaseURL="http://mesu.apple.com/assets/watch/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
watchOSDeveloperBetaURL="http://mesu.apple.com/assets/watchOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
watchOSPublicBetaURL2="http://mesu.apple.com/assets/R30.11TT05-subdivisions/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
tvOSPublicReleaseURL="http://mesu.apple.com/assets/tv/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
tvOSDeveloperBetaURL="http://mesu.apple.com/assets/tvOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
ApplePencilURL="http://mesu.apple.com/assets/com_apple_MobileAsset_MobileAccessoryUpdate_WirelessStylusFirmware/com_apple_MobileAsset_MobileAccessoryUpdate_WirelessStylusFirmware.xml"
SiriRemoteURL="http://mesu.apple.com/assets/tv/com_apple_MobileAsset_MobileAccessoryUpdate_WirelessRemoteFirmware/com_apple_MobileAsset_MobileAccessoryUpdate_WirelessRemoteFirmware.xml"
SmartKeyboardURL="http://mesu.apple.com/assets/com_apple_MobileAsset_MobileAccessoryUpdate_KeyboardCoverFirmware/com_apple_MobileAsset_MobileAccessoryUpdate_KeyboardCoverFirmware.xml"

function setUpdateURL(){
	while(true); do
		clear
		showLines "*"
		echo "Set Update URL"
		showLines "-"
		echo "(1) iOS Public Release"
		echo "(2) iOS Developer Beta"
		echo "(3) iOS Public Beta"
		echo "(4) watchOS Public Release"
		echo "(5) watchOS Developer Release"
		echo "(6) watchOS Public Beta"
		echo "(7) tvOS Public Release"
		echo "(8) tvOS Developer Beta"
		echo "(9) Apple Pencil"
		echo "(10) Siri Remote"
		echo "(11) Smart Keyboard (iPad Pro)"
		echo "(12) Enter URL manually"
		showLines "-"
		echo "Enter number. (Enter exit to quit.)"
		showLines "*"
		read -p "- " ANSWER
		if [[ "${ANSWER}" == 1 ]]; then
			UpdateURL="${iOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 2 ]]; then
			UpdateURL="${iOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 3 ]]; then
			UpdateURL="${iOSPublicBetaURL10}"
			break
		elif [[ "${ANSWER}" == 4 ]]; then
			UpdateURL="${watchOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 5 ]]; then
			UpdateURL="${watchOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 6 ]]; then
			UpdateURL="${watchOSPublicBetaURL2}"
			break
		elif [[ "${ANSWER}" == 7 ]]; then
			UpdateURL="${tvOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 8 ]]; then
			UpdateURL="${tvOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 9 ]]; then
			UpdateURL="${ApplePencilURL}"
			break
		elif [[ "${ANSWER}" == 10 ]]; then
			UpdateURL="${SiriRemoteURL}"
			break
		elif [[ "${ANSWER}" == 11 ]]; then
			UpdateURL="${SmartKeyboardURL}"
			break
		elif [[ "${ANSWER}" == 12 ]]; then
			echo "Enter URL. (See https://www.theiphonewiki.com/wiki/OTA_Updates#External_links)"
			read -p "- " UpdateURL
			if [[ ! -z "${UpdateURL}" ]]; then
				break
			elif [[ "${UpdateURL}" == exit ]]; then
				exit 0
			fi
		elif [[ "${ANSWER}" == showDevSet ]]; then
			clear
			showLines "*"
			echo "VERSION=${VERSION}"
			echo "VERBOSE=${VERBOSE}"
			echo "INTERVAL=${INTERVAL}"
			echo "DEMO_MODE=${DEMO_MODE}"
			echo "iOSPublicReleaseURL=${iOSPublicReleaseURL}"
			echo "iOSDeveloperBetaURL=${iOSDeveloperBetaURL}"
			echo "iOSPublicBetaURL10=${iOSPublicBetaURL10}"
			echo "watchOSPublicReleaseURL=${watchOSPublicReleaseURL}"
			echo "watchOSDeveloperBetaURL=${watchOSDeveloperBetaURL}"
			echo "watchOSPublicBetaURL2=${watchOSPublicBetaURL2}"
			echo "tvOSPublicReleaseURL=${tvOSPublicReleaseURL}"
			echo "tvOSDeveloperBetaURL=${tvOSDeveloperBetaURL}"
			echo "ApplePencilURL=${ApplePencilURL}"
			echo "SiriRemoteURL=${SiriRemoteURL}"
			echo "SmartKeyboardURL=${SmartKeyboardURL}"
			showLines "*"
			read -s -n 1 -p "Press any key to continue..."
		elif [[ "${ANSWER}" == exit ]]; then
			exit 0
		elif [[ -z "${ANSWER}" ]]; then
			:
		else
			echo "Enter number correctly."
			read -s -n 1 -p "Press any key to continue..."
		fi
	done
}

function startService(){
	clear
	showLines "*"
	if [[ -f /tmp/catalog.xml ]]; then
		rm /tmp/catalog.xml
	fi
	if [[ "${VERBOSE}" == NO ]]; then
		curl -o /tmp/catalog.xml "${UpdateURL}" > /dev/null 2>&1
	else
		curl -o /tmp/catalog.xml "${UpdateURL}"
	fi
	FIRST_SHA="$(shasum /tmp/catalog.xml | awk '{ print $1 }')"
	if [[ "${VERBOSE}" == NO ]]; then
		echo "Started!"
	else
		echo "Started! (${FIRST_SHA})"
	fi
	COUNT=0
	while(true); do
		sleep "${INTERVAL}"
		COUNT=$((${COUNT}+1))
		if [[ "${VERBOSE}" == NO ]]; then
			echo "Checking... (${COUNT})"
		else
			echo "\033[1;36mChecking... (${COUNT})\033[0m"
		fi
		if [[ -f /tmp/catalog.xml ]]; then
			rm /tmp/catalog.xml
		fi
		if [[ "${VERBOSE}" == NO ]]; then
			curl -o /tmp/catalog.xml "${UpdateURL}" > /dev/null 2>&1
		else
			curl -o /tmp/catalog.xml "${UpdateURL}"
		fi
		if [[ ! "${DEMO_MODE}" == NO && "${COUNT}" == 5 ]]; then
			LATER_SHA=TEST
		else
			LATER_SHA="$(shasum /tmp/catalog.xml | awk '{ print $1 }')"
		fi
		if [[ "${VERBOSE}" == YES ]]; then
			echo "${LATER_SHA}"
		fi
		if [[ ! "${FIRST_SHA}" == "${LATER_SHA}" ]]; then
			echo "\033[1;36mFound update!\033[0m Check update from your device."
			rm /tmp/catalog.xml
			break			
		fi
	done
	showLines "*"
	exit 0
}

function showLines(){
	PRINTED_COUNTS=0
	COLS=`tput cols`
	if [ "${COLS}" -ge 1 ]; then
		while [[ ! ${PRINTED_COUNTS} == $COLS ]]; do
			printf "${1}"
			PRINTED_COUNTS=$((${PRINTED_COUNTS}+1))
		done
		echo
	fi
}

#######################################

setUpdateURL
startService
