//
//  NFTTableViewCell.swift
//  DemoHackathonApp
//
//  Created by Aarish Khanna on 28/02/23.
//

import UIKit

class NFTTableViewCell: UITableViewCell {
    
    static let identifier = "NFTsTableViewCell"
    
    private let expandNFTButton: UIButton = {
                let button = UIButton()
                let image = UIImage(systemName: "arrow.right", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
                button.setImage(image, for: .normal)
               button.translatesAutoresizingMaskIntoConstraints = false
                button.tintColor = .red
                return button
    }()
    
    private let nftLabel: UILabel = {
        let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
        
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let nftPosterUIImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nftPosterUIImageView)
        contentView.addSubview(nftLabel)
        contentView.addSubview(expandNFTButton)
        contentView.addSubview(priceLabel)
        
       applyConstraints()
        
    }
    
    private func applyConstraints() {
        let nftPosterUIImageViewConstraints = [
          nftPosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    nftPosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            nftPosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            nftPosterUIImageView.widthAnchor.constraint(equalToConstant: 0.35*(Constants.screenSize.width)),
                
                ]
        
        let priceLabelConstraints = [
            priceLabel.topAnchor.constraint(equalTo: nftLabel.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: nftPosterUIImageView.trailingAnchor, constant: 0.06*(Constants.screenSize.width)),
            
        ]
                
                
                let nftLabelConstraints = [
                    nftLabel.leadingAnchor.constraint(equalTo: nftPosterUIImageView.trailingAnchor, constant: 0.06*(Constants.screenSize.width)),
                    nftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                    nftLabel.widthAnchor.constraint(equalToConstant: 0.47*(Constants.screenSize.width))
                ]
        
                let expandNFTButtonConstraints = [
                    expandNFTButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0.03*(Constants.screenSize.width)),
                    expandNFTButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
                ]
                
                
        
        NSLayoutConstraint.activate(nftPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(nftLabelConstraints)
        NSLayoutConstraint.activate(expandNFTButtonConstraints)
        NSLayoutConstraint.activate(priceLabelConstraints)
    }
    
    
    public func configure(With model: NFTModel) {

        guard let url = URL(string:"https://gateway.pinata.cloud/ipfs/\(model.ipfsHash)") else {return}
        print("hhhhhhhhh")
        nftPosterUIImageView.sd_setImage(with: url, completed: nil)
        nftLabel.text = model.metadata.name
        if(nftLabel.text == "GrowthBook NFT"){
            priceLabel.text = "Price: 50 FLOW"
        }
        else if(nftLabel.text == "GrowthBook PRO-NFT"){
            priceLabel.text = "Price: 100 FLOW"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}

