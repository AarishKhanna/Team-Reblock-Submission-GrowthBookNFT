//
//  DetailNFTPlanViewController.swift
//  DemoHackathonApp
//
//  Created by Aarish Khanna on 28/02/23.
//

import UIKit
import Flow
import FCL

class DetailNFTPlanViewController: UIViewController {
    
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 17, weight: .bold)
            label.text = "GrowthBook NFT"
            return label
            
        }()
        
        private let overviewLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.text = "This is best plan for your kid"
            return label
        }()
        
        private let buyButton: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .red
            button.setTitle("Buy", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
            button.layer.cornerRadius = 15
            button.layer.masksToBounds = true
            button.addTarget(self, action: #selector(purchaseBtnClicked), for: .touchUpInside)
            return button
        }()
    
        private let NFTImageView: UIImageView = {
           let image: UIImage = UIImage(named: "Splash screen")!
           let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 30
    
            return imageView
        }()
    

        @objc func purchaseBtnClicked(){
    
            let address = Flow.Address(hex: "0x69fce77750bf93a4")
            guard let user = fcl.currentUser else {
                // Not signin
                return
            }
            Task{
                do{
                    print(PurchaseNFTViewController.index)
                    let txId = try await fcl.mutate(                            cadence: HelperFile.purchaseNFT
    
                                     ,
                             args: [
                                .address(address), .uint64(PurchaseNFTViewController.index)
                            ],
                             gasLimit: 999,
                             authorizors: [user])
    
                     print("txId ==> \(txId.hex)")
                    let successAlert = UIAlertController(title: "Congratulations", message: "You have successfully bought our GrowthBook NFT, Enjoy our app", preferredStyle: UIAlertController.Style.alert)

                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                          print("Handle Ok logic here")
                        self.dismiss(animated: true)
                    }))
                    
                    present(successAlert, animated: true, completion: nil)
                    
                }
                catch{
                    print(error)
                }
            }
    
        }
        
        

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            
            
            view.addSubview(titleLabel)
            view.addSubview(overviewLabel)
            view.addSubview(buyButton)
            view.addSubview(NFTImageView)
            
            configureConstraints()
        }
        
        func configureConstraints(){
            let imageViewConstraints = [
                NFTImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
                NFTImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                NFTImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                NFTImageView.heightAnchor.constraint(equalToConstant: 250)
            ]
            
            let titleLabelConstraints = [
                titleLabel.topAnchor.constraint(equalTo: NFTImageView.bottomAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
            ]
            
            let overviewLabelConstraints = [
                overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
                overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            
            let buyButtonConstraints = [
                buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buyButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 13),
                buyButton.widthAnchor.constraint(equalToConstant: 140),
                buyButton.heightAnchor.constraint(equalToConstant: 40)
            ]
            NSLayoutConstraint.activate(imageViewConstraints)
            NSLayoutConstraint.activate(titleLabelConstraints)
            NSLayoutConstraint.activate(overviewLabelConstraints)
            NSLayoutConstraint.activate(buyButtonConstraints)
        }
        
        func configure(with model: NFTModel){
            titleLabel.text = model.metadata.name
            guard let url = URL(string:"https://gateway.pinata.cloud/ipfs/\(model.ipfsHash)") else {return}
            NFTImageView.sd_setImage(with: url, completed: nil)
            if(titleLabel.text == "GrowthBook NFT"){
                overviewLabel.text = """
After buying our GrowthBook NFT, You get access to following exciting features:

1.Track growth your baby
2. Unlimited non-intervention consultation from child professional
3.Become a part of global parent community

"""
            }
            else if(titleLabel.text == "GrowthBook PRO-NFT"){
                overviewLabel.text = """
After buying our GrowthBook PRO-NFT, You get access to following exciting features:

1.Track growth your baby
2. Unlimited non-intervention consultation from child professional
3.Become a part of global parent community

More Features:
4. Participate in webinar & events which help you as a parent
5. Become Part of Creator's team and many more

"""
            }
            

            
        }

       

    }

