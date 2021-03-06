#!/usr/bin/env bash
#
# Renders a network faucet account balance.
# Globals:
#   NCTL - path to nctl home directory.
# Arguments:
#   Network ordinal identifier.

# Import utils.
source $NCTL/sh/utils/misc.sh
source $NCTL/sh/utils/queries.sh

#######################################
# Destructure input args.
#######################################

# Unset to avoid parameter collisions.
unset net
unset node

for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)
    case "$KEY" in
        net) net=${VALUE} ;;
        node) node=${VALUE} ;;
        *)
    esac
done

# Set defaults.
net=${net:-1}
node=${node:-1}

#######################################
# Main
#######################################

state_root_hash=$(get_state_root_hash $net $node)
account_key=$(cat $NCTL/assets/net-$net/faucet/public_key_hex)
purse_uref=$(get_main_purse_uref $net $state_root_hash $account_key)
source $NCTL/sh/views/view_chain_account_balance.sh net=$net node=$node \
    root-hash=$state_root_hash \
    purse-uref=$purse_uref \
    typeof="faucet"
