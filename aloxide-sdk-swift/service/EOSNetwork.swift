//
//  EOSNetwork.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//


import Foundation
import EosioSwift
import EosioSwiftAbieosSerializationProvider
import EosioSwiftSoftkeySignatureProvider
import PromiseKit

class EOSNetwork: BlockchainNetwork{
    
    private var entityName: String
    private var contract: String
    private var url: String
    private var account: BlockchainAccount
    
    private var transactionFactory: EosioTransactionFactory?
    private var rpcProvider: EosioRpcProvider?
    
    init(entityName: String, contract: String, url: String, account: BlockchainAccount) {
        self.entityName = entityName.lowercased()
        self.contract = contract
        self.url = url
        self.account = account
        rpcProvider = EosioRpcProvider(endpoint: URL(string: self.url)!)
        guard let rpcProvider = rpcProvider else {
            print("ERROR: No RPC provider found.")
            return
        }
        let serializationProvider = EosioAbieosSerializationProvider()
        let signatureProvider = try! EosioSoftkeySignatureProvider(privateKeys: [self.account.privateKey!])
        transactionFactory = EosioTransactionFactory(
            rpcProvider: rpcProvider,
            signatureProvider: signatureProvider,
            serializationProvider: serializationProvider
        )
        self.getActions()
    }
    
    
    func getActions()  {
        let rpcProvider = EosioRpcProvider(endpoint: URL(string: self.url)!)
        rpcProvider.getAbi(requestParameters: EosioRpcAbiRequest(accountName: self.account.name!)) { (result) in
            switch result{
            case .failure(let error):
                print("getAbi error \(String(describing: error.failureReason))")
                break
            case .success(let res):
//                let output: [Field]?
//                
//                let structs = res.abi["structs"] as! [Any]
//                for i in 0..<structs.count {
//                    let mStruct = structs[i] as! [String: Any]
//                    
//                }
                break
            }
        }
    }
    
    func initSetting() throws -> Void {}
    /**
     * Validation in EOS Network with the condition below:
     * - check the method name exist or not in ABI,...
     * - check non-null input: private key, account name, method is lower case
     * @return
     */
    func validate() -> Bool {
        return true
    }
    
    func add(params: [String: Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        let methodName = "cre"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message: "Invalid")))
            return
        }
        self.sendTransaction(methodName: methodName, params: params,completion: completion)
    }
    
    func update(id: String, params: [String: Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        let methodName = "upd"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message: "Invalid")))
            return
        }
        var data = ["id":id]
        params.forEach { (k,v) in data[k] = v as? String }
        self.sendTransaction(methodName: methodName, params: data,completion: completion)
    }
    
    /**
     Get table rows with completion
     */
    func get(id: Any, completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        let rpcProvider = EosioRpcProvider(endpoint: URL(string: self.url)!)
        rpcProvider.getTableRows(requestParameters: EosioRpcTableRowsRequest(
                                    scope: self.account.name!,
                                    code: self.contract,
                                    table: self.entityName,
                                    json: true,
                                    limit: 1,
                                    tableKey: nil,
                                    lowerBound: id as? String,
                                    upperBound: id as? String,
                                    indexPosition: "1",
                                    keyType: nil,
                                    encodeType: .dec,
                                    reverse: false, showPayer: false),
                                 completion: { response in
                                    switch response{
                                    case .success(let res):
                                        if res.rows.count == 0 {
                                            completion(.failure(AloxideExceptions(code: -1, message: "Not found")))
                                            break
                                        }
                                        completion(.success("\(res.rows[0])"))
                                        break
                                    case .failure(let e):
                                        completion(.failure(AloxideExceptions(code: -1, message: e.description)))
                                        break
                                    }
                                 })
    }
    
    func get(id: Any) -> Any? {
        return nil
    }
    
    func delete(id: String,completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        let methodName = "del"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message: "Invalid")))
            return
        }
        self.sendTransaction(methodName: methodName, params: ["id":id],completion: completion)
    }
    
    func sendTransaction(methodName: String, params: [String: Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        
        if self.account.name == nil {
            completion(.failure(AloxideExceptions(code: -1, message: "Please provide account name!")))
            return
        }
        
        guard let transactionFactory = transactionFactory else {
            completion(.failure(AloxideExceptions(code: -1, message: "No transaction factory found.")))
            return
        }
        
        // Get a new transaction from transaction factory.
        let transaction = transactionFactory.newTransaction()
        
        // Because EOS Network, the smart contract need the field `user`: `account_name`
        
        var data = ["user": self.account.name]
        params.forEach { (k,v) in data[k] = v as? String }
        
        do{
            // Set up our transfer action.
            let action = try EosioTransaction.Action(
                account: self.account.name!,
                name: methodName,
                authorization: [EosioTransaction.Action.Authorization(
                    actor: self.account.name!,
                    permission: "active"
                )],data:data)
            
            // Add that action to the transaction.
            transaction.add(action: action)
            
            // Sign and broadcast.
            transaction.signAndBroadcast { result in
                // Handle our result, success or failure, appropriately.
                print(try! transaction.toJson(prettyPrinted: true))
                switch result {
                case .failure (let e):
                    completion(.failure(AloxideExceptions(code: -1, message: e.reason )))
                case .success:
                    if let transactionId = transaction.transactionId {
                        completion(.success(transactionId))
                    }
                }
            }
        }
        catch{
            completion(.failure(AloxideExceptions(code: -1, message: error.localizedDescription )))
        }
    }
}
