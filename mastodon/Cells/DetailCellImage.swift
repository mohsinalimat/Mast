//
//  DetailCellImage.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

class DetailCellImage: UITableViewCell {
    
    var profileImageView = UIButton()
    var userName = UILabel()
    var userTag = UILabel()
    var date = UILabel()
    var toot = ActiveLabel()
    var faves = UIButton()
    var fromClient = UILabel()
    var mainImageView = UIButton()
    var mainImageViewBG = UIView()
    var imageCountTag = UIButton()
    
    var smallImage1 = UIButton()
    var smallImage2 = UIButton()
    var smallImage3 = UIButton()
    var smallImage4 = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView.backgroundColor = Colours.white
        mainImageView.backgroundColor = Colours.white
        mainImageViewBG.backgroundColor = Colours.white
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageViewBG.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        userTag.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        toot.translatesAutoresizingMaskIntoConstraints = false
        fromClient.translatesAutoresizingMaskIntoConstraints = false
        faves.translatesAutoresizingMaskIntoConstraints = false
        
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        profileImageView.layer.masksToBounds = true
        mainImageView.layer.masksToBounds = true
        
        mainImageViewBG.layer.masksToBounds = false
        mainImageViewBG.layer.shadowColor = UIColor.black.cgColor
        mainImageViewBG.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainImageViewBG.layer.shadowRadius = 12
        mainImageViewBG.layer.shadowOpacity = 0.22
        mainImageViewBG.layer.masksToBounds = false
        if UIDevice.current.userInterfaceIdiom == .pad {
            mainImageViewBG.alpha = 0
        }
        
        userName.numberOfLines = 0
        userTag.numberOfLines = 0
        toot.numberOfLines = 0
        fromClient.numberOfLines = 0
        faves.titleLabel?.textAlignment = .left
        
        userName.textColor = Colours.black
        userTag.textColor = Colours.black.withAlphaComponent(0.6)
        date.textColor = Colours.black.withAlphaComponent(0.6)
        toot.textColor = Colours.black
        fromClient.textColor = Colours.black.withAlphaComponent(0.6)
        faves.titleLabel?.textColor = Colours.tabSelected
        faves.setTitleColor(Colours.tabSelected, for: .normal)
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        fromClient.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        faves.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        
        toot.enabledTypes = [.mention, .hashtag, .url]
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(mainImageViewBG)
        contentView.addSubview(mainImageView)
        contentView.addSubview(userName)
        contentView.addSubview(userTag)
        contentView.addSubview(date)
        contentView.addSubview(toot)
        contentView.addSubview(fromClient)
        contentView.addSubview(faves)
        
        imageCountTag.backgroundColor = Colours.clear
        imageCountTag.translatesAutoresizingMaskIntoConstraints = false
        imageCountTag.layer.cornerRadius = 7
        imageCountTag.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        imageCountTag.layer.shadowColor = UIColor.black.cgColor
        imageCountTag.layer.shadowOffset = CGSize(width: 0, height: 7)
        imageCountTag.layer.shadowRadius = 10
        imageCountTag.layer.shadowOpacity = 0.22
        imageCountTag.layer.masksToBounds = false
        mainImageView.addSubview(imageCountTag)
        
