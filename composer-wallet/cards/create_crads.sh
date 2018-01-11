CERT1=../../fabric-network/first-network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem
PRIVATE_KEY1=../../fabric-network/first-network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/d3970570fe5a720d528f2b73286ece2154904e383c1fbd264e0ec93225118317_sk

composer card create -p ../connection_profile/connection-org1-only.json -u PeerAdmin -c "${CERT1}" -k "${PRIVATE_KEY1}" -r PeerAdmin -r ChannelAdmin
composer card create -p ../connection_profile/connection-org1.json -u PeerAdmin -c "${CERT1}" -k "${PRIVATE_KEY1}" -r PeerAdmin -r ChannelAdmin

CERT2=../../fabric-network/first-network/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/signcerts/Admin@org2.example.com-cert.pem
PRIVATE_KEY2=../../fabric-network/first-network/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp/keystore/4295cba08b7c09bc5f6df438b0aa2e7b3703541bde8554acefd9cb79b77e9105_sk

composer card create -p ../connection_profile/connection-org2-only.json -u PeerAdmin -c "${CERT2}" -k "${PRIVATE_KEY2}" -r PeerAdmin -r ChannelAdmin
composer card create -p ../connection_profile/connection-org2.json -u PeerAdmin -c "${CERT2}" -k "${PRIVATE_KEY2}" -r PeerAdmin -r ChannelAdmin
