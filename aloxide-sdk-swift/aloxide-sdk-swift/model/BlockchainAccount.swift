//
//  BlockchainAccount.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
class BlockchainAccount{
    public var privateKey: String?
    public var name :String?
    public var address: String?
}

protocol BlockchainAccountProtocol {
    func build() -> BlockchainAccount
    func setPrivateKey(privateKey: String)-> BlockchainAccountBuilder
    func setName(name: String)-> BlockchainAccountBuilder
    func setAddress(address: String)-> BlockchainAccountBuilder
}


class BlockchainAccountBuilder: BlockchainAccountProtocol{
    var blockchainAccount : BlockchainAccount
    
    init() {
        self.blockchainAccount = BlockchainAccount()
    }
    
    func build() -> BlockchainAccount {
        return self.blockchainAccount
    }
    
    func setPrivateKey(privateKey: String) -> BlockchainAccountBuilder {
        self.blockchainAccount.privateKey = privateKey
        return self
    }
    
    func setName(name: String) -> BlockchainAccountBuilder {
        self.blockchainAccount.name = name
        return self
    }
    
    func setAddress(address: String) -> BlockchainAccountBuilder {
        self.blockchainAccount.address = address
        return self
    }
}
