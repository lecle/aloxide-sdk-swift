//
//  ViewController.swift
//  aloxide-sdk-swift
//
//  Created by quoc huynh on 10/19/20.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let blockchainNetworks = ["EOS","ICON"]
    var env: [String: Any]?
    var networkSelected: Int?
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "env", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    env = object
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blockchainNetworks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return blockchainNetworks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Picker selected: \(row)")
        self.loadEnv(row)
    }
    
    @IBAction func onClick(_ sender: Any) {
        print("clicked")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newView = storyboard.instantiateViewController(withIdentifier: "send_transaction_screen") as! SendTransactionViewController
        newView.networkSelected = self.networkSelected
        present(newView, animated: true, completion: nil)
    }
    
    func loadEnv(_ row: Int)  {
        self.networkSelected = row
        guard let env = env else {
            print("ENV configuration not found")
            return
        }
        
        let eos: [String: Any]?
        
        switch row {
        case 0:
            eos = env["eos"] as? [String : Any]
        case 1:
            eos = env["icon"] as? [String : Any]
        default:
            eos = env["eos"] as? [String : Any]
        }
        
        guard let eosValue = eos else {
            print("EOS configuration not found")
            return
        }
        
        edtAccountName.text = eosValue["app_blockchain_account"] as? String
        edtPrivateKey.text = eosValue["app_blockchain_account_pk"] as? String
        edtAddress.text = eosValue["app_blockchain_account"] as? String
        edtUrl.text = eosValue["app_blockchain_url"] as? String
    }
    
    @IBOutlet weak var edtAddress: UITextField!
    @IBOutlet weak var edtPrivateKey: UITextField!
    @IBOutlet weak var edtUrl: UITextField!
    @IBOutlet weak var edtAccountName: UITextField!
    @IBOutlet weak var blockchainNetworkPicker: UIPickerView!
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blockchainNetworkPicker.delegate = self
        
        self.readJson()
        self.loadEnv(0)
        
        // ICONNN
//                let blockchainAccount = BlockchainAccountBuilder()
//                    .setAddress(address: "hxe7af5fcfd8dfc67530a01a0e403882687528dfcb")
//                    .setPrivateKey(privateKey: "592eb276d534e2c41a2d9356c0ab262dc233d87e4dd71ce705ec130a8d27ff0c")
//                    .build()
//
//                _ = AloxideBuilder.newBuilder()
//                    .setNetwork(network: Network.ICON)
//                    .setContract(contract: "cx26d2757d45ea7e559940d86761330005b0e9f2d8")
//                    .setUrl(url: "https://bicon.net.solidwallet.io/api/v3")
//                    .setNid(nid: 3)
//                    .setEntityName(entityName: "Poll")
//                    .setBlockchainAccount(blockchainAccount: blockchainAccount)
//                    .build()
        
        
        let blockchainAccount = BlockchainAccountBuilder()
            .setName(name: "aloxidejs123")
            .setPrivateKey(privateKey: "5JHQ3GuzcQtEQgG3SGvtDU7v2b7ioKznYBizA1V5mBUUsLNcXdQ")
            .build()

        _ = AloxideBuilder.newBuilder()
            .setNetwork(network: Network.EOS)
            .setContract(contract: "aloxidejs123")
            .setUrl(url: "https://testnet.canfoundation.io")
            .setEntityName(entityName: "Poll")
            .setBlockchainAccount(blockchainAccount: blockchainAccount)
            .build()
        
        
        //                poll.get(id: "1") { res in
        //                    switch res{
        //                    case .success(let res):
        //                        print(res)
        //                        break
        //                    case .failure(let e):
        //                        print(e.message)
        //                        break
        //                    }
        //                }
        
        // poll.add(params: ["id":"123232","name":"2010name","body":"2010body"]) { res in
        //     switch res{
        //     case .success(let res):
        //         print(res)
        //         break
        //     case .failure(let e):
        //         print(e.message)
        //         break
        //     }
        // }
        
        //                poll.update(id: "2020",params: ["id":"2020","name":"2010name updated","body":"2010body updated"]) { res in
        //                    switch res{
        //                    case .success(let res):
        //                        print(res)
        //                        break
        //                    case .failure(let e):
        //                        print(e.message)
        //                        break
        //                    }
        //                }
        
        //                poll.delete(id: "2020") { res in
        //                    switch res{
        //                    case .success(let res):
        //                        print(res)
        //                        break
        //                    case .failure(let e):
        //                        print(e.message)
        //                        break
        //                    }
        //                }
    }
}

