#!/bin/sh

VERSION=13
VERBOSE=NO
INTERVAL=1 # 1 second
DEMO_MODE=NO
macOSPublicReleaseURL1012="https://swscan.apple.com/content/catalogs/others/index-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
macOSDeveloperBetaURL1012="https://swscan.apple.com/content/catalogs/others/index-10.12seed-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
macOSPublicBetaURL1012="https://swscan.apple.com/content/catalogs/others/index-10.12beta-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"
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

function setTempPath(){
	if [[ ! -d /tmp/CheckOTA ]]; then
		mkdir /tmp/CheckOTA
	fi
	COUNT=0
	while(true); do
		COUNT=$((${COUNT}+1))
		if [[ ! -d "/tmp/CheckOTA/${COUNT}" ]]; then
			mkdir "/tmp/CheckOTA/${COUNT}"
			TEMP_PATH="/tmp/CheckOTA/${COUNT}"
			break
		fi
	done
}

function setUpdateURL(){
	while(true); do
		clear
		showLines "*"
		echo "Set Update URL"
		showLines "-"
		echo "(\033[1;36m1\033[0m) macOS Public Release (macOS 10.12)"
		echo "(\033[1;36m2\033[0m) macOS Developer Beta (macOS 10.12)"
		echo "(\033[1;36m3\033[0m) macOS Public Beta (macOS 10.12)"
		echo "(\033[1;36m4\033[0m) iOS Public Release"
		echo "(\033[1;36m5\033[0m) iOS Developer Beta (iOS 10)"
		echo "(\033[1;36m6\033[0m) iOS Public Beta (iOS 10)"
		echo "(\033[1;36m7\033[0m) watchOS Public Release"
		echo "(\033[1;36m8\033[0m) watchOS Developer Beta"
		echo "(\033[1;36m9\033[0m) watchOS Public Beta"
		echo "(\033[1;36m10\033[0m) tvOS Public Release"
		echo "(\033[1;36m11\033[0m) tvOS Developer Beta"
		echo "(\033[1;36m12\033[0m) Apple Pencil"
		echo "(\033[1;36m13\033[0m) Siri Remote"
		echo "(\033[1;36m14\033[0m) Smart Keyboard (iPad Pro)"
		echo "(\033[1;36m15\033[0m) Enter URL manually"
		showLines "-"
		echo "Enter a number. (Enter \033[1;36mexit\033[0m to quit.)"
		showLines "*"
		read -p "- " ANSWER
		if [[ "${ANSWER}" == 1 ]]; then
			UpdateURL="${macOSPublicReleaseURL1012}"
			break
		elif [[ "${ANSWER}" == 2 ]]; then
			UpdateURL="${macOSDeveloperBetaURL1012}"
			break
		elif [[ "${ANSWER}" == 3 ]]; then
			UpdateURL="${macOSPublicBetaURL1012}"
			break
		elif [[ "${ANSWER}" == 4 ]]; then
			UpdateURL="${iOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 5 ]]; then
			UpdateURL="${iOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 6 ]]; then
			UpdateURL="${iOSPublicBetaURL10}"
			break
		elif [[ "${ANSWER}" == 7 ]]; then
			UpdateURL="${watchOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 8 ]]; then
			UpdateURL="${watchOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 9 ]]; then
			UpdateURL="${watchOSPublicBetaURL2}"
			break
		elif [[ "${ANSWER}" == 10 ]]; then
			UpdateURL="${tvOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 11 ]]; then
			UpdateURL="${tvOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 12 ]]; then
			UpdateURL="${ApplePencilURL}"
			break
		elif [[ "${ANSWER}" == 13 ]]; then
			UpdateURL="${SiriRemoteURL}"
			break
		elif [[ "${ANSWER}" == 14 ]]; then
			UpdateURL="${SmartKeyboardURL}"
			break
		elif [[ "${ANSWER}" == 15 ]]; then
			echo "Enter URL. (See https://www.theiphonewiki.com/wiki/OTA_Updates#External_links)"
			read -p "- " UpdateURL
			if [[ ! -z "${UpdateURL}" ]]; then
				break
			elif [[ "${UpdateURL}" == exit ]]; then
				quitTool
			fi
		elif [[ "${ANSWER}" == showDevSet ]]; then
			clear
			showLines "*"
			echo "\033[1;36mVERSION\033[0m=${VERSION}"
			echo "\033[1;36mVERBOSE\033[0m=${VERBOSE}"
			echo "\033[1;36mINTERVAL\033[0m=${INTERVAL}"
			echo "\033[1;36mDEMO_MODE\033[0m=${DEMO_MODE}"
			echo "\033[1;36mTEMP_PATH\033[0m=${TEMP_PATH}"
			echo "\033[1;36mmacOSPublicReleaseURL1012\033[0m=${macOSPublicReleaseURL1012}"
			echo "\033[1;36mmacOSDeveloperBetaURL1012\033[0m=${macOSDeveloperBetaURL1012}"
			echo "\033[1;36mmacOSPublicBetaURL1012\033[0m=${macOSPublicBetaURL1012}"
			echo "\033[1;36miOSPublicReleaseURL\033[0m=${iOSPublicReleaseURL}"
			echo "\033[1;36miOSDeveloperBetaURL\033[0m=${iOSDeveloperBetaURL}"
			echo "\033[1;36miOSPublicBetaURL10\033[0m=${iOSPublicBetaURL10}"
			echo "\033[1;36mwatchOSPublicReleaseURL\033[0m=${watchOSPublicReleaseURL}"
			echo "\033[1;36mwatchOSDeveloperBetaURL\033[0m=${watchOSDeveloperBetaURL}"
			echo "\033[1;36mwatchOSPublicBetaURL2\033[0m=${watchOSPublicBetaURL2}"
			echo "\033[1;36mtvOSPublicReleaseURL\033[0m=${tvOSPublicReleaseURL}"
			echo "\033[1;36mtvOSDeveloperBetaURL\033[0m=${tvOSDeveloperBetaURL}"
			echo "\033[1;36mApplePencilURL\033[0m=${ApplePencilURL}"
			echo "\033[1;36mSiriRemoteURL\033[0m=${SiriRemoteURL}"
			echo "\033[1;36mSmartKeyboardURL\033[0m=${SmartKeyboardURL}"
			showLines "*"
			read -s -n 1 -p "Press any key to continue..."
		elif [[ "${ANSWER}" == exit ]]; then
			quitTool
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
	if [[ -f "${TEMP_PATH}/catalog.xml" ]]; then
		rm "${TEMP_PATH}/catalog.xml"
	fi
	if [[ "${VERBOSE}" == NO ]]; then
		curl -o "${TEMP_PATH}/catalog.xml" "${UpdateURL}" > /dev/null 2>&1
	else
		curl -o "${TEMP_PATH}/catalog.xml" "${UpdateURL}"
	fi
	FIRST_SHA="$(shasum "${TEMP_PATH}/catalog.xml" | awk '{ print $1 }')"
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
		if [[ -f "${TEMP_PATH}/catalog.xml" ]]; then
			rm "${TEMP_PATH}/catalog.xml"
		fi
		if [[ "${VERBOSE}" == NO ]]; then
			curl -o "${TEMP_PATH}/catalog.xml" "${UpdateURL}" > /dev/null 2>&1
		else
			curl -o "${TEMP_PATH}/catalog.xml" "${UpdateURL}"
		fi
		if [[ ! "${DEMO_MODE}" == NO && "${COUNT}" == 5 ]]; then
			LATER_SHA=TEST
		else
			LATER_SHA="$(shasum "${TEMP_PATH}/catalog.xml" | awk '{ print $1 }')"
		fi
		if [[ "${VERBOSE}" == YES ]]; then
			echo "${LATER_SHA}"
		fi
		if [[ ! "${FIRST_SHA}" == "${LATER_SHA}" ]]; then
			echo "\033[1;36mFound update!\033[0m Check update from your device. (Captured time : $(date "+%Y-%m-%d_%H:%M:%S"))"
			break			
		fi
	done
	showLines "*"
	quitTool
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

function quitTool(){
	rm -rf "${TEMP_PATH}"
	exit 0
}

#######################################

setTempPath
setUpdateURL
startService