        let viewsDict = [
            "image" : profileImageView,
            "mainImageBG" : mainImageViewBG,
            "mainImage" : mainImageView,
            "name" : userName,
            "artist" : userTag,
            "date" : date,
            "episodes" : toot,
            "from" : fromClient,
            "faves" : faves,
            "countTag" : imageCountTag,
            ]
        
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[name]-(>=5)-[date]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[artist]-(>=5)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[episodes]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[from]-20-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(40)]-13-[faves]-(>=20)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mainImage]-0-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[mainImageBG]-0-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[date]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[image(40)]-(>=12)-|", options: [], metrics: nil, views: viewsDict))
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-15-[episodes]-15-[mainImage(250)]-10-[faves]-10-[from]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-15-[episodes]-15-[mainImageBG(250)]-10-[faves]-10-[from]-12-|", options: [], metrics: nil, views: viewsDict))
        case .pad:
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-15-[episodes]-15-[mainImage(500)]-10-[faves]-10-[from]-12-|", options: [], metrics: nil, views: viewsDict))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[name]-1-[artist]-15-[episodes]-15-[mainImageBG(500)]-10-[faves]-10-[from]-12-|", options: [], metrics: nil, views: viewsDict))
        default:
            print("nothing")
        }
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[countTag(30)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[countTag(22)]-(>=10)-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ status: Status) {
        
        toot.mentionColor = Colours.tabSelected
        toot.hashtagColor = Colours.tabSelected
        toot.URLColor = Colours.tabSelected
        
        userName.text = status.reblog?.account.displayName ?? status.account.displayName
        if (UserDefaults.standard.object(forKey: "mentionToggle") == nil || UserDefaults.standard.object(forKey: "mentionToggle") as! Int == 0) {
            userTag.text = "@\(status.reblog?.account.acct ?? status.account.acct)"
        } else {
            userTag.text = "@\(status.reblog?.account.username ?? status.account.username)"
        }
        date.text = status.reblog?.createdAt.toStringWithRelativeTime() ?? status.createdAt.toStringWithRelativeTime()
        if status.reblog?.content.stripHTML() != nil {
//            toot.text = "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.username) boosted"
            
            
            
            
            if status.reblog!.emojis.isEmpty {
                toot.text = "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.acct) boosted"
            } else {
                let attributedString = NSMutableAttributedString(string: "\(status.reblog?.content.stripHTML() ?? "")\n\n\u{21bb} @\(status.account.acct) boosted")
                for y in status.reblog!.emojis {
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    while attributedString.mutableString.contains(":\(y.shortcode):") {
                        let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                        attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                        
                    }
                }
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            
            if status.reblog?.account.emojis.isEmpty ?? true {
                userName.text = status.reblog?.account.displayName.stripHTML()
            } else {
                let attributedString = NSMutableAttributedString(string: status.reblog?.account.displayName.stripHTML() ?? "")
                for y in status.reblog?.account.emojis ?? [] {
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    while attributedString.mutableString.contains(":\(y.shortcode):") {
                        let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                        attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                    }
                }
                self.userName.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            
            
        } else {
//            toot.text = status.content.stripHTML()
            
            
            if status.emojis.isEmpty {
                toot.text = status.content.stripHTML()
            } else {
                let attributedString = NSMutableAttributedString(string: status.content.stripHTML())
                for y in status.emojis {
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.toot.font.lineHeight), height: Int(self.toot.font.lineHeight))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    while attributedString.mutableString.contains(":\(y.shortcode):") {
                        let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                        attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                        
                    }
                }
                self.toot.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            if status.account.emojis.isEmpty {
                userName.text = status.account.displayName.stripHTML()
            } else {
                let attributedString = NSMutableAttributedString(string: status.account.displayName.stripHTML())
                for y in status.account.emojis {
                    let textAttachment = NSTextAttachment()
                    textAttachment.loadImageUsingCache(withUrl: y.url.absoluteString)
                    textAttachment.bounds = CGRect(x:0, y: Int(-4), width: Int(self.userName.font.lineHeight), height: Int(self.userName.font.lineHeight))
                    let attrStringWithImage = NSAttributedString(attachment: textAttachment)
                    while attributedString.mutableString.contains(":\(y.shortcode):") {
                        let range: NSRange = (attributedString.mutableString as NSString).range(of: ":\(y.shortcode):")
                        attributedString.replaceCharacters(in: range, with: attrStringWithImage)
                    }
                }
                self.userName.attributedText = attributedString
                self.reloadInputViews()
            }
            
            
            
            
        }
        let z = status.reblog?.application?.name ?? status.application?.name ?? ""
        let da = status.reblog?.createdAt.toString(dateStyle: .medium, timeStyle: .medium) ?? status.createdAt.toString(dateStyle: .medium, timeStyle: .medium)
        if z == "" {
            fromClient.text = da
        } else {
            fromClient.text = "\(da), via \(z)"
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: status.reblog?.favouritesCount ?? status.favouritesCount))
        
        let numberFormatter2 = NumberFormatter()
        numberFormatter2.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber2 = numberFormatter2.string(from: NSNumber(value: status.reblog?.reblogsCount ?? status.reblogsCount))
        
        var likeText = "likes"
        if formattedNumber == "1" {
            likeText = "like"
        }
        var boostText = "boosts"
        if formattedNumber2 == "1" {
            boostText = "boost"
        }
        
        faves.setTitle("\(formattedNumber ?? "0") \(likeText) and \(formattedNumber2 ?? "0") \(boostText)", for: .normal)
        
        DispatchQueue.global(qos: .userInitiated).async {
        self.profileImageView.pin_setPlaceholder(with: UIImage(named: "logo"))
        self.profileImageView.pin_updateWithProgress = true
        self.profileImageView.pin_setImage(from: URL(string: "\(status.reblog?.account.avatar ?? status.account.avatar)"))
        }
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 0.2
        if (UserDefaults.standard.object(forKey: "proCorner") == nil || UserDefaults.standard.object(forKey: "proCorner") as! Int == 0) {
            profileImageView.layer.cornerRadius = 20
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 1) {
            profileImageView.layer.cornerRadius = 8
        }
        if (UserDefaults.standard.object(forKey: "proCorner") != nil && UserDefaults.standard.object(forKey: "proCorner") as! Int == 2) {
            profileImageView.layer.cornerRadius = 0
        }
        
        userName.font = UIFont.boldSystemFont(ofSize: Colours.fontSize1)
        userTag.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        date.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        toot.font = UIFont.systemFont(ofSize: Colours.fontSize1)
        fromClient.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        faves.titleLabel?.font = UIFont.systemFont(ofSize: Colours.fontSize3)
        
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.imageView?.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.layer.masksToBounds = true
        
        
        self.smallImage1.alpha = 0
        self.smallImage2.alpha = 0
        self.smallImage3.alpha = 0
        self.smallImage4.alpha = 0
        imageCountTag.isUserInteractionEnabled = false
        if status.reblog?.mediaAttachments[0].type ?? status.mediaAttachments[0].type == .video {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
            }
            imageCountTag.setTitle("\u{25b6}", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.reblog?.mediaAttachments[0].type ?? status.mediaAttachments[0].type == .gifv {
//            self.mainImageView.setImage(UIImage(), for: .normal)
            DispatchQueue.global(qos: .userInitiated).async {
                self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.mainImageView.pin_updateWithProgress = true
                self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
            }
            imageCountTag.setTitle("GIF", for: .normal)
            imageCountTag.backgroundColor = Colours.tabSelected
            imageCountTag.alpha = 1
        } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count > 1 {
            self.mainImageView.setImage(UIImage(), for: .normal)
            if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count == 2 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (UIScreen.main.bounds.width)/2, height: 240)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: 0, width: (UIScreen.main.bounds.width)/2, height: 240)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
            } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count == 3 {
                self.smallImage1.frame = CGRect(x: -2, y: 0, width: (UIScreen.main.bounds.width)/2, height: 240)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: -2, width: (UIScreen.main.bounds.width)/2, height: 120)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: 122, width: (UIScreen.main.bounds.width)/2, height: 120)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[2].previewURL ?? status.mediaAttachments[2].previewURL)"))
                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
            } else if status.reblog?.mediaAttachments.count ?? status.mediaAttachments.count >= 4 {
                self.smallImage1.frame = CGRect(x: -2, y: -2, width: (UIScreen.main.bounds.width)/2, height: 120)
                self.smallImage1.contentMode = .scaleAspectFill
                self.smallImage1.imageView?.contentMode = .scaleAspectFill
                self.smallImage1.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage1.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage1.pin_updateWithProgress = true
                self.smallImage1.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[0].previewURL ?? status.mediaAttachments[0].previewURL)"))
                }
                self.smallImage1.layer.masksToBounds = true
                self.smallImage1.layer.borderColor = UIColor.black.cgColor
                self.smallImage1.alpha = 1
                self.mainImageView.addSubview(self.smallImage1)
                
                self.smallImage2.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: -2, width: (UIScreen.main.bounds.width)/2, height: 120)
                self.smallImage2.contentMode = .scaleAspectFill
                self.smallImage2.imageView?.contentMode = .scaleAspectFill
                self.smallImage2.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage2.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage2.pin_updateWithProgress = true
                self.smallImage2.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[1].previewURL ?? status.mediaAttachments[1].previewURL)"))
                }
                self.smallImage2.layer.masksToBounds = true
                self.smallImage2.layer.borderColor = UIColor.black.cgColor
                self.smallImage2.alpha = 1
                self.mainImageView.addSubview(self.smallImage2)
                
                self.smallImage3.frame = CGRect(x: -2, y: 122, width: (UIScreen.main.bounds.width)/2, height: 120)
                self.smallImage3.contentMode = .scaleAspectFill
                self.smallImage3.imageView?.contentMode = .scaleAspectFill
                self.smallImage3.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage3.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage3.pin_updateWithProgress = true
                self.smallImage3.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[2].previewURL ?? status.mediaAttachments[2].previewURL)"))
                }
                self.smallImage3.layer.masksToBounds = true
                self.smallImage3.layer.borderColor = UIColor.black.cgColor
                self.smallImage3.alpha = 1
                self.mainImageView.addSubview(self.smallImage3)
                
                self.smallImage4.frame = CGRect(x: (UIScreen.main.bounds.width)/2 + 2, y: 122, width: (UIScreen.main.bounds.width)/2, height: 120)
                self.smallImage4.contentMode = .scaleAspectFill
                self.smallImage4.imageView?.contentMode = .scaleAspectFill
                self.smallImage4.clipsToBounds = true
                DispatchQueue.global(qos: .userInitiated).async {
                self.smallImage4.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
                self.smallImage4.pin_updateWithProgress = true
                self.smallImage4.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments[3].previewURL ?? status.mediaAttachments[3].previewURL)"))
                }
                self.smallImage4.layer.masksToBounds = true
                self.smallImage4.layer.borderColor = UIColor.black.cgColor
                self.smallImage4.alpha = 1
                self.mainImageView.addSubview(self.smallImage4)
            } else {
                self.smallImage1.alpha = 0
                self.smallImage2.alpha = 0
                self.smallImage3.alpha = 0
                self.smallImage4.alpha = 0
            }
        } else {
            imageCountTag.backgroundColor = Colours.clear
            imageCountTag.alpha = 0
            DispatchQueue.global(qos: .userInitiated).async {
            self.mainImageView.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
            self.mainImageView.pin_updateWithProgress = true
            self.mainImageView.pin_setImage(from: URL(string: "\(status.reblog?.mediaAttachments.first?.previewURL ?? status.mediaAttachments.first?.previewURL ?? "")"))
            }
        }
        
    }
    
}


