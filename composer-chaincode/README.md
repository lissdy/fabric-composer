# org.lisa.hyperledger

PeerAdmin 负责将网络（链码）部署到节点

部署之后 NetworkAdmin 负责管理网络

部署步骤：
1. 将网络（链码）安装到节点
```
# 使用节点管理员卡片PeerAdmin@hlfv1将网络composer-chaincode安装到卡片所辖的节点下
composer runtime install --card PeerAdmin@hlfv1 --businessNetworkName composer-chaincode
```
2. 将网络（链码）归档文件发送到节点
```
# 使用节点管理员卡片PeerAdmin@hlfv1，网络管理员的身份信息以及归档文件生成网络管理员卡片
composer network start --card PeerAdmin@hlfv1 --networkAdmin admin --networkAdminEnrollSecret adminpw --archiveFile composer-chaincode@0.0.1.bna --file networkadmin.card
```
3. 引入网络管理员卡片
```
composer card import --file networkadmin.card
```
