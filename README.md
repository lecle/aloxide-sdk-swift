## ICON initialization
  ```swift
let blockchainAccount = BlockchainAccountBuilder()
                              .setAddress(address: "hxe7af5fcfd8dfc67530a01a0e403882687528dfcb")
                              .setPrivateKey(privateKey: "592eb276d534e2c41a2d9356c0ab262dc233d87e4dd71ce705ec130a8d27ff0c")
                              .build()
let poll = AloxideBuilder.newBuilder().setNetwork(network: Network.ICON)
                             .setContract(contract: "cx26d2757d45ea7e559940d86761330005b0e9f2d8")
                             .setUrl(url: "https://bicon.net.solidwallet.io/api/v3")
                             .setNid(nid: 3)
                             .setEntityName(entityName: "Poll")
                             .setBlockchainAccount(blockchainAccount: blockchainAccount)
                             .build()
```
### EOS initialization
```swift
let blockchainAccount = BlockchainAccountBuilder()
            .setName(name: "aloxidejs123")
            .setPrivateKey(privateKey: "5JHQ3GuzcQtEQgG3SGvtDU7v2b7ioKznYBizA1V5mBUUsLNcXdQ")
            .build()
        
let poll = AloxideBuilder.newBuilder()
            .setNetwork(network: Network.EOS)
            .setContract(contract: "aloxidejs123")
            .setUrl(url: "https://testnet.canfoundation.io")
            .setEntityName(entityName: "Poll")
            .setBlockchainAccount(blockchainAccount: blockchainAccount)
            .build()
 ```

## Usage
 To add, by run:
```swift
poll.add(params: ["id":"2020","name":"2010name","body":"2010body","user":"aloxidejs123"]) { res in
            switch res{
            case .success(let res):
                print(res)
                break
            case .failure(let e):
                print(e.message)
                break
            }
        }
```
To get, by run:

```swift
poll.get(id: "1") { res in
                    switch res{
                    case .success(let res):
                        print(res)
                        break
                    case .failure(let e):
                        print(e.message)
                        break
                    }
                }
```

To update, by run:
 ```swift
poll.update(id: "2010",params: ["id":"2010","name":"2010name updated","body":"2010body updated"]) { res in
                    switch res{
                    case .success(let res):
                        print(res)
                        break
                    case .failure(let e):
                        print(e.message)
                        break
                    }
                }
  ```

To delete, by run:
```swift
 poll.delete(id: "2010") { res in
     switch res{
     case .success(let res):
         print(res)
         break
     case .failure(let e):
         print(e.message)
         break
     }
 }
 ```

        
        
