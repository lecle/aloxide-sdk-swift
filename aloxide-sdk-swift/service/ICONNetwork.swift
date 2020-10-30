//
//  ICONNetwork.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
import ICONKit
import BigInt

class ICONNetwork: BlockchainNetwork{
    
    private var iconService: ICONService
    private var entityName: String
    private var contract: String
    private var account: BlockchainAccount
    private var nId: Int = 3
    
    init(entityName: String, account: BlockchainAccount, contract: String, url: String, networkId: Int) {
        self.iconService = ICONService(provider: url, nid: "0x\(networkId)")
        self.account = account
        self.contract = contract
        self.entityName = entityName.lowercased()
        self.nId = networkId
        self.getScore()
    }
    
    func getScore() {
        let request: Request<[Response.ScoreAPI]> = iconService.getScoreAPI(scoreAddress: self.contract)
        
        let response = request.execute()
        
        switch response {
        case .success(let res):
//            var output: [Field] = []
//            
//            for i in 0..<res.count {
//                let scoreApi = res[i]
//                let actionName = scoreApi.name
//                
//                let inputs = scoreApi.inputs as! [[String: String]]
//                
//                var fieldDetails: [FieldDetail] = []
//                for j in 0..<inputs.count{
//                    let fd = FieldDetail(name: inputs[j]["name"]!, type: inputs[j]["type"]!)
//                    fieldDetails.append(fd)
//                }
//                output.append(Field(name: actionName, fields: fieldDetails))
//                
//            }
//            print("ICON get score api: \(output)")
            break
        case .failure(let error):
            print("getScore failed \(String(describing: error.failureReason))")
            break
        }
    }
    
    func get(id: Any, completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        let methodName = "get"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message:"Invalid when get record")))
        }
        
        let call = Call<[String:String]>(from: self.account.address!, to: self.contract, method: methodName, params: ["id": id])
        
        let request: Request<[String:String]> = iconService.call(call)
        let response: Result<[String:String], ICError> = request.execute()
        
        switch response {
        case .success(let res):
            if (res.isEmpty) {
                completion(.failure(AloxideExceptions(code: -1, message: "Not found")))
                break
            }
            completion(.success(res.toString()!))
            break
        case .failure(let error):
            completion(.failure(AloxideExceptions(code: -1, message: error.localizedDescription)))
            break
        }
    }
    
    func get(id: Any) -> Any? {
        let methodName = "get"+self.entityName
        let isValid = self.validate()
        if !isValid {
            return nil
        }
        
        let call = Call<String>(from: self.account.address!, to: self.contract, method: methodName, params: ["id": id])
        
        let request: Request<String> = iconService.call(call)
        let response: Result<String, ICError> = request.execute()
        switch response {
        case .success(let res):
            return res
            
        case .failure(let error):
            print("[AloxideSwift::ICON::GetRecord]::ERROR: \(String(describing: error.failureReason))")
            return nil
        }
    }
    
    func add(params: [String: Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)  {
        let methodName = "cre"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message: "Invalid")))
            return
        }
        self.sendTransaction(methodName: methodName, params: params,completion: completion)
    }
    
    func update(id: String, params:[String: Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)  {
        let methodName = "upd"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message: "Invalid")))
            return
        }
        var data = ["id":id]
        params.forEach { (k,v) in data[k] = v as? String }
        self.sendTransaction(methodName: methodName, params: data ,completion: completion)
    }
    
    func delete(id: String,completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void)  {
        let methodName = "del"+self.entityName
        let isValid = self.validate()
        if !isValid {
            completion(.failure(AloxideExceptions(code: -1, message: "Invalid")))
            return
        }
        self.sendTransaction(methodName: methodName, params: ["id": id],completion: completion)
    }
    
    /**
     * Validation in ICON Network like: check the method name exist or not in SCORE,...
     *
     * @return
     */
    func validate() -> Bool {
        return true
    }
    
    func sendTransaction(methodName: String, params: [String: Any],completion: @escaping (AloxideResult<String, AloxideExceptions>) -> Void) {
        
        if self.account.privateKey == nil {
            completion(.failure(AloxideExceptions(code: -1, message: "Please provide the private key")))
            return
        }
        
        // SCORE function call
        let call = CallTransaction()
            .to(self.contract)
            .from(self.account.address!)
            .stepLimit(BigUInt(1000000))
            .nid(self.iconService.nid)
            .nonce("0x1")
            .method(methodName)
            .params(params)
        do{
            let privateKey = PrivateKey(hex: Data(hexString: self.account.privateKey!)!)
            
            let signed = try SignedTransaction(
                transaction: call, privateKey:privateKey)
            let request = iconService.sendTransaction(signedTransaction: signed)
            let result = request.execute()
            
            switch result {
            case .success( let res):
                completion(.success(res))
            case .failure( let e):
                print("[AloxideSwift::ICON::SendTransaction]::ERROR: \(String(describing: e.errorDescription))")
                completion(.failure(AloxideExceptions(code: -1, message: "Error: \(String(describing: e.errorDescription))")))
            }
        }catch{
            print("[AloxideSwift::ICON::SendTransaction]::ERROR: \(String(describing: error.localizedDescription))")
            completion(.failure(AloxideExceptions(code: -1, message: error.localizedDescription)))
        }
    }
}
