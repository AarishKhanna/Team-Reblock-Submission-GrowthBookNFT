//
//  NFTModel.swift
//  DemoHackathonApp
//
//  Created by Aarish Khanna on 28/02/23.
//

import Foundation


struct NFTModel: Codable, Hashable {
    
    let ipfsHash: String
    let id: UInt64
    let metadata: tempModel
    
}

struct nftRef: Codable, Hashable{
    
    let metadata: tempModel

}

struct tempModel: Codable, Hashable{
    let name: String
}
