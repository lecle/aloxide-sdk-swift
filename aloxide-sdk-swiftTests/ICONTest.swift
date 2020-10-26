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
        let iconAccount = BlockchainAccountBuilder()
             .setAddress(address: "hxe7af5fcfd8dfc67530a01a0e403882687528dfcb")
             .setPrivateKey(privateKey: "592eb276d534e2c41a2d9356c0ab262dc233d87e4dd71ce705ec130a8d27ff0c")
             .build()
         
        let iconBuilder = AloxideBuilder.newBuilder()
             .setNetwork(network: Network.ICON)
             .setContract(contract: "cx26d2757d45ea7e559940d86761330005b0e9f2d8")
             .setUrl(url: "https://bicon.net.solidwallet.io/api/v3")
             .setNid(nid: 3)
             .setEntityName(entityName: "Poll")
             .setBlockchainAccount(blockchainAccount: iconAccount)
             .build()
        return iconBuilder
    }
    
    
    func testGet() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")

        aloxide.get(id: "203330") { res in
            switch res{
            case .success(let res):
                self.printSuccess(res)
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testWrite() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")

        aloxide.add(params: ["id":"203330","name":"2010name","body":"2010body"]) { res in
            switch res{
            case .success(let res):
                self.printSuccess("Result: \(res)")
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)

    }
    func printError(_ error: String)  {
        print("\n\n\n\n========================= ERROR HAPPEN =========================\n\n")
        print(error)
        print("\n\n====================================================================\n\n")
    }
    
    func printSuccess(_ res: String)  {
        print("\n\n\n\n========================= YOUR RESULT HERE =========================\n\n")
        print(res)
        print("\n\n====================================================================\n\n")
    }
    
    func testDelete() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")

        aloxide.delete(id: "2020"){ res in
            switch res{
            case .success(let res):
                self.printSuccess("Result: \(res)")
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
    func testUpdate() throws {
        let aloxide = configICON()
        let expectation = self.expectation(description: "wait")

        aloxide.update(id: "203330",params: ["name":"2010name updated","body":"2010body updated"]){ res in
            switch res{
            case .success(let res):
                self.printSuccess("Result: \(res)")
                expectation.fulfill()
            case .failure(let e):
                self.printError("Get data error \(String(describing: e.message))")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 600, handler: nil)
    }
    
}
