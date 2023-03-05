//
//  PurchaseNFTViewController.swift
//  DemoHackathonApp
//
//  Created by Aarish Khanna on 27/02/23.
//

import UIKit
import Flow
import FCL
import SDWebImage

class PurchaseNFTViewController: UIViewController {
    
    
    static var index: UInt64 = 0
    private var nftList: [NFTModel] = [NFTModel]()
    static var pack: String = "One"
    static var id1: UInt64 = 0
    static var id2: UInt64 = 0

    private let nftTable: UITableView = {
        let table = UITableView()
        //table.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Click on the plan you like, to know more about it in detail. With a click you can buy our NFT and avail exciting features of the app"
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Purchase our NFT, Check below plans:"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(nftTable)
        view.addSubview(descLabel)
        
        //let screenH = UIScreen.main.bounds.height
        
        nftTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        nftTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true
        nftTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        nftTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.screenSize.height/2.7).isActive = true
     
        nftTable.delegate = self
        nftTable.dataSource = self
        
        nftTable.register(NFTTableViewCell.self, forCellReuseIdentifier: NFTTableViewCell.identifier)
        setup()
        configureConstraints()
    }
    
    func configureConstraints(){
        let labelViewConstraints = [
            descLabel.topAnchor.constraint(equalTo: nftTable.bottomAnchor, constant: 40),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ]
    NSLayoutConstraint.activate(labelViewConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
   //     nftTable.frame = view.bounds
    }

    
    private func setup(){
        
        let address = Flow.Address(hex: "0x69fce77750bf93a4")
        print(address)
        
        Task{
            
            do{
                let salesNFTList = try await fcl.query(script: HelperFile.getSalesNFT,
                                                  args: [.address(address)])
                    .decode([NFTModel].self)
                
                DispatchQueue.main.async {
                    
                    let sortedList = salesNFTList.sorted { nft1, nft2 in
                        nft1.id < nft2.id
                    }
                    
                    self.nftList = sortedList
                    print(self.nftList)
                    self.nftTable.reloadData()
                    print("done")
                    
                }
            }
            catch{
                print(error)
            }
        }
        
    }
    


}

