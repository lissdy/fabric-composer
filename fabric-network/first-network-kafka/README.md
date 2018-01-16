# Build Your First Network (BYFN)

The directions for using this are documented in the Hyperledger Fabric ["Build Your First Network"](http://hyperledger-fabric.readthedocs.io/en/latest/build_network.html) tutorial.

```
# -profile 从configtx.yaml中查找到指定的profile来生成配置
# -outputBlock 将初始区块写入指定文件
configtxgen -profile TwoOrgsOrderersGenesis -outputBlock ./channel-artifacts/genesis.block
configtxgen -profile TwoOrgsOrderersGenesis -inspectBlock ./channel-artifacts/genesis.block
```
