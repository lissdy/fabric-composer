# Build Your First Network (BYFN)

The directions for using this are documented in the Hyperledger Fabric ["Build Your First Network"](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html) tutorial.

1. 生成启动orderer需要的初始区块，并支持检查区块内容
```
# -profile 从configtx.yaml中查找到指定的profile来生成配置
# -outputBlock 将初始区块写入指定文件
configtxgen -profile TwoOrgsOrderersGenesis -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsOrderersGenesis -inspectBlock ./channel-artifacts/genesis.block
```

2. 生成新建通道交易文件并进行查看
```
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID mychannel
configtxgen -profile TwoOrgsChannel -inspectChannelCreateTx ./channel-artifacts/channel.tx

```
3. 生成锚节点更新交易文件
```
# 注意使用-asOrg来指定组织身份
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID mychannel -asOrg Org2MSP
```