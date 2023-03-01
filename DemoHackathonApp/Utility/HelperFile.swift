//
//  HelperFile.swift
//  DemoHackathonApp
//
//  Created by Aarish Khanna on 27/02/23.
//

import Foundation
import FCL

class HelperFile {
    
    static let initAccount =
        """
            import MyNFT from 0xce6e0ea6c6cde0a4
            import NonFungibleToken from 0x631e88ae7f1d7c20
            import FungibleToken from 0x9a0766d93b6608b7
            import FlowToken from 0x7e60df042a9c0868
            import NFTMarketplace from 0xce6e0ea6c6cde0a4
             transaction {
                      prepare(acct: AuthAccount) {
                        acct.save(<- MyNFT.createEmptyCollection(), to: /storage/GrowthBooks)
                        acct.link<&MyNFT.Collection{MyNFT.CollectionPublic, NonFungibleToken.CollectionPublic}>(/public/GrowthBooks, target: /storage/GrowthBooks)
                        acct.link<&MyNFT.Collection>(/private/GrowthBooks, target: /storage/GrowthBooks)
                        
                        let GrowthBooks = acct.getCapability<&MyNFT.Collection>(/private/GrowthBooks)
                        let FlowTokenVault = acct.getCapability<&FlowToken.Vault{FungibleToken.Receiver}>(/public/flowTokenReceiver)
                        acct.save(<- NFTMarketplace.createSaleCollection(MyNFTCollection: GrowthBooks, FlowTokenVault: FlowTokenVault), to: /storage/GrowthBooksSales)
                        acct.link<&NFTMarketplace.SaleCollection{NFTMarketplace.SaleCollectionPublic}>(/public/GrowthBooksSales, target: /storage/GrowthBooksSales)
                      }
                      execute {
                        log("A user stored a Collection and a SaleCollection inside their account")
                      }
                    }
            """
    
    static let getSalesNFT =
    """
        import MyNFT from 0xce6e0ea6c6cde0a4
        import NonFungibleToken from 0x631e88ae7f1d7c20
        import NFTMarketplace from 0xce6e0ea6c6cde0a4
        pub fun main(account: Address): {UInt64: NFTMarketplace.SaleItem} {
          let saleCollection = getAccount(account).getCapability(/public/GrowthBooksSales)
                                .borrow<&NFTMarketplace.SaleCollection{NFTMarketplace.SaleCollectionPublic}>()
                                ?? panic("Could not borrow the user's SaleCollection")
          let collection = getAccount(account).getCapability(/public/GrowthBooks)
                            .borrow<&MyNFT.Collection{NonFungibleToken.CollectionPublic, MyNFT.CollectionPublic}>()
                            ?? panic("Can't get the User's collection.")
          let saleIDs = saleCollection.getIDs()
          let returnVals: {UInt64: NFTMarketplace.SaleItem} = {}
          for saleID in saleIDs {
            let price = saleCollection.getPrice(id: saleID)
            let nftRef = collection.borrowEntireNFT(id: saleID)
            returnVals.insert(key: nftRef.id, NFTMarketplace.SaleItem(_price: price, _nftRef: nftRef))
          }
          return returnVals
        }
        """

    
    static let nftList =
        """
        import MyNFT from 0xce6e0ea6c6cde0a4
        import NonFungibleToken from 0x631e88ae7f1d7c20
        pub fun main(account: Address): [&MyNFT.NFT] {
          let collection = getAccount(account).getCapability(/public/GrowthBooks)
                            .borrow<&MyNFT.Collection{NonFungibleToken.CollectionPublic, MyNFT.CollectionPublic}>()
                            ?? panic("Can't get the User's collection.")
          let returnVals: [&MyNFT.NFT] = []
          let ids = collection.getIDs()
          for id in ids {
            returnVals.append(collection.borrowEntireNFT(id: id))
          }
          return returnVals
        }
        """
    
    static let putForSale =
        """
        import NFTMarketplace from 0xce6e0ea6c6cde0a4
        transaction(id: UInt64, price: UFix64) {
          prepare(acct: AuthAccount) {
            let saleCollection = acct.borrow<&NFTMarketplace.SaleCollection>(from: /storage/GrowthBooksSales)
                                    ?? panic("This SaleCollection does not exist")
            saleCollection.listForSale(id: id, price: price)
          }
          execute {
            log("A user listed an NFT for Sale")
          }
        }
        """
    
    static let purchaseNFT =
    """
    import MyNFT from 0xce6e0ea6c6cde0a4
    import NonFungibleToken from 0x631e88ae7f1d7c20
    import NFTMarketplace from 0xce6e0ea6c6cde0a4
    import FlowToken from 0x7e60df042a9c0868
    transaction(account: Address, id: UInt64) {
      prepare(acct: AuthAccount) {
        let saleCollection = getAccount(account).getCapability(/public/GrowthBooksSales)
                            .borrow<&NFTMarketplace.SaleCollection{NFTMarketplace.SaleCollectionPublic}>()
                            ?? panic("Could not borrow the user's SaleCollection")
        let recipientCollection = getAccount(acct.address).getCapability(/public/GrowthBooks)
                        .borrow<&MyNFT.Collection{NonFungibleToken.CollectionPublic}>()
                        ?? panic("Can't get the User's collection.")
        let price = saleCollection.getPrice(id: id)
        let payment <- acct.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!.withdraw(amount: price) as! @FlowToken.Vault
        saleCollection.purchase(id: id, recipientCollection: recipientCollection, payment: <- payment)
      }
      execute {
        log("A user purchased an NFT")
      }
    }
"""
    
    static let mintNFT =
        """
        import MyNFT from 0xce6e0ea6c6cde0a4
        transaction(ipfsHash: String, name: String) {
          prepare(acct: AuthAccount) {
            let collection = acct.borrow<&MyNFT.Collection>(from: /storage/GrowthBooks)
                                ?? panic("This collection does not exist here")
            let nft <- MyNFT.createToken(ipfsHash: ipfsHash, metadata: {"name": name})
            collection.deposit(token: <- nft)
          }
          execute {
            log("A user minted an NFT into their account")
          }
        }
        """
}
