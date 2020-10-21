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
    //    private var serializationProvider: EosioAbieosSerializationProvider?
    //    private var signatureProvider: EosioSoftkeySignatureProvider?
    
    var ee: AloxideExceptions?
    var rr: Bool?
    
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
    
    func add(params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void) {
        let methodName = "cre"+self.entityName
        let isValid = self.validate()
        
        if !isValid {
            ee = AloxideExceptions(code: -1, message: "Invalid")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        self.sendTransaction(methodName: methodName, params: params,completion: completion)
    }
    func update(id: String, params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void) {
        let methodName = "upd"+self.entityName
        let isValid = self.validate()
        if !isValid {
            ee = AloxideExceptions(code: -1, message: "Invalid")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        self.sendTransaction(methodName: methodName, params: params,completion: completion)
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
                                    var ee: AloxideExceptions?
                                    var rr: String?
                                    switch response{
                                    case .success(let res):
                                        if res.rows.count == 0 {
                                            completion(AloxideResult(success:rr , failure:AloxideExceptions(code: -1, message: "Not found"))!)
                                            break
                                        }
                                        
                                        rr = "\(res.rows[0])"
                                        completion(AloxideResult(success:rr , failure:ee)!)
                                        break
                                    case .failure(let e):
                                        ee = AloxideExceptions(code: -1, message: e.description)
                                        completion(AloxideResult(success:rr , failure:ee)!)
                                        break
                                    }
                                 })
    }
    
    func get(id: Any) -> Any? {
        //        guard rpcProvider != nil else {
        //            print("[AloxideSwift::EOS::GetTableRows]::ERROR: No RPCProvider found.")
        //            return nil
        //        }
        
        //        let result = self.rpcProvider!.getTableRows(.promise, requestParameters: EosioRpcTableRowsRequest(
        //                                                        scope: self.account.name!,
        //                                                        code: self.contract,
        //                                                        table: self.entityName,
        //                                                        json: true,
        //                                                        limit: 1,
        //                                                        tableKey: nil,
        //                                                        lowerBound: id as? String,
        //                                                        upperBound: id as? String,
        //                                                        indexPosition: "1",
        //                                                        keyType: nil,
        //                                                        encodeType: .dec,reverse: false, showPayer: false))
        
        //        self.rpcProvider!.getTableRows(requestParameters: EosioRpcTableRowsRequest(
        //                                        scope: self.account.name!,
        //                                        code: self.contract,
        //                                        table: self.entityName,
        //                                        json: true,
        //                                        limit: 1,
        //                                        tableKey: nil,
        //                                        lowerBound: id as? String,
        //                                        upperBound: id as? String,
        //                                        indexPosition: "1",
        //                                        keyType: nil,
        //                                        encodeType: .dec,
        //                                        reverse: false, showPayer: false),
        //                                       completion: { response in
        //                                        switch response{
        //                                        case .failure(let error):
        //                                            print("[AloxideSwift::EOS::GetTableRows]::Error \(error.eosioError)")
        //                                        case .success(let res):
        //                                            print("[AloxideSwift::EOS::GetTableRows]::Success \(res.rows[0])")
        //                                            break
        //                                        }
        //                                       })
        
        return nil
    }
    
    func delete(id: String,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void) {
        let methodName = "del"+self.entityName
        let isValid = self.validate()
        if !isValid {
            ee = AloxideExceptions(code: -1, message: "Invalid")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        self.sendTransaction(methodName: methodName, params: ["id":id],completion: completion)
    }
    
    func sendTransaction(methodName: String, params: Any,completion: @escaping (AloxideResult<Bool, AloxideExceptions>) -> Void) {
        if self.account.name == nil {
            ee = AloxideExceptions(code: -1, message: "Please provide account name!")
            completion(AloxideResult(success:rr , failure:ee)!)
            return
        }
        guard let transactionFactory = transactionFactory else {
            print("ERROR: No transaction factory found.")
            return
        }
        
        // Get a new transaction from our transaction factory.
        let transaction = transactionFactory.newTransaction()
        
        let action = try! EosioTransaction.Action(account: self.account.name!, name: methodName, authorization: [EosioTransaction.Action.Authorization(actor: self.account.name!, permission: "active")], data: params  as! Dictionary<String, Any>)
        
        // Add that action to the transaction.
        transaction.add(action: action)
        
        // Sign and broadcast.
        var eee: AloxideExceptions?
        var rrr: Bool?
        
        transaction.signAndBroadcast { result in
            switch result{
            case .success(let res):
                rrr = res
                completion(AloxideResult(success:rrr , failure:eee)!)
                break
            case .failure(let e):
                eee = AloxideExceptions(code: -1, message: e.reason )
                completion(AloxideResult(success:rrr , failure:eee)!)
                break
            }
        }
    }
}
