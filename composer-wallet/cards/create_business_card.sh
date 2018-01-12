composer card create -p ../connection_profile/connection-org1.json -u alice -n composer-chaincode -c ../alice/admin-pub.pem -k ../alice/admin-priv.pem
composer card import -f alice@composer-chaincode.card
composer network ping -c alice@composer-chaincode

composer card create -p ../connection_profile/connection-org2.json -u bob -n composer-chaincode -c ../bob/admin-pub.pem -k ../bob/admin-priv.pem
composer card import -f bob@composer-chaincode.card
composer network ping -c bob@composer-chaincode
