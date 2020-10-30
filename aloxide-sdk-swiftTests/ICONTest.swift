//
//  ICONTest.swift
//  aloxide-sdk-swiftTests
//
//  Created by quoc huynh on 10/26/20.
//

import XCTest
@testable import aloxide_sdk_swift

class ICONTest: XCTestCase {
    
    func configICON() -> Aloxide {
        
        let env : [String: Any] = [ /* CHANGE THIS CONFIG*/
            "app_blockchain_name":"ICON Testnet",
            "app_blockchain_type":"icon",
            "app_blockchain_host":"https://bicon.tracker.solidwallet.io",
            "app_blockchain_url":"https://bicon.net.solidwallet.io/api/v3",
            "app_blockchain_chainId":"353c0a7c6744e58778a2a334d1da2303eb12a111cc636bb494e63a84c9e7ffeb",
            "app_blockchain_account":"hxe7af5fcfd8dfc67530a01a0e403882687528dfcb",
            "app_blockchain_account_pk":"592eb276d534e2c41a2d9356c0ab262dc233d87e4dd71ce705ec130a8d27ff0c",
            "app_blockchain_contract":"cx26d2757d45ea7e559940d86761330005b0e9f2d8"
        ]
        
        let privateKey = env["app_blockchain_account_pk"] as! String
        let address = env["app_blockchain_account"] as! String
        let url = env["app_blockchain_url"] as! String
        let contract = env["app_blockchain_contract"] as! String
        
        let iconAccount = BlockchainAccountBuilder()
            .setAddress(address: address)
            .setPrivateKey(privateKey: privateKey)
            .build()
        
        let iconBuilder = AloxideBuilder.newBuilder()
            .setNetwork(network: Network.ICON)
            .setContract(contract: contract)
            .setUrl(url: url)
            .setNid(nid: 3)
            .setEntityName(entityName: "Poll")
            .setBlockchainAccount(blockchainAccount: iconAccount)
            .build()
        return iconBuilder
    }
    
    
    func testGet() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")
        
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.get(id: id) { res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testWrite() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")
        let data = ["id":"1235" /* NEED TO CHANGE */
                    ,"name":"2010name" /* NEED TO CHANGE */
                    ,"body":"2010body"] /* NEED TO CHANGE */
        
        aloxide.add(params: data) { res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.ICON, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
        
    }
    
    func testDelete() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")
        
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.delete(id: id){ res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.ICON, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testUpdate() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")
        
        let data = ["name":"2010name Updated" /* NEED TO CHANGE */
                    ,"body":"2010body Updated"] /* NEED TO CHANGE */
        let id = "2020" /* NEED TO CHANGE */
        
        aloxide.update(id: id,params: data){ res in
            switch res{
            case .success(let res):
                AloxideLogger.printSuccess(["Result: \(res)","To verify: \(AloxideLogger.getTransactionUrl(res, Network.ICON, (aloxide.aloxideData?.url)!))"])
                expectation.fulfill()
            case .failure(let e):
                AloxideLogger.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
}
