//
//  EmojisCollectionViewDelegate.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/30/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

class EmojisCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let emojiRanges = [
        0x1F600...0x1F64F, //
        0x1F680...0x1F6C0
    ]
    
    var emojis: [String] = []

    override init() {
        super.init()
        
        for range in emojiRanges {
            for i in range {
                let c = String(describing: UnicodeScalar(i)!)
                emojis.append(c)
                print(c)
            }
        }
    }
    
    var stickerDelegate : StickerDelegate?

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmojiCollectionViewCell
        stickerDelegate?.viewTapped(view: cell.emojiLabel)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
        cell.emojiLabel.text = emojis[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
