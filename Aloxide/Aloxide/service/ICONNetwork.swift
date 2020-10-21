//
//  ICONNetwork.swift
//  Aloxide
//
//  Created by quoc huynh on 10/19/20.
//

import Foundation
import ICONKit
import BigInt

class ICONNetwork: BlockchainNetwork{
    
    private var iconService: ICONService
    private var entityName: String
    private var contract: String?
    private var account: BlockchainAccount
    private var nId: Int = 3
    
    init(entityName: String, account: BlockchainAccount, contract: String, url: String, networkId: Int) {
        self.iconService = ICONService(provider: url, nid: "0x\(networkId)")
        self.account = account
        self.contract = contract //"cx26d2757d45ea7e559940d86761330005b0e9f2d8"
        self.entityName = entityName.lowercased()
        self.nId = networkId
    }
    
    func get(id: Any) throws -> Any {
        let methodName = "get"+self.entityName
        let isValid = self.validate()
        if !isValid {
            throw AloxideExceptions(code: -1, message: "The method name " + methodName + " is not valid!")
        }
        
        let call = Call<String>(from: self.account.privateKey!, to: self.account.address!, method: methodName, params:["id": id])
        
        let request: Request<String> = iconService.call(call)
        
        let response: Result<String, ICError> = request.execute()
        return response.value as Any
    }
    
    func add(params: Any) throws -> Bool {
        let methodName = "cre"+self.entityName
        let isValid = self.validate()
        if !isValid {
            throw AloxideExceptions(code: -1, message: "The method name " + methodName + " is not valid!")
        }
        do{
            _ = try self.sendTransaction(methodName: methodName, params: params as! Dictionary<String, Any>)
            return true
        }
        catch {
            return false
        }
    }
    
    func update(id: String, params: Any) throws -> Bool {
        let methodName = "upd"+self.entityName
        let isValid = self.validate()
        if !isValid {
            throw AloxideExceptions(code: -1, message: "The method name " + methodName + " is not valid!")
        }
        do{
            _ = try self.sendTransaction(methodName: methodName, params: params as! Dictionary<String, Any>)
            
            return true
        }
        catch {
            return false
        }
    }
    
    func delete(id: String) throws -> Bool {
        let methodName = "del"+self.entityName
        let isValid = self.validate()
        if !isValid {
            throw AloxideExceptions(code: -1, message: "The method name " + methodName + " is not valid!")
        }
        do{
            _ = try self.sendTransaction(methodName: methodName, params: ["id": id])
            
            return true
        }
        catch {
            return false
        }
    }
    
    /**
     * Validation in ICON Network like: check the method name exist or not in SCORE,...
     *
     * @return
     */
    func validate() -> Bool {
        return true
    }
    
    func sendTransaction(methodName: String, params: Dictionary<String, Any>) throws-> Any {
        // SCORE function call
        let call = CallTransaction()
            .to(self.account.address!)
            .from(self.account.privateKey!)
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
            return request.execute().value as Any;
        }catch{
            throw AloxideExceptions(code: -1, message: error.localizedDescription)
        }
        
    }
    
}
