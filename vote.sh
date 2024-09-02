#! /bin/bash

##########################################################################
# Please change these 2 variables and make sure the script is executable #
# Also make sure to run it from your signing key directory               #        
##########################################################################

name=mike                 # Change this with your name (example: jenny)
keyPath=mike-voting.skey  # Change this with your own signing key (example: jenny-voting.skey)


###########################################
# Do not change anything below this line #
#########################################

# Variables
txBodyFile=body.json
hotCredentialHash="07e0eb70a1cfd5de084b5fcc8a9b28ff7772282b57e760d692c75bde" # CAC hot credential hash for validation

# Colors for now and future use
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Witness transaction function
witness_tx() {
    cardano-cli conway transaction witness \
        --signing-key-file $keyPath \
        --mainnet \
        --tx-body-file $txBodyFile \
        --out-file $name.witness
}

tx_info() {
    if [ -f "$txBodyFile" ] && grep -q '"type": "Unwitnessed Tx ConwayEra"' "$txBodyFile"; then
        vote_info=$(cardano-cli conway transaction view --tx-body-file $txBodyFile 2>/dev/null | grep -A10 '"voters":')
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
        echo -e "${RED}The script cannot find the transaction body file (${YELLOW}body.json${RED}). Please move it to the same directory as your key and make sure it has readable permissions${NC}"
        exit 1
    fi
    if [ "$keyPath" = "mike-voting.skey" ] || [ "$name" = "mike" ]; then
        echo -e "${RED}Please change the ${YELLOW}name${RED} and ${YELLOW}keyPath${RED} variable in the script with your name and the path to your Cardano signing key${NC}"
        exit 1
    else
        if [ -f "$keyPath" ]; then
            echo -e "${CYAN}CAC hot script hash:${NC} ${committee_script_hash} ${scriptValidation}"
            echo ""
            echo -e "${CYAN}The governance ID you are voting on is:${NC} ${govID}"
            echo -e "${CYAN}This governance action justification link is:${NC} ${url}"
            echo -e "${CYAN}The vote you are casting is:${NC} ${vote_content}"
        else
            echo -e "${RED}The script cannot find your signing key, please verify the ${YELLOW}name${RED} and ${YELLOW}keyPath${RED} variable${NC}"
            exit 1
        fi
    fi
}

generate_image() {    
echo -e "${WHITE} 

                                           .^!J5GB#&&&@@@@&&&&#BPY7~:.                                                                                                                                 
                                      .^?G#@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BY!.                                                                                                                            
                                  .!P&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BJ:                                                                                                                        
                               :J#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&G~                                                                                                                     
                            .J&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@G~                                                                                                                  
                          ~B@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&J.                                                                 
                        !&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@5.                                                           
                      ~&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#####&&@@@@@@@@@@@@@@@@@@@@@Y                                  
                    .G@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&BY!:.           .^7P&@@@@@@@@@@@@@@@@@!                                
                   !@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&G!.                      .J&@@@@@@@@@@@@@@@G                                
                  5@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P^                             !&@@@@@@@@@@@@@@&:                         
                 B@@@@@@@@@@@@@@@@@@@@@@@@@@@&7                                  G@@@@@@@@@@@@@@@^                           
                B@@@@@@@@@@@@@@@@@@@@@@@@@@&!                  .                  B@@@@@@@@@@@@@@@^                                                                                                     
               G@@@@@@@@@@@@@@@@@@@@@@@&&#?                  7@@@B                .@@@@@@@@@@@@@@@@.                            
              7@@@@@@@@@@@@@@@@@@#P?^.                       J@@@&                 &@@@@@@@@@@@@@@@&                                 
             .@@@@@@@@@@@@@@@&5^                              .:.                   ^Y&@@@@@@@@@@@@@J                              
             Y@@@@@@@@@@@@@&!                                      .^!?YY555YYYJJ?7^   ?@@@@@@@@@@@@@                                  
             &@@@@@@@@@@@@5                                    ~5&@@@@@@@@@@@@@@@@@@@:  #@@@@@@@@@@@@7                             
            ^@@@@@@@@@@@@@Y...                              .P@@@@@@@@@@@@@@@@@@@&#P~  ^@@@@@@@@@@@@@B                       
            7@@@@@@@@@@@@@@@@@&#Y:                          ^G@@@@@@@@@@@&BY7^.     .~G@@@@@@@@@@@@@@&                                                                                                  
            J@@@@@@@@@@@@@@@@@@@@@P              ..          :@@@@@@@B?:    .:~?5B&@@@@@@@@@@@@@@@@@@@                                
            J@@@@@@@@@@@@@@@@@@@@@@.             B.         ^@@@@&5^        #@@@@@@@@@@@@@@@@@@@@@@@@@                                
            !@@@@@@@@@@@@@@@@@@@@@@.            :@        :G@@@#~           .@@@@@@@@@@@@@@@@@@@@@@@@&                                 
            .@@@@@@@@@@@@@@@@@@@@@@.            :@:     ~B@@@&^  :P7         G@@@@@@@@@@@@@@@@@@@@@@@G                             
             !@@@@@@@@@@@@@@@@@@@@@#              ~@@@@@@@@!  ~@@@@@@@@P^   .@@@@@@@@@@@@@@@@@@@@@@@&                                  
              #@@@@@@@@@@@@@@@@@@@@@!             ~@@@@@@@5  ^@@@@@@@@@@@@##@@@@@@@@@@@@@@@@@@@@@@@@~                        
              :@@@@@@@@@@@@@@@@@@@@@@.            .@@@@@@@.  #@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@P                                                                                                    
               !@@@@@@@@@@@@@@@@@@@@@&.            G@@@@@@   @@@@@@@&G555PB&@@@@@@@@@@@@@@@@@@@@@@#                                                                                                     
                !@@@@@@@@@@@@@@@@@@@B!             .@@@@@@.  #@@@B!.        :5@@@@@@@@@@@@@@@@@@@G                                                                                                      
                  ?#@@@@@@@@@@@@@@P:                ^@@@@@G  :&P:              7&@@@@@@@@@@@@@&P:                                                                                                       
                    .^75GB####GY~                    .5B###:                     :?PB####BPJ~. 
                    
                       ##################################################################
                       #            Welcome to the CAC offline voter script             #
                       ##################################################################


                                                                                                                    ${NC}"
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
