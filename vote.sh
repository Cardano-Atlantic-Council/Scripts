#!/bin/bash

################################################################################
# Please change these variables and make sure the script is executable         #
# Also make sure to run it from your signing key directory                     #
################################################################################

defaultName="changeMe" # Default name of the output file (e.g. mike.witness)
defaultKeyPath="change.voting.skey" # Default path of your signing key file
defaultTxBodyFile="body.json" # Default expected name of the transaction body file
defaultHotCredential="07e0eb70a1cfd5de084b5fcc8a9b28ff7772282b57e760d692c75bde" # CAC hot credential hash for validation

################################################################################
# Do not change anything below this line                                       #
################################################################################

# Colors for now and future use
#BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
#BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
#BRIGHTBLACK='\033[0;30;1m'
#BRIGHTRED='\033[0;31;1m'
#BRIGHTGREEN='\033[0;32;1m'
#BRIGHTYELLOW='\033[0;33;1m'
#BRIGHTBLUE='\033[0;34;1m'
#BRIGHTMAGENTA='\033[0;35;1m'
#BRIGHTCYAN='\033[0;36;1m'
BRIGHTWHITE='\033[0;37;1m'
NC='\033[0m'

# Usage Instructions
show_usage() {
  echo -e "
${BRIGHTWHITE}A command line script to confirm a Cardano Constitutional Committee transaction
and generate a witness file.${NC}

${BRIGHTWHITE}Usage:${NC} ${GREEN}$(basename $0)${NC} ${BRIGHTWHITE}<txBodyFile> <keyPath> <txName> [credentialHash]${NC}

${BRIGHTWHITE}Arguments:${NC}
${WHITE}<txBodyFile>     ${NC} The path to the transaction body file to validate. ${MAGENTA}Required.
${WHITE}<keyPath>        ${NC} The path to the signing key to use for the witness. ${MAGENTA}Required.
${WHITE}<txName>         ${NC} The name to use for the output witness file. ${MAGENTA}Required.
${WHITE}[credentialHash] ${NC} The CC credential hash to validate against. ${YELLOW}Optional

${BRIGHTWHITE}Examples:${NC}

${GREEN}$(basename $0)${NC} body.json adam.voter.skey vote.240902 07e0eb70a1cfd5de084b5fcc8a9b28ff7772282b57e760d692c75bde
${GREEN}$(basename $0)${NC} body.json ~/keys/adam.delegation.skey delegation.240827
${GREEN}$(basename $0)${NC} ~/txns/vote.241201.json ~/keys/jenny.voter.skey vote.241201 07e0eb70a1cfd5de084b5fcc8a9b28ff7772282b57e760d692c75bde"
}

WIDTH=$(tput cols)
PAD=$(("$(("$WIDTH" - 90))" / 2))
if [ "$PAD" -gt 11 ]; then
PADDING=$(printf "%9s" "")
else
PADDING=""
fi

