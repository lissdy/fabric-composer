CERTIFICATE_PATH=../../fabric-tools/fabric-scripts/hlfv1/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem
PRIVATE_KEY_PATH=../../fabric-tools/fabric-scripts/hlfv1/composer/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/114aab0e76bf0c78308f89efc4b8c9423e31568da0c340ca187a9b17aa9a4457_sk
composer card create -p connection.json -u PeerAdmin -c "${CERTIFICATE_PATH}" -k "${PRIVATE_KEY_PATH}" -r PeerAdmin -r ChannelAdmin

composer card import -f PeerAdmin@fabric-network.card
composer runtime install -c PeerAdmin@fabric-network -n composer-chaincode
composer network start -c PeerAdmin@fabric-network -a ../composer-chaincode@0.0.1.bna -A admin -S adminpw

composer card import -f admin@composer-chaincode.card
composer network ping -c admin@composer-chaincode
