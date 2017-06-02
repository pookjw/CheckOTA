#!/bin/sh

VERSION=4
VERBOSE=YES
INTERVAL=1 # 1 second
TEST_MODE=NO
iOSPublicReleaseURL="http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
iOSPublicReleaseDocumentationURL="http://mesu.apple.com/assets/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
iOSDeveloperBetaURL="http://mesu.apple.com/assets/iOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
iOSDeveloperBetaDocumentationURL="http://mesu.apple.com/assets/iOSDeveloperSeed/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"
iOSPublicBetaURL10="http://mesu.apple.com/assets/iOSPublicSeed/com_apple_MobileAsset_SoftwareUpdate/com_apple_MobileAsset_SoftwareUpdate.xml"
iOSPublicBetaDocumentationURL10="http://mesu.apple.com/assets/iOSPublicSeed/com_apple_MobileAsset_SoftwareUpdateDocumentation/com_apple_MobileAsset_SoftwareUpdateDocumentation.xml"

function setUpdateURL(){
	while(true); do
		clear
		showLines "*"
		echo "Set Update URL"
		showLines "-"
		echo "(1) iOS Public Release \033[1;36m(Recommended)\033[0m"
		echo "(2) iOS Public Release Documentation"
		echo "(3) iOS Developer Beta \033[1;36m(Recommended)\033[0m"
		echo "(4) iOS Developer Beta Documentation"
		echo "(5) iOS Public Beta \033[1;36m(Recommended)\033[0m"
		echo "(6) iOS Public Beta Documentation"
		echo "(7) Enter URL manually (See https://www.theiphonewiki.com/wiki/OTA_Updates#External_links)"
		if [[ "${VERBOSE}" == NO ]]; then
			echo "(8) Enable verbose mode."
		else
			echo "(8) Disable verbose mode."
		fi
		showLines "-"
		echo "Enter number. (Enter exit to quit.)"
		showLines "*"
		read -p "- " ANSWER
		if [[ "${ANSWER}" == 1 ]]; then
			UpdateURL="${iOSPublicReleaseURL}"
			break
		elif [[ "${ANSWER}" == 2 ]]; then
			UpdateURL="${iOSPublicReleaseDocumentationURL}"
			break
		elif [[ "${ANSWER}" == 3 ]]; then
			UpdateURL="${iOSDeveloperBetaURL}"
			break
		elif [[ "${ANSWER}" == 4 ]]; then
			UpdateURL="${iOSDeveloperBetaDocumentationURL}"
			break
		elif [[ "${ANSWER}" == 5 ]]; then
			UpdateURL="${iOSPublicBetaURL10}"
			break
		elif [[ "${ANSWER}" == 6 ]]; then
			UpdateURL="${iOSPublicBetaDocumentationURL10}"
			break
		elif [[ "${ANSWER}" == 7 ]]; then
			echo "Enter URL."
			read -p "- " UpdateURL
			if [[ ! -z "${UpdateURL}" ]]; then
				break
			elif [[ "${UpdateURL}" == exit ]]; then
				exit 0
			fi
		elif [[ "${ANSWER}" == 8 ]]; then
			if [[ "${VERBOSE}" == NO ]]; then
				echo "VERBOSE=YES"
				VERBOSE=YES
			else
				echo "VERBOSE=NO"
				VERBOSE=NO
			fi
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
		if [[ ! "${TEST_MODE}" == NO && "${COUNT}" == 5 ]]; then
			LATER_SHA=TEST
		else
			LATER_SHA="$(shasum /tmp/catalog.xml | awk '{ print $1 }')"
		fi
		if [[ "${VERBOSE}" == YES ]]; then
			echo "${LATER_SHA}"
		fi
		if [[ ! "${FIRST_SHA}" == "${LATER_SHA}" ]]; then
			echo "\033[1;36mFound update!\033[0m Check from your iOS Device."
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

if [[ ! "${TEST_MODE}" == NO ]]; then
	echo "Enabled TEST_MODE."
	read -s -n 1 -p "Press any key to continue..."
fi
setUpdateURL
startService