extension PurchaseNFTViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NFTTableViewCell.identifier, for: indexPath) as? NFTTableViewCell else {
            return UITableViewCell()
        }
        
        for nft in nftList{
            
            if(nft.ipfsHash == "QmXmfCfwSewocvGzg6V5zgYUVwYpxyCg8rgAKH4kGMa3bk" && PurchaseNFTViewController.pack == "Two"){
                       cell.configure(With: NFTModel(ipfsHash: nft.ipfsHash, id: nft.id, metadata: nft.metadata))
                       print(nft)
                PurchaseNFTViewController.pack = "One"
                PurchaseNFTViewController.id2 = nft.id
                return cell
                
                   }
            
            if(nft.ipfsHash == "QmSEihDof5rpZnaiH7LwnunoTDrT8rvzCodJzCW6JpH48U" && PurchaseNFTViewController.pack == "One"){
                       cell.configure(With: NFTModel(ipfsHash: nft.ipfsHash, id: nft.id, metadata: nft.metadata))
                       print(nft)
                       PurchaseNFTViewController.pack = "Two"
                
                PurchaseNFTViewController.id1 = nft.id
                
                return cell
                
                
                  }
            
            
        }

       return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.screenSize.height/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let idarr: [UInt64] = [PurchaseNFTViewController.id1, PurchaseNFTViewController.id2]
        
       // for idx in idarr {
            //print(idx)
        if(indexPath.row == 0){
            for nfts in nftList{
                if (nfts.id == idarr[0]){
                    let nft = nfts
                    PurchaseNFTViewController.index = nft.id
                    DispatchQueue.main.async {
                        let vc = DetailNFTPlanViewController()
                        vc.configure(with: NFTModel(ipfsHash: nft.ipfsHash, id: nft.id, metadata: nft.metadata))
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
                //            let nft = nftList[Int(idarr[0])-Int(nftList[0].id)]
                //            PurchaseNFTViewController.index = nft.id
                //
                //            DispatchQueue.main.async {
                //                let vc = DetailNFTPlanViewController()
                //                vc.configure(with: NFTModel(ipfsHash: nft.ipfsHash, id: nft.id, metadata: nft.metadata))
                //                self.navigationController?.pushViewController(vc, animated: true)
                //            }
            }
        }
        else if(indexPath.row == 1){
            for nfts in nftList{
                if (nfts.id == idarr[1]){
                    let nft = nfts
                    PurchaseNFTViewController.index = nft.id
                    DispatchQueue.main.async {
                        let vc = DetailNFTPlanViewController()
                        vc.configure(with: NFTModel(ipfsHash: nft.ipfsHash, id: nft.id, metadata: nft.metadata))
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
//            let nft = nftList[Int(idarr[1])-Int(nftList[0].id)]
//            PurchaseNFTViewController.index = nft.id
//
//            DispatchQueue.main.async {
//                let vc = DetailNFTPlanViewController()
//                vc.configure(with: NFTModel(ipfsHash: nft.ipfsHash, id: nft.id, metadata: nft.metadata))
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    
}


//    let salesNFT: [NFTModel]
//
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        self.salesNFT = ViewController.salesNFT
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .systemFont(ofSize: 18, weight: .bold)
//        label.numberOfLines = 0
//        label.text = "Buy our NFT to access the premium App features"
//        label.textAlignment = .center
//        return label
//
//    }()
//
//    private let NFTImageView: UIImageView = {
//       let image: UIImage = UIImage(named: "Splash screen")!
//       let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 30
//
//        let address = Flow.Address(hex: "0x69fce77750bf93a4")
//
////        guard let address = fcl.currentUser?.addr else {
////           // Not signin
////        //  return
////       }
////
//    //    let address = fcl.currentUser?.addr ?? Flow.Address(hex: "0x69fce77750bf93a4")
//        print(address)
//
//        Task{
//
//            do{
//                let salesNFTList = try await fcl.query(script: HelperFile.nftList,
//                                                  args: [.address(address)])
//                    .decode([NFTModel].self)
//                //[NFTModel].self
//                print(salesNFTList)
//
//                for nft in salesNFTList{
//                    if(nft.ipfsHash == ""){
//
//                    }
//
//                }
//
//
//
//
//            imageView.sd_setImage(with: URL(string: "https://gateway.pinata.cloud/ipfs/\(salesNFTList[0].ipfsHash)"), completed: nil)
//
//
//                DispatchQueue.main.async {
//                    ViewController.nfts = salesNFTList
//                    PurchaseNFTViewController.index = salesNFTList[0].id
//                }
//            }
//            catch{
//                print(error)
//            }
//        }
//
//
//
//        return imageView
//    }()
//
    
    
//    private let purchaseButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//       //button.backgroundColor = UIColor(red: 237, green: 29, blue: 36, alpha: 1.0)
//        button.setTitle("Buy Now", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = UIColor(red: 240/255, green: 70/255, blue: 100/255, alpha: 1.0)
//       // button.backgroundColor = .white
//        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        button.layer.shadowOpacity = 1.0
//        button.layer.cornerRadius = 10
//        button.layer.masksToBounds = true
//        button.addTarget(self, action: #selector(purchaseBtnClicked), for: .touchUpInside)
//        return button
//
//    }()
//
//
//    func setConstraints(to view: UIView , superView: UIView) {
//        self.translatesAutoresizingMaskIntoConstraints = false
//        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0.8)
//        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -0.8)
//        let width = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
//        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120)
//        superView.addConstraints([leading, trailing])
//        self.addConstraints([width, height])
//    }
//
//    func configureConstraints(){
//
//        let titleLabelConstraints = [
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//        ]
//
//        let NFTImageConstraints = [
//            NFTImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                   NFTImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            NFTImageView.heightAnchor.constraint(equalToConstant: Constants.screenSize.height/2),
//            NFTImageView.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/2),
//
//        ]
//
//        let purchaseButtonConstraints = [
//            purchaseButton.topAnchor.constraint(equalTo: NFTImageView.bottomAnchor, constant: 50),
//            purchaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            purchaseButton.widthAnchor.constraint(equalToConstant: Constants.screenSize.width/3)
//
//
//        ]
//
//        NSLayoutConstraint.activate(titleLabelConstraints)
//        NSLayoutConstraint.activate(NFTImageConstraints)
//        NSLayoutConstraint.activate(purchaseButtonConstraints)
//
//
//    }

//    @objc func purchaseBtnClicked(){
//
//        let address = Flow.Address(hex: "0x69fce77750bf93a4")
//        guard let user = fcl.currentUser else {
//            // Not signin
//            return
//        }
//        Task{
//            do{
//                let txId = try await fcl.mutate(                            cadence: HelperFile.purchaseNFT
//
//                                 ,
//                         args: [
//                            .address(address), .uint64(PurchaseNFTViewController.index)
//                        ],
//                         gasLimit: 999,
//                         authorizors: [user])
//
//                 print("txId ==> \(txId.hex)")
//
//            }
//            catch{
//                print(error)
//            }
//        }
//
//    }
