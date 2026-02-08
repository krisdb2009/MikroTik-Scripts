/tool netwatch
add comment=PEERNAMEGOESHERE disabled=no down-script="" host=PEERIPGOESHERE \
    http-codes="" interval=10s test-script=":global NAME \$comment\r\
    \n\r\
    \n:global INT [/interface/wireguard/peers/find interface=\$NAME]\r\
    \n:put \$INT\r\
    \n\r\
    \nif condition=(\$status = \"down\") do={\r\
    \n    /interface/wireguard/peers/disable \$INT\r\
    \n    :delay 1\r\
    \n    /interface/wireguard/peers/enable \$INT\r\
    \n}" type=simple up-script=""
