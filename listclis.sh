#!/bin/bash
cd "${BASH_SOURCE%/*}" || exit

# Optionally just get the cli for a single coin
# e.g "KMD"
specific_coin=$1

litecoin_cli="litecoin-cli"
chips_cli="chips-cli"
mcl_cli="komodo-cli -ac_name=MCL"
gleecbtc_cli="hush-cli"
einsteinium_cli="einsteinium-cli"
ayacoin_cli="aryacoin-cli"
komodo_cli="komodo-cli"
verus_cli="vrsc-cli"

if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "LTC" ]]; then
  echo ${litecoin_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "CHIPS" ]]; then
  echo ${chips_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "GAME" ]]; then
  echo ${game_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "HUSH" ]]; then
  echo ${hush_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "EMC2" ]]; then
  echo ${einsteinium_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "AYA" ]]; then
  echo ${ayacoin_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "VRSC" ]]; then
  echo ${verus_cli}
fi
if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "KMD" ]]; then
  echo ${komodo_cli}
fi

./listassetchains | while read coin; do
  if [[ -z "${specific_coin}" ]] || [[ "${specific_coin}" = "${coin}" ]]; then
    echo "${komodo_cli} -ac_name=${coin}"
  fi
done
