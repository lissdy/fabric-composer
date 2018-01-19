# Bringing up a Kafka-based Ordering Service

排序服务需要处理fabirc网络中的所有交易消息，是全网的关键所在。Fabric目前（2018/01）支持两种排序类型：solo和kafka。在生成环境下，Orderer节点需要采用kafka集群进行排序，以提高其可靠性。本文就介绍排序节点基于kafka的配置方式。

我们要配置的网络的拓扑结构与[Building Your First Network](http://hyperledger-fabric.readthedocs.io/en/release/build_network.html)相同，即一个通道，两个组织，每个组织下两个peer节点，每个组织中的第一个节点（peer0）作为锚节点与其他组织进行通信。不同之处在于BYFN的排序类型是solo，仅有一个排序节点。而我们要在kafka基础上配置多个排序节点，以便在生成环境使用。

下面就分步骤说明这样一下fabric网络的配置和启动过程：

> 1,2步中列出的命令只是为了说明其用途，可以不执行，项目中有脚本统一执行！

1. 使用[cryptogen](https://www.jianshu.com/p/aaf971761f5d)工具+crypto-config.yaml配置文件生成组织关系和身份证书
```
# crypto-config.yaml
OrdererOrgs: # 组织类型OrdererOrgs
  - Name: Orderer #组织名称
    Domain: example.com
    Specs:
      - Hostname: orderer0
      - Hostname: orderer1
PeerOrgs: # 组织类型PeerOrgs
  - Name: Org1
    Domain: org1.example.com
    Template:
      Count: 2
    Users:
      Count: 1
  - Name: Org2
    Domain: org2.example.com
    Template:
      Count: 2
    Users:
      Count: 1
```
```
//生成指定拓扑结构的组织和身份文件，保存在cryto-config目录下
cryptogen generate --config=./crypto-config.yaml
```
2. 使用configtxgen生成通道配置信息
configtxgen工具集合[cryptogen](https://www.jianshu.com/p/aaf971761f5d)生成的组织结构身份文件，来实现以下三个功能：
- 生成启动Orderer需要的初始区块，并支持检查区块内容
- 生成创建应用通道需要的配置交易，并支持检查交易内容
- 生成锚节点Peer的更新配置交易

**configtx.yaml**
```
Profiles:
    TwoOrgsOrdererGenesis: # orderer系统通道模版
        Orderer: # 指定orderer系统通道自身的配置信息
            <<: *OrdererDefaults
            Organizations: # 参与到此orderer的组织信息
                - *OrdererOrg
        Consortiums: # orderer所服务的联盟列表
            SampleConsortium:
                Organizations:
                    - *Org1
                    - *Org2
    TwoOrgsChannel: # 应用通道模版
        Consortium: SampleConsortium #该应用通道所关联联盟的名称
        Application: #指定属于某应用通道的信息
            <<: *ApplicationDefaults
            Organizations:
                - *Org1
                - *Org2

Organizations:
    - &OrdererOrg
        Name: OrdererOrg

        # ID to load the MSP definition as
        ID: OrdererMSP
        MSPDir: crypto-config/ordererOrganizations/example.com/msp

    - &Org1
        Name: Org1MSP

        # ID to load the MSP definition as
        ID: Org1MSP

        MSPDir: crypto-config/peerOrganizations/org1.example.com/msp

        AnchorPeers:
            - Host: peer0.org1.example.com
              Port: 7051

    - &Org2
        Name: Org2MSP
        # ID to load the MSP definition as
        ID: Org2MSP

        MSPDir: crypto-config/peerOrganizations/org2.example.com/msp

        AnchorPeers:
            - Host: peer0.org2.example.com
              Port: 7051

Orderer: &OrdererDefaults
    OrdererType: kafka

    Addresses:
        - orderer0.example.com:7050
        - orderer1.example.com:7050
    BatchTimeout: 2s
    BatchSize:
        MaxMessageCount: 10
        AbsoluteMaxBytes: 99 MB
        PreferredMaxBytes: 512 KB

    Kafka:
        # 配置kafka集群信息
        Brokers:
            - kafka0:9092
            - kafka1:9092
            - kafka2:9092
            - kafka3:9092

    Organizations:

Application: &ApplicationDefaults
    Organizations:
```

**生成初始区块**
根据上述配置文件configtx.yaml的内容，通过如下命令指定TwoOrgsOrdererGenesis profile生成orderer通道的初始区块文件
```
configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block
```

**生成创建应用通道需要的配置交易**
```
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
```

**生成锚节点Peer的更新配置交易**
```
# 使用-asOrg来指定组织身份
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP

configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
```

3. 编写docker-compose配置文件
分别配置3个zookeeper和4个kafka实例来支持orderer集群，详细的配置参数参见官方文档：[Bringing up a Kafka-based Ordering Service](https://hyperledger-fabric.readthedocs.io/en/latest/kafka.html)，这里配置信息较多，不便列出。github源码地址：[docker-compose-cli.yaml](https://github.com/lissdy/fabric-composer/blob/master/fabric-network/kafka-orderers/docker-compose-cli.yaml),[docker-compose-base.yaml](https://github.com/lissdy/fabric-composer/blob/master/fabric-network/kafka-orderers/base/docker-compose-base.yaml)

4. 启动网络
在项目目录下执行如下命令：
```
./byfn.sh -m generate
./byfn.sh -m up
```
生成以下容器
![kafka-based network](http://upload-images.jianshu.io/upload_images/4269060-80302f5e93f5aff9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

5. 测试网络
第4步中我们已经运行了所有容器，接下来登陆cli，执行脚本来测试网络（脚本内容包括创建通道，加入通道，更新锚点，初始化链码和调用链码等操作）
```
# 登陆cli
docker exec -it cli bash
```
```
# 在cli容器内执行脚本
/bin/bash -c './scripts/script.sh mychannel'
```

运行结果如下
![result](http://upload-images.jianshu.io/upload_images/4269060-7cd109470af1e011.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

调用链码进行查询，可以看到查询结果为90
```
peer chaincode query -C mychannel -n mycc -c '{"Args":["query","a"]}'
>>> Query Result: 90
```
![调用链码进行查询](http://upload-images.jianshu.io/upload_images/4269060-d068db1846c4917e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以上就是配置orderer节点集群的方式，在集群环境下，客户端将交易发送到任何一个排序节点都可以。
