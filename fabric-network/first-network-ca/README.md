1. 启动一个包含了2个CA服务簇的CA server
```
fabric-ca-server start -b admin:adminpw --cacount 2
```

2. 通过openssl命令查看证书内容
```
openssl x509 -in ca-cert.pem -inform pem -noout -text
```
```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            13:35:4d:ee:ef:e1:82:1a:49:e5:9a:17:09:eb:b2:ad:2c:e8:4e:d0
    Signature Algorithm: ecdsa-with-SHA256
        Issuer: C=US, ST=North Carolina, O=Hyperledger, OU=Fabric, CN=fabric-ca-server-ca1
        Validity
            Not Before: Feb  7 07:14:00 2018 GMT
            Not After : Feb  3 07:14:00 2033 GMT
        Subject: C=US, ST=North Carolina, O=Hyperledger, OU=Fabric, CN=fabric-ca-server-ca1
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:93:65:8a:7c:0c:77:fe:63:7f:4e:15:1b:8c:19:
                    3d:38:74:bb:61:a6:50:d6:e2:e1:f2:eb:cd:a2:80:
                    03:e6:cf:05:52:80:e2:70:62:0b:9d:74:7c:4a:6f:
                    6e:e5:20:7a:07:26:7c:77:34:45:8f:b0:82:36:5c:
                    d7:5f:d3:97:0e
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE, pathlen:1
            X509v3 Subject Key Identifier:
                F2:C3:EA:07:DC:1D:D6:E3:67:D7:23:C3:3D:DE:56:8B:1C:10:BE:D2
    Signature Algorithm: ecdsa-with-SHA256
         30:45:02:21:00:f1:0c:c3:56:ac:d1:f9:52:68:9e:db:3c:6a:
         ff:db:73:84:41:2d:13:d6:88:46:0a:11:56:3f:48:0c:6f:51:
         62:02:20:0b:5d:c9:75:d9:7c:0d:6f:e1:80:bc:ef:0f:e7:2c:
         24:17:14:b7:c0:57:eb:3b:f2:f9:ad:19:54:1f:ad:f2:dc
```
数字证书包含了签名算法信息、申请者基本信息、申请者公钥信息等。

3. 注册引导节点
```
fabric-ca-client enroll -u http://admin:adminpw@localhost:7054
```
```
2018/02/07 16:36:04 [INFO] User provided config file: /Users/lli571/fabric-ca/clients/admin/fabric-ca-client-config.yaml
2018/02/07 16:36:04 [INFO] generating key: &{A:ecdsa S:256}
2018/02/07 16:36:04 [INFO] encoded CSR
2018/02/07 16:36:05 [INFO] Stored client certificate at /Users/lli571/fabric-ca/clients/admin/msp/signcerts/cert.pem
2018/02/07 16:36:05 [INFO] Stored CA root certificate at /Users/lli571/fabric-ca/clients/admin/msp/cacerts/localhost-7054.pem
```
server端收到的登记请求
```
2018/02/07 16:36:05 [INFO] 127.0.0.1:52646 - "POST /enroll" 200
```

在ca-client目录下生成的目录结构如下
```
clients
└── admin
    ├── fabric-ca-client-config.yaml
    └── msp
        ├── cacerts
        │   └── localhost-7054.pem
        ├── keystore
        │   ├── 69c1b9af43c3be39a27607834c82ffda1d83eae448da20b28fef692beb132cd6_sk
        │   ├── 76be290c8d0eac97b56625afb4ccf6547b21efb02d7bba91ee49fe0c5707094b_sk
        │   ├── 7be86e0a19a39890f6b8ac6c5a67bf5191f621a73e8c6d03a75f0aa8a80ab18a_sk
        │   ├── af503365799e4251ae54ade8c9664c59d5b2ae69d8e3ca980b77e95cd761f140_sk
        │   ├── b3a2a778724f2034d2c681077760d719270db938eb086584ad7771f5f5bf689e_sk
        │   └── c81cf2f9500669af7d83df3bb99220e663a799bd60b038427585b9bf60c2ecb8_sk
        └── signcerts
            └── cert.pem

5 directories, 9 files
```
