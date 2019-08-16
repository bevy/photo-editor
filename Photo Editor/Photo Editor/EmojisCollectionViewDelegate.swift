//
//  EmojisCollectionViewDelegate.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/30/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

class EmojisCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var stickersViewControllerDelegate : StickersViewControllerDelegate?
    var recentEmojis: [String] = []
    let emojiRanges = [
        0x1F601...0x1F64F, // emoticons
        0x1F30D...0x1F567, // Other additional symbols
        0x1F680...0x1F6C0, // Transport and map symbols
        0x1F681...0x1F6C5 //Additional transport and map symbols
    ]
    
    var emojis: [String] = []
    
    override init() {
        super.init()
       let arr = UserDefaults.standard.value(forKey: "Recent_Emojies") as? [String]
       recentEmojis = arr ?? []
        for range in emojiRanges {
            for i in range {
                let c = String(describing: UnicodeScalar(i)!)
                emojis.append(c)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return recentEmojis.count
        }
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emojiLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        emojiLabel.textAlignment = .center
        let emojiText = indexPath.section == 0 ? recentEmojis[indexPath.row] : emojis[indexPath.row]
        emojiLabel.text =  emojiText
        emojiLabel.font = UIFont.systemFont(ofSize: 70)
        if recentEmojis.contains(emojiText) {
            recentEmojis.remove(at: recentEmojis.index(of: emojiText)!)
            recentEmojis.insert(emojiText, at: 0)
        } else  {
            recentEmojis.insert(emojiText, at: 0)
        }
        if recentEmojis.count > 15 {
            recentEmojis.remove(at: 15)
        }
        UserDefaults.standard.setValue(recentEmojis, forKey: "Recent_Emojies")
        UserDefaults.standard.synchronize()
        stickersViewControllerDelegate?.didSelectView(view: emojiLabel)
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
        cell.emojiLabel.text =  indexPath.section == 0 ? recentEmojis[indexPath.row] : emojis[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 20)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: kind, withReuseIdentifier: "header")
        let  reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        
        let lbl  = UILabel(frame: CGRect(x: 10, y: 2, width: 200, height: 15))
        if indexPath.section == 0 {
            lbl.text = "Recently Used"
        }else if indexPath.section == 1 {
           lbl.text = "Emojis"
        }
        if reusableView.subviews.count == 0 {
            reusableView.addSubview(lbl)
        } else {
            let label  = reusableView.subviews[0] as? UILabel
            if indexPath.section == 0 {
                label?.text = "recent items"
            }else if indexPath.section == 1 {
                label?.text = "emojis"
            }
        }
        return reusableView
    }
}
