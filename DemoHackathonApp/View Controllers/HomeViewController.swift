//
//  ViewController.swift
//  DemoHackathonApp
//
//  Created by Aarish Khanna on 27/02/23.
//

import UIKit
import Flow
import FCL

struct Constants {
    static let screenSize: CGRect = UIScreen.main.bounds
}

class ViewController: UIViewController {
    
    static var nfts: [NFTModel] = []
    
    private let verifyNFTButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Login with NFT", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(verifyNFT), for: .touchUpInside)
        button.alpha = 0.0

        return button
    }()
    
    private let connectAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Connect Account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(connectClicked), for: .touchUpInside)
        return button
    }()
    
    func setupConfig(){
        let defaultProvider: FCL.Provider = .dapperSC
        let defaultNetwork: Flow.ChainID = .testnet
        let accountProof = FCL.Metadata.AccountProofConfig(appIdentifier: "GrowthBook NFT")
        let walletConnect = FCL.Metadata.WalletConnectConfig(urlScheme: "growth-book://", projectID: "062269793d743908f23bc4f0d986078f")
        let metadata = FCL.Metadata(appName: "GrowthBook NFT",
                                    appDescription: "An all in one smart parenting solution",
                                    appIcon: URL(string: "https://i.imgur.com/jscDmDe.png")!,
                                    location: URL(string: "https://monster-maker.vercel.app/")!,
                                    accountProof: accountProof,
                                    walletConnectConfig: walletConnect)
        fcl.config(metadata: metadata,
                   env: defaultNetwork,
                   provider: defaultProvider)
        
    }

    @objc func connectClicked(){
        DispatchQueue.main.async {
            let success: () =  fcl.openDiscovery()
            print(success)
            print("hello")
            print("here")
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        checkUser()
    }
  
    private func checkUser(){
        let seconds = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                if(fcl.currentUser?.addr != nil){
                //Put your code which should be executed with a delay here
                connectAccountButton.alpha = 0.0
                verifyNFTButton.alpha = 1.0
                purchaseNFTButton.alpha = 1.0
               // initAccountButton.alpha = 1.0
           }
        }
        print("there")
        
    }
    
    
    private let initAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Initialize Setup", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.alpha = 0.0
        button.addTarget(self, action: #selector(initClicked), for: .touchUpInside)

        return button
    }()
    
    @objc func initClicked(){
//        Task {
//            do {
//                let txId = try await fcl.mutate(cadence: HelperFile.initAccount)
//                print("txId ==> \(txId.hex)")
//                FlowManager.shared.subscribeTransaction(txId: txId.hex)
//                let seconds = 2.0
//                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
//                    initAccountButton.alpha = 0.0
//                    verifyNFTButton.alpha = 1.0
//                    purchaseNFTButton.alpha = 1.0
//                }
//            } catch {
//                print(error)
//            }
//        }
    }

    
    private let purchaseNFTButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("Purchase NFT", for: .normal)
       button.titleLabel?.numberOfLines = 0
        button.setTitleColor(.black, for: .normal)
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(purchaseBtnClicked), for: .touchUpInside)
        button.alpha = 0.0
      
       
        return button
    }()
    

    
    private func applyConstraints() {
        
        let verifyNFTButtonConstraints = [
            verifyNFTButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.screenSize.width/7),
            verifyNFTButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.screenSize.height/3.6),
            verifyNFTButton.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/3),
          //  verifyNFTButton.trailingAnchor.constraint(equalTo: purchaseNFTButton.leadingAnchor, constant: -20)
        ]
        
        let connectButtonConstraints = [
           // connectAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.screenSize.width/7),
            connectAccountButton.topAnchor.constraint(equalTo: verifyNFTButton.bottomAnchor, constant: 30),
            connectAccountButton.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/2.2),
          //  verifyNFTButton.trailingAnchor.constraint(equalTo: purchaseNFTButton.leadingAnchor, constant: -20)
            connectAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let initAccountButtonConstraints = [
           // purchaseNFTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.screenSize.width/7),
            initAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.screenSize.height/3.6),
            initAccountButton.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/2.2),
            initAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let purchaseNFTButtonConstraints = [
            
            purchaseNFTButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.screenSize.width/7),
            purchaseNFTButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.screenSize.height/3.6),
            purchaseNFTButton.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/3)
        ]
        
        NSLayoutConstraint.activate(verifyNFTButtonConstraints)
        NSLayoutConstraint.activate(purchaseNFTButtonConstraints)
        NSLayoutConstraint.activate(initAccountButtonConstraints)
        NSLayoutConstraint.activate(connectButtonConstraints)
    }
    
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "Splash screen")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(verifyNFTButton)
        view.addSubview(purchaseNFTButton)
        view.addSubview(initAccountButton)
        view.addSubview(connectAccountButton)
        setupConfig()
        applyConstraints()
      
        view.insertSubview(imageView, at: 0)
               NSLayoutConstraint.activate([
                   imageView.topAnchor.constraint(equalTo: view.topAnchor),
                   imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               ])
        
    }
    
    
    @objc func purchaseBtnClicked(){
        Task {
            do {
                let txId = try await fcl.mutate(cadence: HelperFile.initAccount)
                print("txId ==> \(txId.hex)")
                FlowManager.shared.subscribeTransaction(txId: txId.hex)
                let seconds = 2.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                    initAccountButton.alpha = 0.0
                }
            } catch {
                print(error)
            }
        }
        
                let vc = PurchaseNFTViewController()
                navigationController?.pushViewController(vc, animated: true)
               
    }
    
    
    
    @objc func verifyNFT() {
        
        guard let address = fcl.currentUser?.addr else {
            return
        }

        Task{
            do{
                let nftList = try await fcl.query(script: HelperFile.nftList,
                                                                                        args: [.address(address)])
                    .decode([NFTModel].self)
                
                print(nftList)
                
                if(nftList.isEmpty){
                    
                    let failAlert = UIAlertController(title: "OOPS", message: "Login Failed, Please Purchase our NFT", preferredStyle: UIAlertController.Style.alert)

                    failAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                        self.dismiss(animated: true)
                    }))

                   

                    present(failAlert, animated: true, completion: nil)
                    print("Please Purchase our NFT")
                }
                
                for nft in nftList{
                    if(nft.id<=100 && ( nft.ipfsHash == "QmXmfCfwSewocvGzg6V5zgYUVwYpxyCg8rgAKH4kGMa3bk" || nft.ipfsHash == "QmSEihDof5rpZnaiH7LwnunoTDrT8rvzCodJzCW6JpH48U") ){
                        print("Success")
                        
                        let successAlert = UIAlertController(title: "Congratulations", message: "You have successfully Logged In with our GrowthBook NFT, Enjoy our app", preferredStyle: UIAlertController.Style.alert)

                        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                              print("Handle Ok logic here")
                            self.dismiss(animated: true)
                        }))

                       

                        present(successAlert, animated: true, completion: nil)
                    }
                    else{
                        let failAlert = UIAlertController(title: "OOPS", message: "Login Failed, Please Purchase our NFT", preferredStyle: UIAlertController.Style.alert)

                        failAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                              print("Handle Ok logic here")
                            self.dismiss(animated: true)
                        }))

                       

                        present(failAlert, animated: true, completion: nil)
                        print("Please Purchase our NFT")
                    }
                }
                
            }
            catch{
                print(error)
            }
        }
   
        
    }


}