if [ $# -lt 3 ] && [ $# -gt 0 ]; then
  show_usage
  exit 1;
fi

txBodyFile="${1:-$defaultTxBodyFile}"
keyPath="${2:-$defaultKeyPath}"
name="${3:-$defaultName}"
hotCredentialHash="${4:-$defaultHotCredential}"

# Witness transaction function
witness_tx() {
    cardano-cli conway transaction witness \
        --signing-key-file $keyPath \
        --mainnet \
        --tx-body-file $txBodyFile \
        --out-file $name.witness
}

# Process transaction information
tx_info() {
  if [ "$keyPath" = "change.voting.skey" ] || [ "$name" = "changeMe" ]; then
    echo -e "${RED}Please change the ${YELLOW}name${RED} and ${YELLOW}keyPath${RED} variable in the script with your name and the path to your Cardano signing key${NC}"
    exit 1
  fi
  if [ -f "$txBodyFile" ] && grep -q '"type": "Unwitnessed Tx ConwayEra"' "$txBodyFile"; then
    vote_info=$(cardano-cli conway transaction view --tx-body-file "$txBodyFile" 2>/dev/null | grep -A10 '"voters":')
    committee_script_hash=$(echo "$vote_info" | grep '"committee-scriptHash-' | sed 's/.*"committee-scriptHash-\([^"]*\)".*/\1/' | tr -d '[:space:]')
    govID=$(echo "$vote_info" | sed -n '3p' | tr -d '[:space:]"' | cut -c 1-64)
    url=$(echo "$vote_info" | grep '"url":' | sed 's/.*"url": *"\([^"]*\)".*/\1/')
    vote_content=$(echo "$vote_info" | grep '"decision":' | sed 's/.*"decision": *"\([^"]*\)".*/\1/')
    if [ -z "$vote_content" ]; then
      echo -e "${RED}The transaction is not a vote transaction please check if you have the right transaction body file and try again${NC}"
      exit 1
    fi
    if [ "$committee_script_hash" = "$hotCredentialHash" ]; then
      scriptValidation="\n${GREEN}The credential validation passed${NC}"
    else
      scriptValidation="\n${RED}The credential validation failed${NC}"
    fi
  else
    echo -e "${RED}The script cannot find the transaction body file (${BRIGHTWHITE}body.json${RED}).\r\nPlease move it to the same directory as your key and make sure it has readable permissions${NC}"
    exit 1
  fi

  if [ -f "$keyPath" ]; then
    echo -e "${CYAN}Hot Script Hash:${NC} ${committee_script_hash} ${scriptValidation}"
    if [ "$committee_script_hash" != "$hotCredentialHash" ]; then
      exit 1
    fi
    echo ""
    echo -e "${CYAN}The governance ID you are voting on is:${NC} ${govID}"
    echo -e "${CYAN}This governance action justification link is:${NC} ${url}"
    echo -e "${CYAN}The vote you are casting is:${NC} ${vote_content}"
  else
    echo -e "${RED}The script cannot find your signing key, please verify the ${YELLOW}name${RED} and ${YELLOW}keyPath${RED} variable${NC}"
    exit 1
  fi
}

# Print a pretty image of Grace!
generate_image() {
  WIDTH=$(tput cols)
  if [ "$WIDTH" -gt 89 ]; then
echo -e "${CYAN}
${PADDING}                               .^!J5GB#&&&@@@@&&&&#BPY7~:.
${PADDING}                          .^?G#@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BY!.
${PADDING}                      .!P&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BJ:
${PADDING}                   :J#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&G~
${PADDING}                .J&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G~
${PADDING}              ~B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&J.
${PADDING}            !&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5.
${PADDING}          ~&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#####&&@@@@@@@@@@@@@@@@@@@@@Y
${PADDING}        .G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BY!:.           .^7P&@@@@@@@@@@@@@@@@@!
${PADDING}       !@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&G!.                      .J&@@@@@@@@@@@@@@@G
${PADDING}      5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P^                             !&@@@@@@@@@@@@@@&:
${PADDING}     B@@@@@@@@@@@@@@@@@@@@@@@@@@@&7                                  G@@@@@@@@@@@@@@@^
${PADDING}    B@@@@@@@@@@@@@@@@@@@@@@@@@@&!                  ${WHITE}.${CYAN}                  B@@@@@@@@@@@@@@@^
${PADDING}   G@@@@@@@@@@@@@@@@@@@@@@@&&#?                  ${WHITE}7@@@B${CYAN}                .@@@@@@@@@@@@@@@@.
${PADDING}  7@@@@@@@@@@@@@@@@@@#P?^.                       ${WHITE}J@@@&${CYAN}                 &@@@@@@@@@@@@@@@&
${PADDING} .@@@@@@@@@@@@@@@&5^                              ${WHITE}.:.${CYAN}                   ^Y&@@@@@@@@@@@@@J
${PADDING} Y@@@@@@@@@@@@@&!                                      ${WHITE}.^!?YY555YYYJJ?7^${CYAN}   ?@@@@@@@@@@@@@
${PADDING} &@@@@@@@@@@@@5                                    ${WHITE}~5&@@@@@@@@@@@@@@@@@@@:${CYAN}  #@@@@@@@@@@@@7
${PADDING}^@@@@@@@@@@@@@Y...                              ${WHITE}.P@@@@@@@@@@@@@@@@@@@&#P~${CYAN}  ^@@@@@@@@@@@@@B
${PADDING}7@@@@@@@@@@@@@@@@@&#Y:                          ${WHITE}^G@@@@@@@@@@@&BY7^.${CYAN}     .~G@@@@@@@@@@@@@@&
${PADDING}J@@@@@@@@@@@@@@@@@@@@@P              ${WHITE}..          :@@@@@@@B?:${CYAN}    .:~?5B&@@@@@@@@@@@@@@@@@@@
${PADDING}J@@@@@@@@@@@@@@@@@@@@@@.             ${WHITE}B.         ^@@@@&5^${CYAN}        #@@@@@@@@@@@@@@@@@@@@@@@@@
${PADDING}!@@@@@@@@@@@@@@@@@@@@@@.            ${WHITE}:@        :G@@@#~${CYAN}           .@@@@@@@@@@@@@@@@@@@@@@@@&
${PADDING}.@@@@@@@@@@@@@@@@@@@@@@.            ${WHITE}:@:     ~B@@@&^${CYAN}  :P7         G@@@@@@@@@@@@@@@@@@@@@@@G
${PADDING} !@@@@@@@@@@@@@@@@@@@@@#              ${WHITE}~@@@@@@@@!${CYAN}  ~@@@@@@@@P^   .@@@@@@@@@@@@@@@@@@@@@@@&
${PADDING}  #@@@@@@@@@@@@@@@@@@@@@!             ${WHITE}~@@@@@@@5${CYAN}  ^@@@@@@@@@@@@##@@@@@@@@@@@@@@@@@@@@@@@@~
${PADDING}  :@@@@@@@@@@@@@@@@@@@@@@.            ${WHITE}.@@@@@@@.${CYAN}  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P
${PADDING}   !@@@@@@@@@@@@@@@@@@@@@&.            ${WHITE}G@@@@@@${CYAN}   @@@@@@@&G555PB&@@@@@@@@@@@@@@@@@@@@@@#
${PADDING}    !@@@@@@@@@@@@@@@@@@@B!             ${WHITE}.@@@@@@.${CYAN}  #@@@B!.        :5@@@@@@@@@@@@@@@@@@@G
${PADDING}      ?#@@@@@@@@@@@@@@P:                ${WHITE}^@@@@@G${CYAN}  :&P:              7&@@@@@@@@@@@@@&P:
${PADDING}        .^75GB####GY~                    ${WHITE}.5B###:${CYAN}                     :?PB####BPJ~.
${PADDING}
${PADDING}            ${WHITE}##################################################################
${PADDING}            #            Welcome to the CAC offline voter script             #
${PADDING}            ##################################################################
${NC}"
else
  if [ "$WIDTH" -gt 63 ]; then
  PADDING=$(printf "%$(($((WIDTH - 63)) / 2))s" "")
  echo -e "${CYAN}
${PADDING}@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#####&&@@@@@@@@@@@@@@@@@@@
${PADDING}@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BY!:.           .^7P&@@@@@@@@@@@@@
${PADDING}@@@@@@@@@@@@@@@@@@@@@@@@&G!.                      .J&@@@@@@@@@@
${PADDING}@@@@@@@@@@@@@@@@@@@@@@P^                             !&@@@@@@@@
${PADDING}@@@@@@@@@@@@@@@@@@@&7                                  G@@@@@@@
${PADDING}@@@@@@@@@@@@@@@@@&!                  ${WHITE}.${CYAN}                  B@@@@@@
${PADDING}@@@@@@@@@@@@@&&#?                  ${WHITE}7@@@B${CYAN}                .@@@@@@
${PADDING}@@@@@@@#P?^.                       ${WHITE}J@@@&${CYAN}                 &@@@@@
${PADDING}@@@&5^                              ${WHITE}.:.${CYAN}                   ^Y&@@
${PADDING}@&!                                      ${WHITE}.^!?YY555YYYJJ?7^${CYAN}   ?@
${PADDING}5                                    ${WHITE}~5&@@@@@@@@@@@@@@@@@@@:${CYAN}  #
${PADDING}Y...                              ${WHITE}.P@@@@@@@@@@@@@@@@@@@&#P~${CYAN}  ^@
${PADDING}@@@@&#Y:                          ${WHITE}^G@@@@@@@@@@@&BY7^.${CYAN}     .~G@@
${PADDING}@@@@@@@@P              ${WHITE}..          :@@@@@@@B?:${CYAN}    .:~?5B&@@@@@@
${PADDING}@@@@@@@@@.             ${WHITE}B.         ^@@@@&5^${CYAN}        #@@@@@@@@@@@@
${PADDING}@@@@@@@@@.            ${WHITE}:@        :G@@@#~${CYAN}           .@@@@@@@@@@@@
${PADDING}@@@@@@@@@.            ${WHITE}:@:     ~B@@@&^${CYAN}  :P7         G@@@@@@@@@@@
${PADDING}@@@@@@@@@#              ${WHITE}~@@@@@@@@!${CYAN}  ~@@@@@@@@P^   .@@@@@@@@@@@@
${PADDING}@@@@@@@@@@!             ${WHITE}~@@@@@@@5${CYAN}  ^@@@@@@@@@@@@##@@@@@@@@@@@@@
${PADDING}@@@@@@@@@@@.            ${WHITE}.@@@@@@@.${CYAN}  #@@@@@@@@@@@@@@@@@@@@@@@@@@@
${PADDING}@@@@@@@@@@@&.            ${WHITE}G@@@@@@${CYAN}   @@@@@@@&G555PB&@@@@@@@@@@@@@
${PADDING}@@@@@@@@@@B!             ${WHITE}.@@@@@@.${CYAN}  #@@@B!.        :5@@@@@@@@@@@
${PADDING}@@@@@@@@P:                ${WHITE}^@@@@@G${CYAN}  :&P:              7&@@@@@@@@
${PADDING}####GY~                    ${WHITE}.5B###:${CYAN}                     :?PB####
${PADDING}
${PADDING}${BRIGHTWHITE}###############################################################
${PADDING}#          Welcome to the CAC offline voter script            #
${PADDING}###############################################################
${NC}"
    else
      echo -e "${BRIGHTWHITE}
###########################################
# Welcome to the CAC offline voter script #
###########################################
${NC}"
    fi
  fi
}
main() {
    generate_image
    tx_info
    echo -e "\n${YELLOW}Do you agree to sign this transaction? (y/n)${NC}"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        witness_tx
        echo -e "${GREEN}Transaction signed successfully.${NC}"
    else
        echo -e "${CYAN}Transaction signing cancelled.${NC}"
        exit 0
    fi
} 
main
