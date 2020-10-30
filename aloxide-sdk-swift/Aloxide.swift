//
//  Aloxide.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
protocol AloxideMethodDelegate {
    func get(id: Any)  -> Any?
    func add(params: [String : Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)
    func update(id: String, params: [String : Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)
    func delete(id: String,completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)
    func get(id: Any, completion:@escaping (AloxideResult<String, AloxideExceptions>) -> Void)

}

class Aloxide : AloxideMethodDelegate{
    
    var aloxideData: AloxideData?
    var blockchainNetwork: BlockchainNetwork?
    
    func get(id: Any, completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        return blockchainNetwork!.get(id: id, completion:completion)
    }
    
    func get(id: Any)  -> Any? {
        return blockchainNetwork!.get(id: id)
    }
    
    func add(params: [String : Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        return blockchainNetwork!.add(params: params,completion: completion)
    }
    
    func update(id: String, params: [String : Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)  {
        return blockchainNetwork!.update(id: id,params: params,completion: completion)
    }
    
    func delete(id: String,completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        return blockchainNetwork!.delete(id: id,completion: completion)
    }
}


class AloxideData{
    var network: Network?
    var blockchainAccount: BlockchainAccount?
    var contract: String?
    var entityName: String?
    var url: String?
    var nId = 3 // MainNet = 1, TestNet = 3 (Use for ICON Network)
}

class AloxideBuilder{
    
    private var aloxideData: AloxideData
    
    private init(){
        aloxideData = AloxideData()
    }

    static func newBuilder() -> AloxideBuilder{
        return AloxideBuilder()
    }
    
    func setNetwork(network: Network) -> AloxideNetworkBuilder{
        self.aloxideData.network = network
        return AloxideNetworkBuilder(aloxideData)
    }
}

class AloxideNetworkBuilder{
    private final var aloxideData: AloxideData
    
    init(_ aloxideData: AloxideData) {
        self.aloxideData = aloxideData
    }
    
    func setBlockchainAccount(blockchainAccount: BlockchainAccount) -> AloxideNetworkBuilder {
        self.aloxideData.blockchainAccount = blockchainAccount
        return AloxideNetworkBuilder(aloxideData)
    }
    
    func setContract(contract: String) -> AloxideNetworkBuilder {
        self.aloxideData.contract = contract
        return AloxideNetworkBuilder(aloxideData)
    }
    
    func setEntityName(entityName: String) -> AloxideNetworkBuilder {
        self.aloxideData.entityName = entityName
        return AloxideNetworkBuilder(aloxideData)
    }
    
    func setUrl(url: String) -> AloxideNetworkBuilder {
        self.aloxideData.url = url
        return AloxideNetworkBuilder(aloxideData)
    }
    
    func setNid(nid: Int) -> AloxideNetworkBuilder {
        self.aloxideData.nId = nid
        return AloxideNetworkBuilder(aloxideData)
    }
    
    func build() -> Aloxide {
        let aloxide =  Aloxide();
        aloxide.aloxideData = self.aloxideData;
        switch self.aloxideData.network {
        case .EOS:
            aloxide.blockchainNetwork = EOSNetwork(
                entityName: aloxideData.entityName!,
                contract: aloxideData.contract!,
                url: aloxideData.url!,
                account: aloxideData.blockchainAccount!)
            return aloxide
        case .ICON:
            aloxide.blockchainNetwork = ICONNetwork(
                entityName: aloxideData.entityName!,
                account: aloxideData.blockchainAccount!,
                contract: aloxideData.contract!,
                url: aloxideData.url!,
                networkId: aloxideData.nId)
            return aloxide
        default: break
        }
        return aloxide
    }
    
}
