//
//  ComposeViewController.swift
//  mastodon
//
//  Created by Shihab Mehboob on 22/09/2018.
//  Copyright © 2018 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Photos
import StatusAlert
import MediaPlayer
import MobileCoreServices
import SwiftyJSON
import AVKit
import AVFoundation
import Sharaku

class ComposeViewController: UIViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SwiftyGiphyViewControllerDelegate, DateTimePickerDelegate, SHViewControllerDelegate {
    
    let gifCont = SwiftyGiphyViewController()
    var isGifVid = false
    var player = AVPlayer()
    
    func giphyControllerDidSelectGif(controller: SwiftyGiphyViewController, item: GiphyItem) {
        print(item.fixedHeightStillImage)
        print(item.contentURL ?? "")
        
        let videoURL = item.downsizedImage?.url as! NSURL
        do {
            self.isGifVid = true
            self.gifVidData = try NSData(contentsOf: videoURL as URL, options: .mappedIfSafe) as Data
        } catch {
            print("err")
        }
        self.selectedImage1.pin_setImage(from: item.originalStillImage?.url)
        self.selectedImage1.isUserInteractionEnabled = true
        self.selectedImage1.contentMode = .scaleAspectFill
        self.selectedImage1.layer.masksToBounds = true
        
        self.gifCont.dismiss(animated: true, completion: nil)
    }
    
    func giphyControllerDidCancel(controller: SwiftyGiphyViewController) {
        self.gifCont.dismiss(animated: true, completion: nil)
    }
    
    func clearTheText() {
        self.textView.text = StoreStruct.holdOnTempText
    }
    
    var closeButton = MNGExpandedTouchAreaButton()
    var avatarButton = MNGExpandedTouchAreaButton()
    var cameraButton = MNGExpandedTouchAreaButton()
    var visibilityButton = MNGExpandedTouchAreaButton()
    var warningButton = MNGExpandedTouchAreaButton()
    var emotiButton = MNGExpandedTouchAreaButton()
    var tootLabel = UIButton()
    var textView = SentimentAnalysisTextView()
    var textField = UITextField()
    var countLabel = UILabel()
    var keyHeight = 0
    var bgView = UIView()
    var cameraCollectionView: UICollectionView!
    var images: [UIImage] = []
    var images2: [PHAsset] = []
    var camPickButton = MNGExpandedTouchAreaButton()
    var galPickButton = MNGExpandedTouchAreaButton()
    var selectedImage1 = UIImageView()
    var selectedImage2 = UIImageView()
    var selectedImage3 = UIImageView()
    var selectedImage4 = UIImageView()
    var photoNew = UIImage()
    var buttonCenter = CGPoint.zero
    var removeLabel = UILabel()
    
    var inReply: [Status] = []
    var inReplyText: String = ""
    var prevTextReply: String? = nil
    var filledTextFieldText = ""
    var idToDel = ""
    var mediaIDs: [Media] = []
    var isSensitive = false
    var visibility: Visibility = .public
    var tableView = UITableView()
    var tableViewASCII = UITableView()
    var tableViewEmoti = UITableView()
    var tableViewDrafts = UITableView()
    var theReg = ""
    let imag = UIImagePickerController()
    var gifVidData: Data?
    var startRepText = ""
    var isScheduled = false
    var scheduleTime: String?
    var boosterText = ""
    var isPollAdded = false
    var filterFromWhichImage = 0
    var isVidText: [String] = []
    var isVidBG: [UIColor] = []
    
    @objc func actOnSpecialNotificationAuto() {
        //dothestuff
        
        print("inspecial")
        
        DispatchQueue.main.async {
            self.textView.becomeFirstResponder()
            
            if self.selectedImage1.image == nil {
                self.selectedImage1.image = StoreStruct.photoNew
                self.selectedImage1.isUserInteractionEnabled = true
                self.selectedImage1.contentMode = .scaleAspectFill
                self.selectedImage1.layer.masksToBounds = true
            } else if self.selectedImage2.image == nil {
                self.selectedImage2.image = StoreStruct.photoNew
                self.selectedImage2.isUserInteractionEnabled = true
                self.selectedImage2.contentMode = .scaleAspectFill
                self.selectedImage2.layer.masksToBounds = true
            } else if self.selectedImage3.image == nil {
                self.selectedImage3.image = StoreStruct.photoNew
                self.selectedImage3.isUserInteractionEnabled = true
                self.selectedImage3.contentMode = .scaleAspectFill
                self.selectedImage3.layer.masksToBounds = true
            } else if self.selectedImage4.image == nil {
                self.selectedImage4.image = StoreStruct.photoNew
                self.selectedImage4.isUserInteractionEnabled = true
                self.selectedImage4.contentMode = .scaleAspectFill
                self.selectedImage4.layer.masksToBounds = true
            }
        }
    }
    
    func shViewControllerImageDidFilter(image: UIImage) {
        if self.filterFromWhichImage == 0 {
            self.selectedImage1.image = image
        }
        if self.filterFromWhichImage == 1 {
            self.selectedImage2.image = image
        }
        if self.filterFromWhichImage == 2 {
            self.selectedImage3.image = image
        }
        if self.filterFromWhichImage == 3 {
            self.selectedImage4.image = image
        }
    }
    
    func shViewControllerDidCancel() {
        
    }
    
    @objc func tappedImageView1(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        if self.isPollAdded {
            
            Alertift.actionSheet(title: nil, message: nil)
                .backgroundColor(Colours.white)
                .titleTextColor(Colours.grayDark)
                .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                .messageTextAlignment(.left)
                .titleTextAlignment(.left)
                .action(.default("Edit Poll"), image: UIImage(named: "list")) { (action, ind) in
                    print(action, ind)
                    let controller = NewPollViewController()
                    self.present(controller, animated: true, completion: nil)
                }
                .action(.default("Remove Poll".localized), image: UIImage(named: "block")) { (action, ind) in
                    print(action, ind)
                    
                    self.selectedImage1.image = nil
                    self.selectedImage2.image = nil
                    self.selectedImage3.image = nil
                    self.selectedImage4.image = nil
                    StoreStruct.currentOptions = []
                    StoreStruct.expiresIn = 86400
                    StoreStruct.allowsMultiple = false
                    StoreStruct.totalsHidden = false
                    StoreStruct.newPollPost = []
                    self.isPollAdded = false
                }
                .action(.cancel("Dismiss"))
                .finally { action, index in
                    if action.style == .cancel {
                        self.bringBackDrawer()
                        return
                    }
                }
                .popover(anchorView: self.selectedImage1)
                .show(on: self)
            
        } else {
            
            if self.isGifVid {
                
                Alertift.actionSheet(title: nil, message: nil)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("View GIF/Video".localized), image: nil) { (action, ind) in
                        let originImage = self.selectedImage1.image
                        var images = [SKPhoto]()
                        let photo = SKPhoto.photoWithImage(self.selectedImage1.image!)
                        images.append(photo)
                        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: sender.view)
                        browser.initializePageIndex(0)
                        self.present(browser, animated: true, completion: {})
                    }
                    .action(.default("Edit Caption".localized), image: nil) { (action, ind) in
                        
                        let controller = NewCaptionViewController()
                        controller.editListName = StoreStruct.caption1
                        controller.fromWhich = 0
                        self.present(controller, animated: true, completion: nil)
                        
                    }
                    .action(.default("Remove GIF/Video".localized), image: nil) { (action, ind) in
                        self.selectedImage1.image = self.selectedImage2.image
                        self.selectedImage2.image = self.selectedImage3.image
                        self.selectedImage3.image = self.selectedImage4.image
                        self.selectedImage4.image = nil
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            return
                        }
                    }
                    .popover(anchorView: self.selectedImage1)
                    .show(on: self)
                
            } else {
        
        Alertift.actionSheet(title: nil, message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("View Image".localized), image: nil) { (action, ind) in
                let originImage = self.selectedImage1.image
                var images = [SKPhoto]()
                let photo = SKPhoto.photoWithImage(self.selectedImage1.image!)
                images.append(photo)
                let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: sender.view)
                browser.initializePageIndex(0)
                self.present(browser, animated: true, completion: {})
            }
            .action(.default("Filter Image".localized), image: nil) { (action, ind) in
                self.filterFromWhichImage = 0
                let imageToBeFiltered = self.selectedImage1.image!
                let vc = SHViewController(image: imageToBeFiltered)
                vc.delegate = self
                self.present(vc, animated:true, completion: nil)
            }
            .action(.default("Edit Caption".localized), image: nil) { (action, ind) in
                
                let controller = NewCaptionViewController()
                controller.editListName = StoreStruct.caption1
                controller.fromWhich = 0
                self.present(controller, animated: true, completion: nil)
                
            }
            .action(.default("Remove Image".localized), image: nil) { (action, ind) in
                self.selectedImage1.image = self.selectedImage2.image
                self.selectedImage2.image = self.selectedImage3.image
                self.selectedImage3.image = self.selectedImage4.image
                self.selectedImage4.image = nil
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.selectedImage1)
            .show(on: self)
                
            }
        
        }
    }
    @objc func tappedImageView2(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        Alertift.actionSheet(title: nil, message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("View Image".localized), image: nil) { (action, ind) in
        let originImage = self.selectedImage2.image
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(self.selectedImage2.image!)
        images.append(photo)
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: sender.view)
        browser.initializePageIndex(0)
        self.present(browser, animated: true, completion: {})
                
            }
            .action(.default("Filter Image".localized), image: nil) { (action, ind) in
                self.filterFromWhichImage = 1
                let imageToBeFiltered = self.selectedImage2.image!
                let vc = SHViewController(image: imageToBeFiltered)
                vc.delegate = self
                self.present(vc, animated:true, completion: nil)
            }
            .action(.default("Edit Caption".localized), image: nil) { (action, ind) in
                
                let controller = NewCaptionViewController()
                controller.editListName = StoreStruct.caption2
                controller.fromWhich = 1
                self.present(controller, animated: true, completion: nil)
                
            }
            .action(.default("Remove Image".localized), image: nil) { (action, ind) in
                self.selectedImage2.image = self.selectedImage3.image
                self.selectedImage3.image = self.selectedImage4.image
                self.selectedImage4.image = nil
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.selectedImage2)
            .show(on: self)
        
    }
    @objc func tappedImageView3(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        Alertift.actionSheet(title: nil, message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("View Image".localized), image: nil) { (action, ind) in
        let originImage = self.selectedImage3.image
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(self.selectedImage3.image!)
        images.append(photo)
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: sender.view)
        browser.initializePageIndex(0)
        self.present(browser, animated: true, completion: {})
            }
            .action(.default("Filter Image".localized), image: nil) { (action, ind) in
                self.filterFromWhichImage = 2
                let imageToBeFiltered = self.selectedImage3.image!
                let vc = SHViewController(image: imageToBeFiltered)
                vc.delegate = self
                self.present(vc, animated:true, completion: nil)
            }
            .action(.default("Edit Caption".localized), image: nil) { (action, ind) in
                
                let controller = NewCaptionViewController()
                controller.editListName = StoreStruct.caption3
                controller.fromWhich = 2
                self.present(controller, animated: true, completion: nil)
                
            }
            .action(.default("Remove Image".localized), image: nil) { (action, ind) in
                self.selectedImage3.image = self.selectedImage4.image
                self.selectedImage4.image = nil
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.selectedImage3)
            .show(on: self)
    }
    @objc func tappedImageView4(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        Alertift.actionSheet(title: nil, message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("View Image".localized), image: nil) { (action, ind) in
        let originImage = self.selectedImage4.image
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(self.selectedImage4.image!)
        images.append(photo)
        let browser = SKPhotoBrowser(originImage: originImage ?? UIImage(), photos: images, animatedFromView: sender.view)
        browser.initializePageIndex(0)
        self.present(browser, animated: true, completion: {})
            }
            .action(.default("Filter Image".localized), image: nil) { (action, ind) in
                self.filterFromWhichImage = 3
                let imageToBeFiltered = self.selectedImage4.image!
                let vc = SHViewController(image: imageToBeFiltered)
                vc.delegate = self
                self.present(vc, animated:true, completion: nil)
            }
            .action(.default("Edit Caption".localized), image: nil) { (action, ind) in
                
                let controller = NewCaptionViewController()
                controller.editListName = StoreStruct.caption4
                controller.fromWhich = 3
                self.present(controller, animated: true, completion: nil)
                
            }
            .action(.cancel("Dismiss"))
            .action(.default("Remove Image".localized), image: nil) { (action, ind) in
                self.selectedImage4.image = nil
            }
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.selectedImage4)
            .show(on: self)
    }
    
    
    
    
    
    @objc func panButton1(pan: UIPanGestureRecognizer) {
        if self.isPollAdded {
            
            if pan.state == .began {
                buttonCenter = self.selectedImage1.center
                self.view.bringSubviewToFront(self.selectedImage1)
                self.textView.resignFirstResponder()
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.bgView.backgroundColor = Colours.red
                    self.removeLabel.alpha = 1
                    self.cameraButton.alpha = 0
                    self.visibilityButton.alpha = 0
                    self.warningButton.alpha = 0
                    self.emotiButton.alpha = 0
                    self.cameraCollectionView.alpha = 0
                    self.galPickButton.alpha = 0
                    self.camPickButton.alpha = 0
                })
            } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
                
                self.selectedImage1.image = nil
                self.selectedImage2.image = nil
                self.selectedImage3.image = nil
                self.selectedImage4.image = nil
                StoreStruct.currentOptions = []
                StoreStruct.expiresIn = 86400
                StoreStruct.allowsMultiple = false
                StoreStruct.totalsHidden = false
                StoreStruct.newPollPost = []
                self.isPollAdded = false
                
                let location = pan.location(in: view)
                if location.y > CGFloat(self.view.bounds.height) - CGFloat(40) - CGFloat(self.keyHeight) {
                    self.selectedImage1.image = nil
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                        self.selectedImage1.center = self.buttonCenter
                    }, completion: { finished in
                        self.selectedImage1.image = self.selectedImage2.image
                        self.selectedImage2.image = self.selectedImage3.image
                        self.selectedImage3.image = self.selectedImage4.image
                        self.selectedImage4.image = nil
                    })
                } else {
                    springWithDelay(duration: 0.6, delay: 0, animations: {
                        self.selectedImage1.center = self.buttonCenter
                    })
                }
                self.textView.becomeFirstResponder()
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                        self.bgView.backgroundColor = Colours.tabSelected
                    } else {
                        self.bgView.backgroundColor = Colours.white3
                    }
                    self.removeLabel.alpha = 0
                })
            } else {
                let location = pan.location(in: view)
                print(location)
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.selectedImage1.center = location
                })
            }
            
        } else {
        if pan.state == .began {
            buttonCenter = self.selectedImage1.center
            self.view.bringSubviewToFront(self.selectedImage1)
            self.textView.resignFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.bgView.backgroundColor = Colours.red
                self.removeLabel.alpha = 1
                self.cameraButton.alpha = 0
                self.visibilityButton.alpha = 0
                self.warningButton.alpha = 0
                self.emotiButton.alpha = 0
                self.cameraCollectionView.alpha = 0
                self.galPickButton.alpha = 0
                self.camPickButton.alpha = 0
            })
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            let location = pan.location(in: view)
            if location.y > CGFloat(self.view.bounds.height) - CGFloat(40) - CGFloat(self.keyHeight) {
                self.selectedImage1.image = nil
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                    self.selectedImage1.center = self.buttonCenter
                }, completion: { finished in
                    self.selectedImage1.image = self.selectedImage2.image
                    self.selectedImage2.image = self.selectedImage3.image
                    self.selectedImage3.image = self.selectedImage4.image
                    self.selectedImage4.image = nil
                })
            } else {
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.selectedImage1.center = self.buttonCenter
                })
            }
            self.textView.becomeFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                    self.bgView.backgroundColor = Colours.tabSelected
                } else {
                    self.bgView.backgroundColor = Colours.white3
                }
                self.removeLabel.alpha = 0
            })
        } else {
            let location = pan.location(in: view)
            print(location)
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.selectedImage1.center = location
            })
        }
        }
    }
    
    @objc func panButton2(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            buttonCenter = self.selectedImage2.center
            self.view.bringSubviewToFront(self.selectedImage2)
            self.textView.resignFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.bgView.backgroundColor = Colours.red
                self.removeLabel.alpha = 1
                self.cameraButton.alpha = 0
                self.visibilityButton.alpha = 0
                self.warningButton.alpha = 0
                self.emotiButton.alpha = 0
                self.cameraCollectionView.alpha = 0
                self.galPickButton.alpha = 0
                self.camPickButton.alpha = 0
            })
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            let location = pan.location(in: view)
            if location.y > CGFloat(self.view.bounds.height) - CGFloat(40) - CGFloat(self.keyHeight) {
                self.selectedImage2.image = nil
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                    self.selectedImage2.center = self.buttonCenter
                }, completion: { finished in
                    self.selectedImage2.image = self.selectedImage3.image
                    self.selectedImage3.image = self.selectedImage4.image
                    self.selectedImage4.image = nil
                })
                
            } else {
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.selectedImage2.center = self.buttonCenter
                })
            }
            self.textView.becomeFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                    self.bgView.backgroundColor = Colours.tabSelected
                } else {
                    self.bgView.backgroundColor = Colours.white3
                }
                self.removeLabel.alpha = 0
            })
        } else {
            let location = pan.location(in: view)
            print(location)
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.selectedImage2.center = location
            })
        }
    }
    
    @objc func panButton3(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            buttonCenter = self.selectedImage3.center
            self.view.bringSubviewToFront(self.selectedImage3)
            self.textView.resignFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.bgView.backgroundColor = Colours.red
                self.removeLabel.alpha = 1
                self.cameraButton.alpha = 0
                self.visibilityButton.alpha = 0
                self.warningButton.alpha = 0
                self.emotiButton.alpha = 0
                self.cameraCollectionView.alpha = 0
                self.galPickButton.alpha = 0
                self.camPickButton.alpha = 0
            })
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            let location = pan.location(in: view)
            if location.y > CGFloat(self.view.bounds.height) - CGFloat(40) - CGFloat(self.keyHeight) {
                self.selectedImage3.image = nil
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                    self.selectedImage3.center = self.buttonCenter
                }, completion: { finished in
                    self.selectedImage3.image = self.selectedImage4.image
                    self.selectedImage4.image = nil
                })
            } else {
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.selectedImage3.center = self.buttonCenter
                })
            }
            self.textView.becomeFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                    self.bgView.backgroundColor = Colours.tabSelected
                } else {
                    self.bgView.backgroundColor = Colours.white3
                }
                self.removeLabel.alpha = 0
            })
        } else {
            let location = pan.location(in: view)
            print(location)
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.selectedImage3.center = location
            })
        }
    }
    
    @objc func panButton4(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            buttonCenter = self.selectedImage4.center
            self.view.bringSubviewToFront(self.selectedImage4)
            self.textView.resignFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.bgView.backgroundColor = Colours.red
                self.removeLabel.alpha = 1
                self.cameraButton.alpha = 0
                self.visibilityButton.alpha = 0
                self.warningButton.alpha = 0
                self.emotiButton.alpha = 0
                self.cameraCollectionView.alpha = 0
                self.galPickButton.alpha = 0
                self.camPickButton.alpha = 0
            })
        } else if pan.state == .ended || pan.state == .failed || pan.state == .cancelled {
            let location = pan.location(in: view)
            if location.y > CGFloat(self.view.bounds.height) - CGFloat(40) - CGFloat(self.keyHeight) {
                self.selectedImage4.image = nil
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.selectedImage4.center = self.buttonCenter
                })
            } else {
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.selectedImage4.center = self.buttonCenter
                })
            }
            self.textView.becomeFirstResponder()
            springWithDelay(duration: 0.6, delay: 0, animations: {
                if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
                    self.bgView.backgroundColor = Colours.tabSelected
                } else {
                    self.bgView.backgroundColor = Colours.white3
                }
                self.removeLabel.alpha = 0
            })
        } else {
            let location = pan.location(in: view)
            print(location)
            springWithDelay(duration: 0.6, delay: 0, animations: {
                self.selectedImage4.center = location
            })
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        StoreStruct.spoilerText = self.textField.text ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        StoreStruct.currentPage = 587
        textView.becomeFirstResponder()
        
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        var botbot = 20
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
                botbot = 40
            case 2436, 1792:
                offset = 88
                closeB = 47
                botbot = 40
            default:
                offset = 64
                closeB = 24
                botbot = 20
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            print("nothing")
        case .pad:
            self.closeButton.frame = CGRect(x: 20, y: 30, width: 32, height: 32)
            self.avatarButton.frame = CGRect(x: 70, y: 30, width: 32, height: 32)
            countLabel.frame = CGRect(x: CGFloat(self.view.bounds.width/2 - 50), y: CGFloat(30), width: CGFloat(100), height: CGFloat(36))
            tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(30), width: CGFloat(150), height: CGFloat(36))
            textView.frame = CGRect(x:20, y: (70), width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(170) - Int(self.keyHeight))
        default:
            print("nothing")
        }
        
        if StoreStruct.composedTootText != "" {
            self.textView.text = StoreStruct.composedTootText
            StoreStruct.composedTootText = ""
        }
        
        // images
        
        if self.isPollAdded {} else {
        self.selectedImage1.frame = CGRect(x:15, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight) - 55, width: 40, height: 40)
        self.selectedImage1.backgroundColor = Colours.clear
        self.selectedImage1.layer.cornerRadius = 8
        self.selectedImage1.layer.masksToBounds = true
        self.selectedImage1.contentMode = .scaleAspectFill
        self.selectedImage1.alpha = 1
                let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageView1(_:)))
                self.selectedImage1.addGestureRecognizer(recognizer1)
                let pan1 = UIPanGestureRecognizer(target: self, action: #selector(self.panButton1(pan:)))
                self.selectedImage1.addGestureRecognizer(pan1)
        self.view.addSubview(self.selectedImage1)
        }
        
        self.selectedImage2.frame = CGRect(x:70, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight) - 55, width: 40, height: 40)
        self.selectedImage2.backgroundColor = Colours.clear
        self.selectedImage2.layer.cornerRadius = 8
        self.selectedImage2.layer.masksToBounds = true
        self.selectedImage2.contentMode = .scaleAspectFill
        self.selectedImage2.alpha = 1
                let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageView2(_:)))
                self.selectedImage2.addGestureRecognizer(recognizer2)
                let pan2 = UIPanGestureRecognizer(target: self, action: #selector(self.panButton2(pan:)))
                self.selectedImage2.addGestureRecognizer(pan2)
        self.view.addSubview(self.selectedImage2)
        
        self.selectedImage3.frame = CGRect(x:125, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight) - 55, width: 40, height: 40)
        self.selectedImage3.backgroundColor = Colours.clear
        self.selectedImage3.layer.cornerRadius = 8
        self.selectedImage3.layer.masksToBounds = true
        self.selectedImage3.contentMode = .scaleAspectFill
        self.selectedImage3.alpha = 1
                let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageView3(_:)))
                self.selectedImage3.addGestureRecognizer(recognizer3)
                let pan3 = UIPanGestureRecognizer(target: self, action: #selector(self.panButton3(pan:)))
                self.selectedImage3.addGestureRecognizer(pan3)
        self.view.addSubview(self.selectedImage3)
        
        self.selectedImage4.frame = CGRect(x:180, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight) - 55, width: 40, height: 40)
        self.selectedImage4.backgroundColor = Colours.clear
        self.selectedImage4.layer.cornerRadius = 8
        self.selectedImage4.layer.masksToBounds = true
        self.selectedImage4.contentMode = .scaleAspectFill
        self.selectedImage4.alpha = 1
                let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(self.tappedImageView4(_:)))
                self.selectedImage4.addGestureRecognizer(recognizer4)
                let pan4 = UIPanGestureRecognizer(target: self, action: #selector(self.panButton4(pan:)))
                self.selectedImage4.addGestureRecognizer(pan4)
        self.view.addSubview(self.selectedImage4)
        
        
        self.removeLabel.frame = CGRect(x:Int(self.view.bounds.width/2 - 125), y:((Int(self.keyHeight) + 40) / 2) - 25, width:250, height:50)
        self.removeLabel.text = "Drop here to remove"
        self.removeLabel.textColor = UIColor.white
        self.removeLabel.textAlignment = .center
        self.removeLabel.font = UIFont.systemFont(ofSize: 18)
        self.removeLabel.alpha = 0
        self.bgView.addSubview(self.removeLabel)
        
    }
    
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.paste(_:)) {
            return UIPasteboard.general.string != nil || UIPasteboard.general.image != nil
        }
        
        let menuController = UIMenuController.shared
        menuController.menuItems = [
            UIMenuItem(
                title: "Bold",
                action: #selector(self.bText)
            ),
            UIMenuItem(
                title: "Italics",
                action: #selector(self.iText)
            ),
            UIMenuItem(
                title: "Monospace",
                action: #selector(self.mText)
            ),
            UIMenuItem(
                title: "Handwritten",
                action: #selector(self.hText)
            ),
            UIMenuItem(
                title: "Fraktur",
                action: #selector(self.fText)
            ),
            UIMenuItem(
                title: "Bubble",
                action: #selector(self.b2Text)
            ),
            UIMenuItem(
                title: "Filled Bubble",
                action: #selector(self.fbText)
            ),
            UIMenuItem(
                title: "Double Stroke",
                action: #selector(self.dsText)
            ),
            UIMenuItem(
                title: "Clear Styling",
                action: #selector(self.clText)
            )
        ]
        return super.canPerformAction(action, withSender: sender)
    }
    
    @objc func bText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let boldT = TextStyling().boldTheText(string: self.textView.text)
                self.textView.text = boldT
            } else {
                let boldT = TextStyling().boldTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: boldT)
            }
        }
    }
    
    @objc func iText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let itaT = TextStyling().italicsTheText(string: self.textView.text)
                self.textView.text = itaT
            } else {
                let itaT = TextStyling().italicsTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: itaT)
            }
        }
    }
    
    @objc func mText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let monoT = TextStyling().monoTheText(string: self.textView.text)
                self.textView.text = monoT
            } else {
                let monoT = TextStyling().monoTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
            }
        }
    }
    
    @objc func hText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let monoT = TextStyling().handwriteTheText(string: self.textView.text)
                self.textView.text = monoT
            } else {
                let monoT = TextStyling().handwriteTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
            }
        }
    }
    
    @objc func fText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let monoT = TextStyling().frakturTheText(string: self.textView.text)
                self.textView.text = monoT
            } else {
                let monoT = TextStyling().frakturTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
            }
        }
    }
    
    @objc func b2Text() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let monoT = TextStyling().bubbleTheText(string: self.textView.text)
                self.textView.text = monoT
            } else {
                let monoT = TextStyling().bubbleTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
            }
        }
    }
    
    @objc func fbText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let monoT = TextStyling().bubbleTheText2(string: self.textView.text)
                self.textView.text = monoT
            } else {
                let monoT = TextStyling().bubbleTheText2(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
            }
        }
    }
    
    @objc func dsText() {
        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
            if selectedText == "" {
                let monoT = TextStyling().doubleTheText(string: self.textView.text)
                self.textView.text = monoT
            } else {
                let monoT = TextStyling().doubleTheText(string: selectedText)
                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
            }
        }
    }
    
    @objc func clText() {
        self.clearTheText()
    }
    
    @objc override func paste(_ sender: Any?) {
        let pasteboard = UIPasteboard.general
        if pasteboard.hasImages {
            
            print("has image")
            print(pasteboard.image)
            
            if self.selectedImage1.image == nil {
                self.selectedImage1.image = pasteboard.image
                self.selectedImage1.isUserInteractionEnabled = true
                self.selectedImage1.contentMode = .scaleAspectFill
                self.selectedImage1.layer.masksToBounds = true
            } else if self.selectedImage2.image == nil {
                self.selectedImage2.image = pasteboard.image
                self.selectedImage2.isUserInteractionEnabled = true
                self.selectedImage2.contentMode = .scaleAspectFill
                self.selectedImage2.layer.masksToBounds = true
            } else if self.selectedImage3.image == nil {
                self.selectedImage3.image = pasteboard.image
                self.selectedImage3.isUserInteractionEnabled = true
                self.selectedImage3.contentMode = .scaleAspectFill
                self.selectedImage3.layer.masksToBounds = true
            } else if self.selectedImage4.image == nil {
                self.selectedImage4.image = pasteboard.image
                self.selectedImage4.isUserInteractionEnabled = true
                self.selectedImage4.contentMode = .scaleAspectFill
                self.selectedImage4.layer.masksToBounds = true
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        print(picker.selectedDateString)
    }
    
    @objc func doneDate() {
        self.picker.removeFromSuperview()
        self.textView.becomeFirstResponder()
    }
    
    @objc func addedPoll() {
        self.isPollAdded = true
        self.selectedImage1.isUserInteractionEnabled = true
        self.selectedImage1.contentMode = .scaleAspectFit
        self.selectedImage1.layer.masksToBounds = true
        self.selectedImage1.image = UIImage(named: "list")
        self.selectedImage2.image = nil
        self.selectedImage3.image = nil
        self.selectedImage4.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StoreStruct.spoilerText = ""
        StoreStruct.holdOnTempText = ""
        StoreStruct.currentOptions = []
        StoreStruct.expiresIn = 86400
        StoreStruct.allowsMultiple = false
        StoreStruct.totalsHidden = false
        StoreStruct.newPollPost = []
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneDate), name: NSNotification.Name(rawValue: "doneDate"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.actOnSpecialNotificationAuto), name: NSNotification.Name(rawValue: "cpick"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addedPoll), name: NSNotification.Name(rawValue: "addedPoll"), object: nil)
        
        self.view.backgroundColor = Colours.white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        var botbot = 20
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
                botbot = 40
            case 2436, 1792:
                offset = 88
                closeB = 47
                botbot = 40
            default:
                offset = 64
                closeB = 24
                botbot = 20
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
        
        bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 40 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 40)
        if (UserDefaults.standard.object(forKey: "barhue1") == nil) || (UserDefaults.standard.object(forKey: "barhue1") as! Int == 0) {
            bgView.backgroundColor = Colours.tabSelected
        } else {
            bgView.backgroundColor = Colours.white3
        }
        self.view.addSubview(bgView)
        
        
        
        self.tableView.register(FollowersCell.self, forCellReuseIdentifier: "cellfolfol")
        self.tableView.frame = CGRect(x: 0, y: 0, width: Int(self.view.bounds.width), height: Int(180))
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = Colours.clear
        self.tableView.separatorColor = Colours.clear
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        self.bgView.addSubview(self.tableView)
        
        if UserDefaults.standard.object(forKey: "savedDrafts") != nil {
            StoreStruct.drafts = UserDefaults.standard.object(forKey: "savedDrafts") as! [String]
            print("dr1")
            print(StoreStruct.drafts)
        }
        self.tableViewDrafts.register(UITableViewCell.self, forCellReuseIdentifier: "TweetCellDraft")
        self.tableViewDrafts.frame = CGRect(x: 0, y: 60, width: Int(self.view.bounds.width), height: Int(self.bgView.bounds.height - 60))
        self.tableViewDrafts.alpha = 0
        self.tableViewDrafts.delegate = self
        self.tableViewDrafts.dataSource = self
        self.tableViewDrafts.separatorStyle = .singleLine
        self.tableViewDrafts.backgroundColor = Colours.clear
        self.tableViewDrafts.separatorColor = Colours.clear
        self.tableViewDrafts.layer.masksToBounds = true
        self.tableViewDrafts.estimatedRowHeight = 89
        self.tableViewDrafts.rowHeight = UITableView.automaticDimension
        self.tableViewDrafts.reloadData()
        self.bgView.addSubview(self.tableViewDrafts)
        
        self.tableViewASCII.register(UITableViewCell.self, forCellReuseIdentifier: "TweetCellASCII")
        self.tableViewASCII.frame = CGRect(x: 0, y: 60, width: Int(self.view.bounds.width), height: Int(self.bgView.bounds.height - 60))
        self.tableViewASCII.alpha = 0
        self.tableViewASCII.delegate = self
        self.tableViewASCII.dataSource = self
        self.tableViewASCII.separatorStyle = .singleLine
        self.tableViewASCII.backgroundColor = Colours.clear
        self.tableViewASCII.separatorColor = Colours.clear
        self.tableViewASCII.layer.masksToBounds = true
        self.tableViewASCII.estimatedRowHeight = 89
        self.tableViewASCII.rowHeight = UITableView.automaticDimension
        self.tableViewASCII.reloadData()
        self.bgView.addSubview(self.tableViewASCII)
        
        self.tableViewEmoti.register(UITableViewCell.self, forCellReuseIdentifier: "TweetCellEmoti")
        self.tableViewEmoti.frame = CGRect(x: 0, y: 60, width: Int(self.view.bounds.width), height: Int(self.bgView.bounds.height - 60))
        self.tableViewEmoti.alpha = 0
        self.tableViewEmoti.delegate = self
        self.tableViewEmoti.dataSource = self
        self.tableViewEmoti.separatorStyle = .singleLine
        self.tableViewEmoti.backgroundColor = Colours.clear
        self.tableViewEmoti.separatorColor = Colours.clear
        self.tableViewEmoti.layer.masksToBounds = true
        self.tableViewEmoti.estimatedRowHeight = 89
        self.tableViewEmoti.rowHeight = UITableView.automaticDimension
        self.tableViewEmoti.reloadData()
        self.bgView.addSubview(self.tableViewEmoti)
        self.tableViewEmoti.reloadData()
        
        self.textField.frame = CGRect(x: 20, y: 0, width: self.view.bounds.width - 40, height: 50)
        self.textField.backgroundColor = UIColor.clear
        self.textField.tintColor = Colours.tabSelected2
        self.textField.textColor = UIColor.white
        self.textField.keyboardAppearance = Colours.keyCol
        self.textField.placeholder = "Content warning...".localized
        self.textField.alpha = 0
        self.bgView.addSubview(self.textField)
        
        self.cameraButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 10, y: 0, width: 50, height: 50)))
        self.cameraButton.setImage(UIImage(named: "frame1")?.maskWithColor(color: UIColor.white), for: .normal)
        self.cameraButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.cameraButton.adjustsImageWhenHighlighted = false
        self.cameraButton.addTarget(self, action: #selector(didTouchUpInsideCameraButton), for: .touchUpInside)
        self.bgView.addSubview(self.cameraButton)
        
        self.visibilityButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 60, y: 0, width: 80, height: 50)))
        
        if inReply.count > 0 {
            self.textField.text = inReply[0].spoilerText
            if self.textField.text != "" {
                self.isSensitive = true
            }
            
            if inReply[0].visibility == .direct {
                self.visibility = .direct
                self.visibilityButton.setImage(UIImage(named: "direct")?.maskWithColor(color: UIColor.white), for: .normal)
            } else {
                
                
                if inReply[0].visibility == .public {
                    self.visibility = .public
                    self.visibilityButton.setImage(UIImage(named: "eye")?.maskWithColor(color: UIColor.white), for: .normal)
                } else if inReply[0].visibility == .unlisted {
                    self.visibility = .unlisted
                    self.visibilityButton.setImage(UIImage(named: "unlisted")?.maskWithColor(color: UIColor.white), for: .normal)
                } else if inReply[0].visibility == .private {
                    self.visibility = .private
                    self.visibilityButton.setImage(UIImage(named: "private")?.maskWithColor(color: UIColor.white), for: .normal)
                } else {
                    self.visibility = .direct
                    self.visibilityButton.setImage(UIImage(named: "direct")?.maskWithColor(color: UIColor.white), for: .normal)
                }
                
                
            }
        } else {
        
        if (UserDefaults.standard.object(forKey: "privToot") == nil) || (UserDefaults.standard.object(forKey: "privToot") as! Int == 0) {
            self.visibility = .public
            self.visibilityButton.setImage(UIImage(named: "eye")?.maskWithColor(color: UIColor.white), for: .normal)
        } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 1) {
            self.visibility = .unlisted
            self.visibilityButton.setImage(UIImage(named: "unlisted")?.maskWithColor(color: UIColor.white), for: .normal)
        } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 2) {
            self.visibility = .private
            self.visibilityButton.setImage(UIImage(named: "private")?.maskWithColor(color: UIColor.white), for: .normal)
        } else if (UserDefaults.standard.object(forKey: "privToot") as! Int == 3) {
            self.visibility = .direct
            self.visibilityButton.setImage(UIImage(named: "direct")?.maskWithColor(color: UIColor.white), for: .normal)
        }
            
        }
        
        
        self.visibilityButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.visibilityButton.adjustsImageWhenHighlighted = false
        self.visibilityButton.addTarget(self, action: #selector(didTouchUpInsideVisibilityButton), for: .touchUpInside)
        self.bgView.addSubview(self.visibilityButton)
        
        self.warningButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: 138, y: -4, width: 50, height: 58)))
        self.warningButton.setImage(UIImage(named: "reporttiny")?.maskWithColor(color: UIColor.white), for: .normal)
        self.warningButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 2, right: 4)
        self.warningButton.adjustsImageWhenHighlighted = false
        self.warningButton.addTarget(self, action: #selector(didTouchUpInsideWarningButton), for: .touchUpInside)
        self.bgView.addSubview(self.warningButton)
        
        self.emotiButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: self.view.bounds.width - 60, y: 0, width: 50, height: 50)))
        self.emotiButton.setImage(UIImage(named: "more")?.maskWithColor(color: UIColor.white), for: .normal)
        self.emotiButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.emotiButton.adjustsImageWhenHighlighted = false
        self.emotiButton.addTarget(self, action: #selector(didTouchUpInsideEmotiButton), for: .touchUpInside)
        self.bgView.addSubview(self.emotiButton)
        
        let layout = ColumnFlowLayout(
            cellsPerRow: 4,
            minimumInteritemSpacing: 15,
            minimumLineSpacing: 15,
            sectionInset: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        )
        layout.scrollDirection = .horizontal
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cameraCollectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(50), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(310)), collectionViewLayout: layout)
        } else {
            cameraCollectionView = UICollectionView(frame: CGRect(x: CGFloat(0), y: CGFloat(50), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(210)), collectionViewLayout: layout)
        }
        
        cameraCollectionView.backgroundColor = Colours.clear
        cameraCollectionView.delegate = self
        cameraCollectionView.dataSource = self
        cameraCollectionView.showsHorizontalScrollIndicator = false
        cameraCollectionView.register(CollectionProfileCell.self, forCellWithReuseIdentifier: "CollectionProfileCellc")
        self.bgView.addSubview(cameraCollectionView)
        
        self.camPickButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: CGFloat(20), y: CGFloat(self.view.bounds.height) - CGFloat(botbot) - CGFloat(60), width: CGFloat(self.view.bounds.width/2 - 30), height: CGFloat(60))))
        self.camPickButton.setTitle("Camera".localized, for: .normal)
        self.camPickButton.setTitleColor(UIColor.white, for: .normal)
        self.camPickButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.camPickButton.layer.cornerRadius = 22
        self.camPickButton.adjustsImageWhenHighlighted = false
        self.camPickButton.addTarget(self, action: #selector(didTouchUpInsideCamPickButton), for: .touchUpInside)
        self.camPickButton.alpha = 0
        self.view.addSubview(self.camPickButton)
        
        self.galPickButton = MNGExpandedTouchAreaButton(frame:(CGRect(x: CGFloat(10) + CGFloat(self.view.bounds.width/2), y: CGFloat(self.view.bounds.height) - CGFloat(botbot) - CGFloat(60), width: CGFloat(self.view.bounds.width/2 - 30), height: CGFloat(60))))
        self.galPickButton.setTitle("Gallery".localized, for: .normal)
        self.galPickButton.setTitleColor(UIColor.white, for: .normal)
        self.galPickButton.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.galPickButton.layer.cornerRadius = 22
        self.galPickButton.adjustsImageWhenHighlighted = false
        self.galPickButton.addTarget(self, action: #selector(didTouchUpInsideGalPickButton), for: .touchUpInside)
        self.galPickButton.alpha = 0
        self.view.addSubview(self.galPickButton)
        
        
        
        
        
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            self.closeButton.frame = CGRect(x: 20, y: closeB, width: 32, height: 32)
            self.avatarButton.frame = CGRect(x: 70, y: closeB, width: 32, height: 32)
            countLabel.frame = CGRect(x: CGFloat(self.view.bounds.width/2 - 50), y: CGFloat(closeB), width: CGFloat(100), height: CGFloat(36))
            tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(closeB), width: CGFloat(150), height: CGFloat(36))
            textView.frame = CGRect(x:20, y: offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(160) - Int(self.keyHeight))
        case .pad:
            self.closeButton.frame = CGRect(x: 20, y: 30, width: 32, height: 32)
            self.avatarButton.frame = CGRect(x: 70, y: 30, width: 32, height: 32)
            countLabel.frame = CGRect(x: CGFloat(self.view.bounds.width/2 - 50), y: CGFloat(30), width: CGFloat(100), height: CGFloat(36))
            tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(30), width: CGFloat(150), height: CGFloat(36))
            textView.frame = CGRect(x:20, y: (70), width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(170) - Int(self.keyHeight))
        default:
            self.closeButton.frame = CGRect(x: 20, y: closeB, width: 32, height: 32)
            self.avatarButton.frame = CGRect(x: 70, y: closeB, width: 32, height: 32)
            countLabel.frame = CGRect(x: CGFloat(self.view.bounds.width/2 - 50), y: CGFloat(closeB), width: CGFloat(100), height: CGFloat(36))
            tootLabel.frame = CGRect(x: CGFloat(self.view.bounds.width - 175), y: CGFloat(closeB), width: CGFloat(150), height: CGFloat(36))
            textView.frame = CGRect(x:20, y: offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(160) - Int(self.keyHeight))
        }
        
        
        if StoreStruct.currentUser != nil {
            self.avatarButton.pin_setImage(from: URL(string: "\(StoreStruct.currentUser.avatar)"))
        }
        self.avatarButton.layer.cornerRadius = 16
        self.avatarButton.layer.masksToBounds = true
        self.avatarButton.adjustsImageWhenHighlighted = false
        if (UserDefaults.standard.object(forKey: "compav") == nil) || (UserDefaults.standard.object(forKey: "compav") as! Int == 0) {
            self.avatarButton.alpha = 0
        } else {
            self.avatarButton.alpha = 1
        }
        self.view.addSubview(self.avatarButton)
        
        self.closeButton.setImage(UIImage(named: "block")?.maskWithColor(color: Colours.grayLight2), for: .normal)
        self.closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.closeButton.adjustsImageWhenHighlighted = false
        self.closeButton.addTarget(self, action: #selector(didTouchUpInsideCloseButton), for: .touchUpInside)
        self.view.addSubview(self.closeButton)
        
        countLabel.text = "\(StoreStruct.maxChars)"
        countLabel.textColor = Colours.gray.withAlphaComponent(0.65)
        countLabel.textAlignment = .center
        self.view.addSubview(countLabel)
        
        tootLabel.setTitle("Toot", for: .normal)
        tootLabel.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
//        tootLabel.setTitleColor(Colours.gray.withAlphaComponent(0.65), for: .normal)
        tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
        tootLabel.contentHorizontalAlignment = .right
        tootLabel.addTarget(self, action: #selector(didTouchUpInsideTootButton), for: .touchUpInside)
        self.view.addSubview(tootLabel)
        
        textView.font = UIFont.systemFont(ofSize: Colours.fontSize1 + 2)
        textView.tintColor = Colours.tabSelected
        textView.delegate = self
        textView.becomeFirstResponder()
        if (UserDefaults.standard.object(forKey: "keyb") == nil) || (UserDefaults.standard.object(forKey: "keyb") as! Int == 0) {
            textView.keyboardType = .twitter
        } else {
            textView.keyboardType = .default
        }
        textView.autocorrectionType = .yes
        textView.keyboardAppearance = Colours.keyCol
        textView.backgroundColor = Colours.clear
        textView.textColor = Colours.grayDark
        
        //bhere6
        if self.inReply.isEmpty {
            if self.inReplyText == "" {
                textView.text = self.filledTextFieldText
            } else {
                textView.text = "\(self.filledTextFieldText) "
                self.startRepText = textView.text
            }
        } else {
            let statusAuthor = self.inReply[0].account.acct
            var mentionedAccountsOnStatus = self.inReply[0].mentions.compactMap { $0.acct }
            var allAccounts = [statusAuthor] + (mentionedAccountsOnStatus)
            if mentionedAccountsOnStatus.contains(statusAuthor) {
                mentionedAccountsOnStatus = mentionedAccountsOnStatus.filter{ $0 != statusAuthor }
                allAccounts = [statusAuthor] + (mentionedAccountsOnStatus)
            }
            let goo = allAccounts.map{ "@\($0)" }
            textView.text = goo.reduce("") { $0 + $1 + " " }
            textView.text = textView.text.replacingOccurrences(of: "@\(StoreStruct.currentUser.username)", with: "")
            textView.text = textView.text.replacingOccurrences(of: "  ", with: " ")
            self.startRepText = textView.text
        }
        
        self.view.addSubview(textView)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        textView.addGestureRecognizer(swipeDown)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionProfileCellc", for: indexPath) as! CollectionProfileCell
        if self.images.count > 0 {
        cell.configure()
        cell.imageCountTag.setTitle(self.isVidText[indexPath.row], for: .normal)
        cell.imageCountTag.backgroundColor = self.isVidBG[indexPath.row]
        cell.image.contentMode = .scaleAspectFill
        cell.image.pin_setPlaceholder(with: UIImage(named: "imagebg")?.maskWithColor(color: UIColor(red: 30/250, green: 30/250, blue: 30/250, alpha: 1.0)))
        cell.image.backgroundColor = Colours.white
        cell.image.layer.cornerRadius = 10
        cell.image.layer.masksToBounds = true
        cell.image.layer.borderColor = UIColor.black.cgColor
        cell.image.image = self.images[indexPath.row]
        
            if UIDevice.current.userInterfaceIdiom == .pad {
                cell.image.frame.size.width = 290
                cell.image.frame.size.height = 250
            } else {
                cell.image.frame.size.width = 190
                cell.image.frame.size.height = 150
            }
        
        cell.bgImage.layer.masksToBounds = false
        cell.bgImage.layer.shadowColor = UIColor.black.cgColor
        cell.bgImage.layer.shadowOffset = CGSize(width:0, height:8)
        cell.bgImage.layer.shadowRadius = 12
        cell.bgImage.layer.shadowOpacity = 0.22
        
        cell.backgroundColor = Colours.clear
        
        return cell
        } else {
            cell.backgroundColor = Colours.clear
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        }
        
        if isVidText[indexPath.row] != "" {
            self.isGifVid = true
            var videoURL = URL(string: "")
            self.images2[indexPath.row].getURL { (test) in
                videoURL = test
                do {
                    self.gifVidData = try NSData(contentsOf: videoURL!, options: .mappedIfSafe) as Data
                    DispatchQueue.main.async {
                        self.selectedImage1.image = self.images[indexPath.row]
                        self.selectedImage1.isUserInteractionEnabled = true
                        self.selectedImage1.contentMode = .scaleAspectFill
                        self.selectedImage1.layer.masksToBounds = true
                    }
                } catch {
                    print("err")
                }
            }
            return
        }
        
        if self.selectedImage1.image == nil {
            self.selectedImage1.image = images[indexPath.row]
            self.selectedImage1.isUserInteractionEnabled = true
            self.selectedImage1.contentMode = .scaleAspectFill
            self.selectedImage1.layer.masksToBounds = true
        } else if self.selectedImage2.image == nil {
            self.selectedImage2.image = images[indexPath.row]
            self.selectedImage2.isUserInteractionEnabled = true
            self.selectedImage2.contentMode = .scaleAspectFill
            self.selectedImage2.layer.masksToBounds = true
        } else if self.selectedImage3.image == nil {
            self.selectedImage3.image = images[indexPath.row]
            self.selectedImage3.isUserInteractionEnabled = true
            self.selectedImage3.contentMode = .scaleAspectFill
            self.selectedImage3.layer.masksToBounds = true
        } else if self.selectedImage4.image == nil {
            self.selectedImage4.image = images[indexPath.row]
            self.selectedImage4.isUserInteractionEnabled = true
            self.selectedImage4.contentMode = .scaleAspectFill
            self.selectedImage4.layer.masksToBounds = true
        }
        
    }
    
    
    
    
    
    
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 800, height: 800), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result ?? UIImage()
        })
        return thumbnail
    }
    
    private func getPhotosAndVideos() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 20
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d", PHAssetMediaType.image.rawValue, PHAssetMediaType.video.rawValue)
        let imagesAndVideos = PHAsset.fetchAssets(with: fetchOptions)
        if imagesAndVideos.count == 0 { return }
        var theCount = imagesAndVideos.count
        if imagesAndVideos.count >= 20 {
            theCount = 20
        }
        for x in 0...theCount - 1 {
            if imagesAndVideos[x].mediaType == .video {
                self.isVidText.append("\u{25b6}")
                self.isVidBG.append(Colours.tabSelected)
            } else {
                self.isVidText.append("")
                self.isVidBG.append(Colours.clear)
            }
            self.images2.append(imagesAndVideos.object(at: x))
            self.images.append(self.getAssetThumbnail(asset: imagesAndVideos.object(at: x)))
        }
    }
    
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imag.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.textView.becomeFirstResponder()
            
            print("selected image123 = \(info[UIImagePickerController.InfoKey.mediaType] as? String)")
            print("selected image1233 = \(info[UIImagePickerController.InfoKey.mediaType] as? PHAssetMediaType)")
            
            if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            
                
                if mediaType == "public.movie" || mediaType == kUTTypeGIF as String {
                   
                    let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL
                    do {
                        self.isGifVid = true
                        self.gifVidData = try NSData(contentsOf: videoURL as URL, options: .mappedIfSafe) as Data
                        self.selectedImage1.image = self.thumbnailForVideoAtURL(url: videoURL)
                        self.selectedImage1.isUserInteractionEnabled = true
                        self.selectedImage1.contentMode = .scaleAspectFill
                        self.selectedImage1.layer.masksToBounds = true
                    } catch {
                        print("err")
                        
                        Alertift.actionSheet(title: "Couldn't add GIF or video", message: "Please try again, or try adding a different GIF or video to the toot.")
                            .backgroundColor(Colours.white)
                            .titleTextColor(Colours.grayDark)
                            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                            .messageTextAlignment(.left)
                            .titleTextAlignment(.left)
                            .action(.cancel("Dismiss"))
                            .finally { action, index in
                                if action.style == .cancel {
                                    return
                                }
                            }
                            .popover(anchorView: self.view)
                            .show(on: self)
                    }
                    
                } else {
            StoreStruct.photoNew = info[UIImagePickerController.InfoKey.originalImage] as? UIImage ?? UIImage()
            
            if self.selectedImage1.image == nil {
                self.selectedImage1.image = StoreStruct.photoNew
                self.selectedImage1.isUserInteractionEnabled = true
                self.selectedImage1.contentMode = .scaleAspectFill
                self.selectedImage1.layer.masksToBounds = true
            } else if self.selectedImage2.image == nil {
                self.selectedImage2.image = StoreStruct.photoNew
                self.selectedImage2.isUserInteractionEnabled = true
                self.selectedImage2.contentMode = .scaleAspectFill
                self.selectedImage2.layer.masksToBounds = true
            } else if self.selectedImage3.image == nil {
                self.selectedImage3.image = StoreStruct.photoNew
                self.selectedImage3.isUserInteractionEnabled = true
                self.selectedImage3.contentMode = .scaleAspectFill
                self.selectedImage3.layer.masksToBounds = true
            } else if self.selectedImage4.image == nil {
                self.selectedImage4.image = StoreStruct.photoNew
                self.selectedImage4.isUserInteractionEnabled = true
                self.selectedImage4.contentMode = .scaleAspectFill
                self.selectedImage4.layer.masksToBounds = true
            }
                
                }
            }
        }
    }
    
    @objc func didTouchUpInsideCamPickButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        //let controller = CameraViewController()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //self.show(controller, sender: self)
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    
                    self.imag.delegate = self
                    self.imag.sourceType = UIImagePickerController.SourceType.camera
                    self.imag.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
                    self.imag.allowsEditing = false
                    
                    self.present(self.imag, animated: true, completion: nil)
                }
                
            } else {
                
            }
        }
    }
    
    @objc func didTouchUpInsideGalPickButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count == 0 {
                return
            }
            
            //isvideocheck
            if assets[0].isVideo {
                //self.containsGifVid = true
                assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                    self.selectedImage1.image = image
                })
                
                assets[0].fetchAVAsset(nil, completeBlock: { (avAsset, info) in
                    if let avassetURL = avAsset as? AVURLAsset {
                        //self.completeVidURL = avassetURL.url
                        guard let video1 = try? Data(contentsOf: avassetURL.url) else { return }
                        self.isGifVid = true
                        self.gifVidData = video1
                    }
                })
                
                
            } else {
                //self.containsGifVid = false
                if self.selectedImage1.image == nil {
                    if assets.count > 0 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage1.image = image
                        })
                    }
                    if assets.count > 1 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage1.image = image
                        })
                        assets[1].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage2.image = image
                        })
                    }
                    if assets.count > 2 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage1.image = image
                        })
                        assets[1].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage2.image = image
                        })
                        assets[2].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage3.image = image
                        })
                    }
                    if assets.count > 3 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage1.image = image
                        })
                        assets[1].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage2.image = image
                        })
                        assets[2].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage3.image = image
                        })
                        assets[3].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage4.image = image
                        })
                    }
                    self.selectedImage1.isUserInteractionEnabled = true
                    self.selectedImage2.isUserInteractionEnabled = true
                    self.selectedImage3.isUserInteractionEnabled = true
                    self.selectedImage4.isUserInteractionEnabled = true
                } else if self.selectedImage2.image == nil {
                    if assets.count > 0 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage2.image = image
                        })
                    }
                    if assets.count > 1 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage2.image = image
                        })
                        assets[1].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage3.image = image
                        })
                    }
                    if assets.count > 2 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage2.image = image
                        })
                        assets[1].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage3.image = image
                        })
                        assets[2].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage4.image = image
                        })
                    }
                    self.selectedImage1.isUserInteractionEnabled = true
                    self.selectedImage2.isUserInteractionEnabled = true
                    self.selectedImage3.isUserInteractionEnabled = true
                    self.selectedImage4.isUserInteractionEnabled = true
                } else if self.selectedImage3.image == nil {
                    if assets.count > 0 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage3.image = image
                        })
                    }
                    if assets.count > 1 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage3.image = image
                        })
                        assets[1].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage4.image = image
                        })
                    }
                    self.selectedImage3.isUserInteractionEnabled = true
                } else if self.selectedImage4.image == nil {
                    if assets.count > 0 {
                        assets[0].fetchOriginalImage(true, completeBlock: { image, info in
                            self.selectedImage4.image = image
                        })
                    }
                    self.selectedImage1.isUserInteractionEnabled = true
                    self.selectedImage2.isUserInteractionEnabled = true
                    self.selectedImage3.isUserInteractionEnabled = true
                    self.selectedImage4.isUserInteractionEnabled = true
                }
            }
        }
        pickerController.showsCancelButton = true
        pickerController.maxSelectableCount = 4
        pickerController.allowMultipleTypes = false
        pickerController.allowSwipeToSelect = false
        pickerController.assetType = .allAssets
        self.present(pickerController, animated: true) {}
    }
    
    
    
    @objc func didTouchUpInsideCameraButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
//        PHPhotoLibrary.requestAuthorization({status in
//            if status == .authorized {
//                self.getPhotosAndVideos()
//                DispatchQueue.main.async {
//                    self.cameraCollectionView.reloadData()
//                }
//            } else {
//                print("REQ04")
//            }
//        })
        
        if self.picker.isDescendant(of: self.view) {
            self.picker.removeFromSuperview()
        }
        
        DispatchQueue.main.async {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            DispatchQueue.global(qos: .userInitiated).async {
            self.getPhotosAndVideos()
            DispatchQueue.main.async {
                self.cameraCollectionView.reloadData()
            }
            }
        case .denied, .restricted, .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { (status) -> Void in
                switch status {
                case .authorized:
                    DispatchQueue.global(qos: .userInitiated).async {
                    self.getPhotosAndVideos()
                    DispatchQueue.main.async {
                        self.cameraCollectionView.reloadData()
                    }
                    }
                // as above
                case .denied, .restricted:
                    print("denied")
                    let alert = UIAlertController(title: "Oops!", message: "Couldn't show you your pictures. Allow access via Settings to see them.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                // as above
                case .notDetermined: break
                    // won't happen but still
                }
            }
        }
        }
        
        
        
        
        self.textView.resignFirstResponder()
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.cameraButton.alpha = 1
            self.visibilityButton.alpha = 0.45
            self.warningButton.alpha = 0.45
            self.emotiButton.alpha = 0.45
            self.cameraCollectionView.alpha = 1
            self.camPickButton.alpha = 1
            self.galPickButton.alpha = 1
            self.tableViewDrafts.alpha = 0
            self.tableViewASCII.alpha = 0
            self.tableViewEmoti.alpha = 0
        })
        
        
        
    }
    @objc func didTouchUpInsideVisibilityButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        if self.picker.isDescendant(of: self.view) {
            self.picker.removeFromSuperview()
        }
        
        self.textView.resignFirstResponder()
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.cameraButton.alpha = 0.45
            self.visibilityButton.alpha = 1
            self.warningButton.alpha = 0.45
            self.emotiButton.alpha = 0.45
            self.cameraCollectionView.alpha = 0
            self.tableViewDrafts.alpha = 0
            self.tableViewASCII.alpha = 0
            self.tableViewEmoti.alpha = 0
        })
        
        
        Alertift.actionSheet(title: nil, message: nil)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("Public".localized), image: UIImage(named: "eye")) { (action, ind) in
                print(action, ind)
                self.visibility = .public
                self.visibilityButton.setImage(UIImage(named: "eye"), for: .normal)
                self.bringBackDrawer()
            }
            .action(.default("   Unlisted".localized), image: UIImage(named: "unlisted")) { (action, ind) in
                print(action, ind)
                self.visibility = .unlisted
                self.visibilityButton.setImage(UIImage(named: "unlisted"), for: .normal)
                self.bringBackDrawer()
            }
            .action(.default("   Private".localized), image: UIImage(named: "private")) { (action, ind) in
                print(action, ind)
                self.visibility = .private
                self.visibilityButton.setImage(UIImage(named: "private"), for: .normal)
                self.bringBackDrawer()
            }
            .action(.default("Direct".localized), image: UIImage(named: "direct")) { (action, ind) in
                print(action, ind)
                
                if (UserDefaults.standard.object(forKey: "divisib") == nil) || (UserDefaults.standard.object(forKey: "divisib") as! Int == 0) {
                Alertift.actionSheet(title: "Direct Visibility", message: "Please note that all mentioned users will still see this message. Set direct visibility?")
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark.withAlphaComponent(0.8))
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("Sure!".localized), image: nil) { (action, ind) in
                        print(action, ind)
                        self.visibility = .direct
                        self.visibilityButton.setImage(UIImage(named: "direct"), for: .normal)
                        self.bringBackDrawer()
                    }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            self.bringBackDrawer()
                            return
                        }
                    }
                    .popover(anchorView: self.visibilityButton)
                    .show(on: self)
                } else {
                    self.visibility = .direct
                    self.visibilityButton.setImage(UIImage(named: "direct"), for: .normal)
                    self.bringBackDrawer()
                }
                
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    self.bringBackDrawer()
                    return
                }
            }
            .popover(anchorView: self.visibilityButton)
            .show(on: self)
    }
    @objc func didTouchUpInsideWarningButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        if self.picker.isDescendant(of: self.view) {
            self.picker.removeFromSuperview()
        }
        
        self.textField.becomeFirstResponder()
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.cameraButton.alpha = 0
            self.visibilityButton.alpha = 0
            self.warningButton.alpha = 0
            self.emotiButton.alpha = 0
            self.cameraCollectionView.alpha = 0
            self.textField.alpha = 1
            self.tableViewDrafts.alpha = 0
            self.tableViewASCII.alpha = 0
            self.tableViewEmoti.alpha = 0
        })
    }
    
    @objc func didTouchUpInsideEmotiButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        self.textView.resignFirstResponder()
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.cameraButton.alpha = 0.45
            self.visibilityButton.alpha = 0.45
            self.warningButton.alpha = 0.45
            self.emotiButton.alpha = 1
            self.cameraCollectionView.alpha = 0
            self.tableViewDrafts.alpha = 0
            self.tableViewASCII.alpha = 0
            self.tableViewEmoti.alpha = 0
        })
        
        Alertift.actionSheet(title: nil, message: self.prevTextReply)
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark)
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            
            .action(.default("Text Styles"), image: UIImage(named: "handwritten")) { (action, ind) in
                print(action, ind)
                
                
                Alertift.actionSheet(title: nil, message: self.prevTextReply)
                    .backgroundColor(Colours.white)
                    .titleTextColor(Colours.grayDark)
                    .messageTextColor(Colours.grayDark)
                    .messageTextAlignment(.left)
                    .titleTextAlignment(.left)
                    .action(.default("  Bold Text"), image: UIImage(named: "bold")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let boldT = TextStyling().boldTheText(string: self.textView.text)
                                self.textView.text = boldT
                            } else {
                                let boldT = TextStyling().boldTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: boldT)
                            }
                        }
                        
                    }
                    .action(.default("  Italics Text"), image: UIImage(named: "italics")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let itaT = TextStyling().italicsTheText(string: self.textView.text)
                                self.textView.text = itaT
                            } else {
                                let itaT = TextStyling().italicsTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: itaT)
                            }
                        }
                        
                    }
                    .action(.default("  Monospace Text"), image: UIImage(named: "mono")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let monoT = TextStyling().monoTheText(string: self.textView.text)
                                self.textView.text = monoT
                            } else {
                                let monoT = TextStyling().monoTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
                            }
                        }
                        
                    }
                    .action(.default("Handwritten Text"), image: UIImage(named: "handwritten")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let monoT = TextStyling().handwriteTheText(string: self.textView.text)
                                self.textView.text = monoT
                            } else {
                                let monoT = TextStyling().handwriteTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
                            }
                        }
                        
                    }
                    .action(.default("  Fraktur Text"), image: UIImage(named: "fraktur")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let monoT = TextStyling().frakturTheText(string: self.textView.text)
                                self.textView.text = monoT
                            } else {
                                let monoT = TextStyling().frakturTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
                            }
                        }
                        
                    }
                    .action(.default(" Bubble Text"), image: UIImage(named: "bubblet")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let monoT = TextStyling().bubbleTheText(string: self.textView.text)
                                self.textView.text = monoT
                            } else {
                                let monoT = TextStyling().bubbleTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
                            }
                        }
                        
                    }
                    .action(.default(" Filled Bubble Text"), image: UIImage(named: "bubblet2")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let monoT = TextStyling().bubbleTheText2(string: self.textView.text)
                                self.textView.text = monoT
                            } else {
                                let monoT = TextStyling().bubbleTheText2(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
                            }
                        }
                        
                    }
                    .action(.default("  Double Stroke Text"), image: UIImage(named: "doublestroke")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        if let range = self.textView.selectedTextRange, let selectedText = self.textView.text(in: range) {
                            if selectedText == "" {
                                let monoT = TextStyling().doubleTheText(string: self.textView.text)
                                self.textView.text = monoT
                            } else {
                                let monoT = TextStyling().doubleTheText(string: selectedText)
                                self.textView.text = self.textView.text.replacingOccurrences(of: selectedText, with: monoT)
                            }
                        }
                        
                    }
                    .action(.default(" Clear Text Styling"), image: UIImage(named: "block")) { (action, ind) in
                        print(action, ind)
                        
                        self.bringBackDrawer()
                        self.clearTheText()
                        
                }
                    .action(.cancel("Dismiss"))
                    .finally { action, index in
                        if action.style == .cancel {
                            self.bringBackDrawer()
                            return
                        }
                    }
                    .popover(anchorView: self.emotiButton)
                    .show(on: self)
                
                
                
            }
            .action(.default(" Add Poll"), image: UIImage(named: "list")) { (action, ind) in
                print(action, ind)
                
                let controller = NewPollViewController()
                self.present(controller, animated: true, completion: nil)
            }
            .action(.default("  Add Now Playing"), image: UIImage(named: "music")) { (action, ind) in
                print(action, ind)
                
                
                
                let player = MPMusicPlayerController.systemMusicPlayer
                if let mediaItem = player.nowPlayingItem {
                    let title: String = mediaItem.value(forProperty: MPMediaItemPropertyTitle) as? String ?? ""
                    let albumTitle: String = mediaItem.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String ?? ""
                    let artist: String = mediaItem.value(forProperty: MPMediaItemPropertyArtist) as? String ?? ""
                    
                    print("\(title) on \(albumTitle) by \(artist)")
                    
                    if title == "" {
                        self.textView.becomeFirstResponder()
                    } else {
                        
                        if self.textView.text.count == 0 {
                            self.textView.text = "Listening to \(title), by \(artist) 🎵"
                        } else {
                            self.textView.text = "\(self.textView.text!)\n\nListening to \(title), by \(artist) 🎵"
                        }
                        
                        self.textView.becomeFirstResponder()
                        
                    }
                    
                } else {
                    self.textView.becomeFirstResponder()
                }
                
                
                
            }
            .action(.default("ASCII Text Faces"), image: UIImage(named: "ascii")) { (action, ind) in
                print(action, ind)
                
                if self.picker.isDescendant(of: self.view) {
                    self.picker.removeFromSuperview()
                }
                
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.tableViewASCII.alpha = 1
                })
            }
            .action(.default("Instance Emoticons"), image: UIImage(named: "emoti")) { (action, ind) in
                print(action, ind)
                
                if self.picker.isDescendant(of: self.view) {
                    self.picker.removeFromSuperview()
                }
                
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.tableViewEmoti.alpha = 1
                })
            }
            .action(.default("Sentiment Analysis"), image: UIImage(named: "emoti2")) { (action, ind) in
                print(action, ind)
                
                self.analyzeText()
                
                self.textView.becomeFirstResponder()
                
            }
            .action(.default("Insert GIF"), image: UIImage(named: "giff")) { (action, ind) in
                print(action, ind)
                
                if self.picker.isDescendant(of: self.view) {
                    self.picker.removeFromSuperview()
                }
                
                self.gifCont.delegate = self
//                self.present(self.gifCont, animated: true, completion: nil)
                
                let navController = UINavigationController(rootViewController: self.gifCont)
                navController.navigationBar.barTintColor = Colours.white
                navController.navigationBar.backgroundColor = Colours.white
                self.present(navController, animated:true, completion: nil)
                
            }
            .action(.default("Schedule Toot"), image: UIImage(named: "schedule")) { (action, ind) in
                print(action, ind)
                self.picker.delegate = self
                self.picker.frame = CGRect(x: 0, y: self.view.bounds.height - self.picker.frame.size.height, width: self.view.bounds.width, height: self.picker.frame.size.height)
                self.picker.alpha = 0
                self.view.addSubview(self.picker)
                springWithDelay(duration: 0.5, delay: 0, animations: {
                    self.picker.alpha = 1
                })
                self.picker.completionHandler = { date in
                    print(date.iso8601())
                    self.scheduleTime = date.iso8601()
                    self.isScheduled = true
                }
            }
            .action(.default("Drafts"), image: UIImage(named: "list")) { (action, ind) in
                print(action, ind)
                
                if self.picker.isDescendant(of: self.view) {
                    self.picker.removeFromSuperview()
                }
                
                springWithDelay(duration: 0.6, delay: 0, animations: {
                    self.tableViewDrafts.alpha = 1
                })
            }
            .action(.default("Clear All"), image: UIImage(named: "block")) { (action, ind) in
                print(action, ind)
                
                self.textView.text = ""
                self.bringBackDrawer()
                
            }
            .action(.cancel("Dismiss"))
            .finally { action, index in
                if action.style == .cancel {
                    self.bringBackDrawer()
                    return
                }
            }
            .popover(anchorView: self.emotiButton)
            .show(on: self)
        
        
    }
    
    let picker = DateTimePicker.create(minimumDate: Date().addingTimeInterval(5 * 60), maximumDate: Date().addingTimeInterval(900000 * 60 * 24 * 4))
    
    
    
    
    private var sentiment: SentimentType = .Neutral
    
    private func analyzeText() {
        guard !textView.text.isEmpty else { return }
        
        var request = SentimentAnalysisRequest(type: .Text, parameterValue: textView.text)
        
        request.successHandler = { [unowned self] response in
            self.handleAnalyzedText(response: response)
        }
        
        request.failureHandler = { [unowned self] error in
            //self.presentAlert(withErrorMessage: error.localizedDescription)
        }
        
        request.completionHandler = { [unowned self] in
            //self.footerView.doneButton.enabled = true
        }
        
        request.makeRequest()
    }
    
    private func handleAnalyzedText(response: JSON) {
        // Return early if unable the response has an error.
        guard response["reason"].string == nil else {
            //presentAlert(withErrorMessage: response["reason"].string! + ".")
            return
        }
        
        // Return early if unable to get a valid sentiment from the response.
        guard let sentimentName = response["aggregate"]["sentiment"].string, let nextSentiment = SentimentType(rawValue: sentimentName) else {
            return
        }
        
        // Updates the view for the `nextSentiment`.
        sentiment = nextSentiment
        self.textView.updateWithSentiment(sentiment: sentiment, response: response)
        
    }
    
    
    
    
    func bringBackDrawer() {
        self.textView.becomeFirstResponder()
        springWithDelay(duration: 0.5, delay: 0, animations: {
            self.cameraButton.alpha = 1
            self.visibilityButton.alpha = 1
            self.warningButton.alpha = 1
            self.emotiButton.alpha = 1
            self.cameraCollectionView.alpha = 0
            self.cameraCollectionView.alpha = 0
            self.camPickButton.alpha = 0
            self.galPickButton.alpha = 0
            self.textField.alpha = 0
            self.tableViewDrafts.alpha = 0
            self.tableViewASCII.alpha = 0
            self.tableViewEmoti.alpha = 0
        })
    }
    
    @objc func didTouchUpInsideCloseButton(_ sender: AnyObject) {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        
        if self.textView.text! == "" || self.textView.text! == self.startRepText {
            self.textView.resignFirstResponder()
            
            StoreStruct.caption1 = ""
            StoreStruct.caption2 = ""
            StoreStruct.caption3 = ""
            StoreStruct.caption4 = ""
            
            self.dismiss(animated: true, completion: nil)
        } else {
            showDraft()
        }
    }
    
    @objc func didTouchUpInsideTootButton(_ sender: AnyObject) {
        
        if self.textView.text == "" && self.selectedImage1.image == nil { return }
        
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
        let impact = UIImpactFeedbackGenerator()
        impact.impactOccurred()
        }
        
        var inRep: String = ""
        if self.inReply.count > 0 {
            inRep = self.inReply[0].id
        }
        
        if self.filledTextFieldText == "" {
            
        } else {
            let request = Statuses.delete(id: idToDel)
            StoreStruct.client.run(request) { (statuses) in
                print("deleted")
            }
        }
        
        if self.textField.text != "" {
            StoreStruct.spoilerText = self.textField.text ?? ""
            self.isSensitive = true
        }
        
        var mediaIDs: [String] = []
        let theText = self.textView.text ?? ""
        let theImage1 = self.selectedImage1.image
        let theImage2 = self.selectedImage2.image
        let theImage3 = self.selectedImage3.image
        let theImage4 = self.selectedImage4.image
        
        
        
        var compression: CGFloat = 1
        if (UserDefaults.standard.object(forKey: "imqual") == nil) || (UserDefaults.standard.object(forKey: "imqual") as! Int == 0) {
            compression = 1
        } else if UserDefaults.standard.object(forKey: "imqual") as! Int == 1 {
            compression = 0.78
        } else {
            compression = 0.5
        }
        
        var successMessage = "posted"
        if self.scheduleTime != nil {
            successMessage = "scheduled"
        }
        
        StoreStruct.drafts.append(self.textView.text!)
        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
        
        
        
        
        
        if self.isPollAdded {
            let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, poll: StoreStruct.newPollPost, visibility: self.visibility)
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request0) { (statuses) in
                    print(statuses)
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                    }
                    
                    if statuses.isError && self.scheduleTime != nil {
                        
                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                        
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            StoreStruct.savedComposeText = ""
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Toot Toot!".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Successfully \(successMessage)"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                statusAlert.show()
                            }
                            
                            StoreStruct.caption1 = ""
                            StoreStruct.caption2 = ""
                            StoreStruct.caption3 = ""
                            StoreStruct.caption4 = ""
                        }
                    } else if statuses.isError {
                        DispatchQueue.main.async {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Could not Toot".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Saved to drafts"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                statusAlert.show()
                            }
                        }
                    } else {
                        
                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                        
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            StoreStruct.savedComposeText = ""
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Toot Toot!".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Successfully \(successMessage)"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                                statusAlert.show()
                            }
                            
                            StoreStruct.caption1 = ""
                            StoreStruct.caption2 = ""
                            StoreStruct.caption3 = ""
                            StoreStruct.caption4 = ""
                            
                            if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                                
                            } else {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
                                //                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                            }
                            if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                            }
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                if (UserDefaults.standard.object(forKey: "progprogprogprog") == nil || UserDefaults.standard.object(forKey: "progprogprogprog") as! Int == 0) {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "startindi"), object: self)
                }
                self.textView.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        
        
        
        
        
        
        
        
        
        if self.gifVidData != nil || self.isGifVid {
            print("gifvidnotnil")
            
            let request = Media.upload(media: .gif(self.gifVidData))
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    print(stat.id)
                    mediaIDs.append(stat.id)
                    
                    let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, visibility: self.visibility)
                    DispatchQueue.global(qos: .userInitiated).async {
                        StoreStruct.client.run(request0) { (statuses) in
                            print(statuses)
                            
                            
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                            }
                            if statuses.isError && self.scheduleTime != nil {
                                
                                StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                
                                DispatchQueue.main.async {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    StoreStruct.savedComposeText = ""
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Toot Toot!".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Successfully \(successMessage)"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                    
                                    StoreStruct.caption1 = ""
                                    StoreStruct.caption2 = ""
                                    StoreStruct.caption3 = ""
                                    StoreStruct.caption4 = ""
                                }
                                } else if statuses.isError {
                                DispatchQueue.main.async {
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Could not Toot".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Saved to drafts"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                }
                            } else {
                                
                                StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                            
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                StoreStruct.savedComposeText = ""
                                let statusAlert = StatusAlert()
                                statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                statusAlert.title = "Toot Toot!".localized
                                statusAlert.contentColor = Colours.grayDark
                                statusAlert.message = "Successfully \(successMessage)"
                                if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                
                                StoreStruct.caption1 = ""
                                StoreStruct.caption2 = ""
                                StoreStruct.caption3 = ""
                                StoreStruct.caption4 = ""
                                
                                if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                                    
                                } else {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                                }
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                                }
                            }
                                
                            }
                        }
                    }
                }
            }
            
            
        } else {
        
        
        
        if self.selectedImage4.image != nil {
            let imageData = (theImage1 ?? UIImage()).jpegData(compressionQuality: compression)
            let request = Media.upload(media: .jpeg(imageData))
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    print(stat.id)
                    mediaIDs.append(stat.id)
                    let request4 = Media.updateDescription(description: StoreStruct.caption1, id: stat.id)
                    StoreStruct.client.run(request4) { (statuses) in
                        print(statuses)
                    }
                    
                    
                    let imageData2 = (theImage2 ?? UIImage()).jpegData(compressionQuality: compression)
                    let request2 = Media.upload(media: .jpeg(imageData2))
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            print(stat.id)
                            mediaIDs.append(stat.id)
                            let request5 = Media.updateDescription(description: StoreStruct.caption2, id: stat.id)
                            StoreStruct.client.run(request5) { (statuses) in
                                print(statuses)
                            }
                            
                            
                            let imageData3 = (theImage3 ?? UIImage()).jpegData(compressionQuality: compression)
                            let request3 = Media.upload(media: .jpeg(imageData3))
                            StoreStruct.client.run(request3) { (statuses) in
                                if let stat = (statuses.value) {
                                    print(stat.id)
                                    mediaIDs.append(stat.id)
                                    let request6 = Media.updateDescription(description: StoreStruct.caption3, id: stat.id)
                                    StoreStruct.client.run(request6) { (statuses) in
                                        print(statuses)
                                    }
                                    
                                    
                                    let imageData4 = (theImage4 ?? UIImage()).jpegData(compressionQuality: compression)
                                    let request4 = Media.upload(media: .jpeg(imageData4))
                                    StoreStruct.client.run(request4) { (statuses) in
                                        if let stat = (statuses.value) {
                                            print(stat.id)
                                            mediaIDs.append(stat.id)
                                            let request7 = Media.updateDescription(description: StoreStruct.caption4, id: stat.id)
                                            StoreStruct.client.run(request7) { (statuses) in
                                                print(statuses)
                                            }
                                            
                                            
                                            let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, visibility: self.visibility)
                                            DispatchQueue.global(qos: .userInitiated).async {
                                                StoreStruct.client.run(request0) { (statuses) in
                                                    print(statuses)
                                                    
                                                    DispatchQueue.main.async {
                                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                                                    }
                                                    if statuses.isError && self.scheduleTime != nil {
                                                        
                                                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                                        
                                                        DispatchQueue.main.async {
                                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                                let notification = UINotificationFeedbackGenerator()
                                                                notification.notificationOccurred(.success)
                                                            }
                                                            StoreStruct.savedComposeText = ""
                                                            let statusAlert = StatusAlert()
                                                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                                            statusAlert.title = "Toot Toot!".localized
                                                            statusAlert.contentColor = Colours.grayDark
                                                            statusAlert.message = "Successfully \(successMessage)"
                                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                                            
                                                            StoreStruct.caption1 = ""
                                                            StoreStruct.caption2 = ""
                                                            StoreStruct.caption3 = ""
                                                            StoreStruct.caption4 = ""
                                                        }
                                                        } else if statuses.isError {
                                                        DispatchQueue.main.async {
                                                            let statusAlert = StatusAlert()
                                                            statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                                            statusAlert.title = "Could not Toot".localized
                                                            statusAlert.contentColor = Colours.grayDark
                                                            statusAlert.message = "Saved to drafts"
                                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                                        }
                                                    } else {
                                                        
                                                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                                        
                                                    DispatchQueue.main.async {
                                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                            let notification = UINotificationFeedbackGenerator()
                                                            notification.notificationOccurred(.success)
                                                        }
                                                        StoreStruct.savedComposeText = ""
                                                        let statusAlert = StatusAlert()
                                                        statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                                        statusAlert.title = "Toot Toot!".localized
                                                        statusAlert.contentColor = Colours.grayDark
                                                        statusAlert.message = "Successfully \(successMessage)"
                                                        if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                                        
                                                        StoreStruct.caption1 = ""
                                                        StoreStruct.caption2 = ""
                                                        StoreStruct.caption3 = ""
                                                        StoreStruct.caption4 = ""
                                                        
                                                        if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                                                            
                                                        } else {
                                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
//                                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                                                        }
                                                        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                                                        }
                                                    }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else if self.selectedImage3.image != nil {
            let imageData = (theImage1 ?? UIImage()).jpegData(compressionQuality: compression)
            let request = Media.upload(media: .jpeg(imageData))
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    print(stat.id)
                    mediaIDs.append(stat.id)
                    let request4 = Media.updateDescription(description: StoreStruct.caption1, id: stat.id)
                    StoreStruct.client.run(request4) { (statuses) in
                        print(statuses)
                    }
                    
                    
                    let imageData2 = (theImage2 ?? UIImage()).jpegData(compressionQuality: compression)
                    let request2 = Media.upload(media: .jpeg(imageData2))
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            print(stat.id)
                            mediaIDs.append(stat.id)
                            let request5 = Media.updateDescription(description: StoreStruct.caption2, id: stat.id)
                            StoreStruct.client.run(request5) { (statuses) in
                                print(statuses)
                            }
                            
                            
                            let imageData3 = (theImage3 ?? UIImage()).jpegData(compressionQuality: compression)
                            let request3 = Media.upload(media: .jpeg(imageData3))
                            StoreStruct.client.run(request3) { (statuses) in
                                if let stat = (statuses.value) {
                                    print(stat.id)
                                    mediaIDs.append(stat.id)
                                    let request6 = Media.updateDescription(description: StoreStruct.caption3, id: stat.id)
                                    StoreStruct.client.run(request6) { (statuses) in
                                        print(statuses)
                                    }
                                    
                                    
                                    let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, visibility: self.visibility)
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        StoreStruct.client.run(request0) { (statuses) in
                                            print(statuses)
                                            
                                            DispatchQueue.main.async {
                                                NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                                            }
                                            if statuses.isError && self.scheduleTime != nil {
                                                
                                                StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                                
                                                DispatchQueue.main.async {
                                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                        let notification = UINotificationFeedbackGenerator()
                                                        notification.notificationOccurred(.success)
                                                    }
                                                    StoreStruct.savedComposeText = ""
                                                    let statusAlert = StatusAlert()
                                                    statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                                    statusAlert.title = "Toot Toot!".localized
                                                    statusAlert.contentColor = Colours.grayDark
                                                    statusAlert.message = "Successfully \(successMessage)"
                                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                                    
                                                    StoreStruct.caption1 = ""
                                                    StoreStruct.caption2 = ""
                                                    StoreStruct.caption3 = ""
                                                    StoreStruct.caption4 = ""
                                                }
                                                } else if statuses.isError {
                                                DispatchQueue.main.async {
                                                    let statusAlert = StatusAlert()
                                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                                    statusAlert.title = "Could not Toot".localized
                                                    statusAlert.contentColor = Colours.grayDark
                                                    statusAlert.message = "Saved to drafts"
                                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                                }
                                            } else {
                                                
                                                StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                                
                                            DispatchQueue.main.async {
                                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                    let notification = UINotificationFeedbackGenerator()
                                                    notification.notificationOccurred(.success)
                                                }
                                                StoreStruct.savedComposeText = ""
                                            let statusAlert = StatusAlert()
                                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                            statusAlert.title = "Toot Toot!".localized
                                            statusAlert.contentColor = Colours.grayDark
                                            statusAlert.message = "Successfully \(successMessage)"
                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                                
                                                StoreStruct.caption1 = ""
                                                StoreStruct.caption2 = ""
                                                StoreStruct.caption3 = ""
                                                StoreStruct.caption4 = ""
                                                
                                                if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                                                    
                                                } else {
                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
//                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                                                }
                                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                                                }
                                            }
                                            
                                        }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else if self.selectedImage2.image != nil {
            let imageData = (theImage1 ?? UIImage()).jpegData(compressionQuality: compression)
            let request = Media.upload(media: .jpeg(imageData))
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    print(stat.id)
                    mediaIDs.append(stat.id)
                    
                    let request4 = Media.updateDescription(description: StoreStruct.caption1, id: stat.id)
                    StoreStruct.client.run(request4) { (statuses) in
                        print(statuses)
                    }
                    
                    let imageData2 = (theImage2 ?? UIImage()).jpegData(compressionQuality: compression)
                    let request2 = Media.upload(media: .jpeg(imageData2))
                    StoreStruct.client.run(request2) { (statuses) in
                        if let stat = (statuses.value) {
                            print(stat.id)
                            mediaIDs.append(stat.id)
                            
                            let request5 = Media.updateDescription(description: StoreStruct.caption2, id: stat.id)
                            StoreStruct.client.run(request5) { (statuses) in
                                print(statuses)
                            }
                            
                            let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, visibility: self.visibility)
                            DispatchQueue.global(qos: .userInitiated).async {
                                StoreStruct.client.run(request0) { (statuses) in
                                    print(statuses)
                                    
                                    DispatchQueue.main.async {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                                    }
                                    
                                    if statuses.isError && self.scheduleTime != nil {
                                        
                                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                        
                                        DispatchQueue.main.async {
                                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                                let notification = UINotificationFeedbackGenerator()
                                                notification.notificationOccurred(.success)
                                            }
                                            StoreStruct.savedComposeText = ""
                                            let statusAlert = StatusAlert()
                                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                            statusAlert.title = "Toot Toot!".localized
                                            statusAlert.contentColor = Colours.grayDark
                                            statusAlert.message = "Successfully \(successMessage)"
                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                            
                                            StoreStruct.caption1 = ""
                                            StoreStruct.caption2 = ""
                                            StoreStruct.caption3 = ""
                                            StoreStruct.caption4 = ""
                                        }
                                        } else if statuses.isError {
                                        DispatchQueue.main.async {
                                            let statusAlert = StatusAlert()
                                            statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                            statusAlert.title = "Could not Toot".localized
                                            statusAlert.contentColor = Colours.grayDark
                                            statusAlert.message = "Saved to drafts"
                                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                        }
                                    } else {
                                        
                                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                        
                                    DispatchQueue.main.async {
                                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                            let notification = UINotificationFeedbackGenerator()
                                            notification.notificationOccurred(.success)
                                        }
                                        StoreStruct.savedComposeText = ""
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Toot Toot!".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Successfully \(successMessage)"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                        
                                        StoreStruct.caption1 = ""
                                        StoreStruct.caption2 = ""
                                        StoreStruct.caption3 = ""
                                        StoreStruct.caption4 = ""
                                        
                                        if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                                            
                                        } else {
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
//                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                                        }
                                        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                            NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                                        }
                                    }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else if self.selectedImage1.image != nil {
            let imageData = (theImage1 ?? UIImage()).jpegData(compressionQuality: compression)
            let request = Media.upload(media: .jpeg(imageData))
            StoreStruct.client.run(request) { (statuses) in
                if let stat = (statuses.value) {
                    print(stat.id)
                    mediaIDs.append(stat.id)
                    
                    let request4 = Media.updateDescription(description: StoreStruct.caption1, id: stat.id)
                    StoreStruct.client.run(request4) { (statuses) in
                        print(statuses)
                    }
                    
                    let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, visibility: self.visibility)
                    DispatchQueue.global(qos: .userInitiated).async {
                        StoreStruct.client.run(request0) { (statuses) in
                            print(statuses)
                            
                            DispatchQueue.main.async {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                            }
                            if statuses.isError && self.scheduleTime != nil {
                                
                                StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                
                                DispatchQueue.main.async {
                                    if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                        let notification = UINotificationFeedbackGenerator()
                                        notification.notificationOccurred(.success)
                                    }
                                    StoreStruct.savedComposeText = ""
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Toot Toot!".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Successfully \(successMessage)"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                    
                                    StoreStruct.caption1 = ""
                                    StoreStruct.caption2 = ""
                                    StoreStruct.caption3 = ""
                                    StoreStruct.caption4 = ""
                                }
                                } else if statuses.isError {
                                DispatchQueue.main.async {
                                    let statusAlert = StatusAlert()
                                    statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                                    statusAlert.title = "Could not Toot".localized
                                    statusAlert.contentColor = Colours.grayDark
                                    statusAlert.message = "Saved to drafts"
                                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                }
                            } else {
                                
                                StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                                
                            DispatchQueue.main.async {
                                if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                    let notification = UINotificationFeedbackGenerator()
                                    notification.notificationOccurred(.success)
                                }
                                StoreStruct.savedComposeText = ""
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Toot Toot!".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Successfully \(successMessage)"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                                
                                StoreStruct.caption1 = ""
                                StoreStruct.caption2 = ""
                                StoreStruct.caption3 = ""
                                StoreStruct.caption4 = ""
                                
                                if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                                    
                                } else {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
//                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                                }
                                if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                                }
                            }
                            }
                        }
                    }
                }
            }
        } else if self.selectedImage1.image == nil {
            let request0 = Statuses.create(status: theText, replyToID: inRep, mediaIDs: mediaIDs, sensitive: self.isSensitive, spoilerText: StoreStruct.spoilerText, scheduledAt: self.scheduleTime, poll: StoreStruct.newPollPost, visibility: self.visibility)
            DispatchQueue.global(qos: .userInitiated).async {
                StoreStruct.client.run(request0) { (statuses) in
                    print(statuses)
                    
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "stopindi"), object: self)
                    }
                    
                    if statuses.isError && self.scheduleTime != nil {
                        
                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                        
                        DispatchQueue.main.async {
                            if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                                let notification = UINotificationFeedbackGenerator()
                                notification.notificationOccurred(.success)
                            }
                            StoreStruct.savedComposeText = ""
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Toot Toot!".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Successfully \(successMessage)"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                            
                            StoreStruct.caption1 = ""
                            StoreStruct.caption2 = ""
                            StoreStruct.caption3 = ""
                            StoreStruct.caption4 = ""
                        }
                    } else if statuses.isError {
                        DispatchQueue.main.async {
                            let statusAlert = StatusAlert()
                            statusAlert.image = UIImage(named: "reportlarge")?.maskWithColor(color: Colours.grayDark)
                            statusAlert.title = "Could not Toot".localized
                            statusAlert.contentColor = Colours.grayDark
                            statusAlert.message = "Saved to drafts"
                            if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                        }
                    } else {
                        
                        StoreStruct.drafts.remove(at: StoreStruct.drafts.count - 1)
                        UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                        
                    DispatchQueue.main.async {
                        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
                            let notification = UINotificationFeedbackGenerator()
                            notification.notificationOccurred(.success)
                        }
                        StoreStruct.savedComposeText = ""
                    let statusAlert = StatusAlert()
                    statusAlert.image = UIImage(named: "notificationslarge")?.maskWithColor(color: Colours.grayDark)
                    statusAlert.title = "Toot Toot!".localized
                    statusAlert.contentColor = Colours.grayDark
                    statusAlert.message = "Successfully \(successMessage)"
                    if (UserDefaults.standard.object(forKey: "popupset") == nil) || (UserDefaults.standard.object(forKey: "popupset") as! Int == 0) {} else {
                        statusAlert.show()
                    }
                        
                        StoreStruct.caption1 = ""
                        StoreStruct.caption2 = ""
                        StoreStruct.caption3 = ""
                        StoreStruct.caption4 = ""
                        
                        if (UserDefaults.standard.object(forKey: "juto") == nil) || (UserDefaults.standard.object(forKey: "juto") as! Int == 0) {
                            
                        } else {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "fetchAllNewest"), object: nil)
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshCont"), object: nil)
                        }
                        if (UserDefaults.standard.object(forKey: "notifToggle") == nil) || (UserDefaults.standard.object(forKey: "notifToggle") as! Int == 0) {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "confettiCreate"), object: nil)
                        }
                    }
                    }
                }
            }
        }
        
        }
        
        DispatchQueue.main.async {
            if (UserDefaults.standard.object(forKey: "progprogprogprog") == nil || UserDefaults.standard.object(forKey: "progprogprogprog") as! Int == 0) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "startindi"), object: self)
            }
            self.textView.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if (UserDefaults.standard.object(forKey: "hapticToggle") == nil) || (UserDefaults.standard.object(forKey: "hapticToggle") as! Int == 0) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        if gesture.direction == UISwipeGestureRecognizer.Direction.down {
            if self.textView.text! == "" || self.textView.text! == self.startRepText {
                self.textView.resignFirstResponder()
                
                StoreStruct.caption1 = ""
                StoreStruct.caption2 = ""
                StoreStruct.caption3 = ""
                StoreStruct.caption4 = ""
                
                self.dismiss(animated: true, completion: nil)
            } else {
                self.showDraft()
            }
        }
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.keyHeight = Int(keyboardHeight)
            self.updateTweetView()
        }
    }
    
    func updateTweetView() {
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
            case 2436, 1792:
                offset = 88
                closeB = 47
            default:
                offset = 64
                closeB = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 50)
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(70) - Int(self.keyHeight))
        case .pad:
            textView.frame = CGRect(x:20, y:70, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(70) - Int(70) - Int(self.keyHeight))
        default:
            textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(70) - Int(self.keyHeight))
        }
        
        self.tableViewDrafts.frame = CGRect(x: 0, y: 60, width: Int(self.view.bounds.width), height: Int(self.bgView.bounds.height - 60))
        
        self.tableViewASCII.frame = CGRect(x: 0, y: 60, width: Int(self.view.bounds.width), height: Int(self.bgView.bounds.height - 60))
        
        self.tableViewEmoti.frame = CGRect(x: 0, y: 60, width: Int(self.view.bounds.width), height: Int(self.bgView.bounds.height - 60))
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.bringBackDrawer()
        if self.picker.isDescendant(of: self.view) {
            self.picker.removeFromSuperview()
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        
        if (UserDefaults.standard.object(forKey: "keyhap") == nil) || (UserDefaults.standard.object(forKey: "keyhap") as! Int == 0) {
            
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 1) {
            let selection = UISelectionFeedbackGenerator()
            selection.selectionChanged()
        } else if (UserDefaults.standard.object(forKey: "keyhap") as! Int == 2) {
            let impact = UIImpactFeedbackGenerator()
            impact.impactOccurred()
        }
        
        
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
            case 2436, 1792:
                offset = 88
                closeB = 47
            default:
                offset = 64
                closeB = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        
//        self.textView.normalizeText()
        
        let newCount = StoreStruct.maxChars - (textView.text?.count)!
        countLabel.text = "\(newCount)"
        
        if Int(countLabel.text!)! < 1 {
            countLabel.textColor = Colours.red
        } else if Int(countLabel.text!)! < 20 {
            countLabel.textColor = UIColor.orange
        } else {
            countLabel.textColor = Colours.gray.withAlphaComponent(0.65)
        }
        
        if (textView.text?.count)! > 0 {
            if newCount < 0 {
                tootLabel.setTitleColor(Colours.gray.withAlphaComponent(0.65), for: .normal)
            } else {
                tootLabel.setTitleColor(Colours.tabSelected, for: .normal)
            }
        } else {
            tootLabel.setTitleColor(Colours.gray.withAlphaComponent(0.65), for: .normal)
        }
        
        
        let regex = try! NSRegularExpression(pattern: "\\S+$")
        let textRange = NSRange(location: 0, length: textView.text.count)
        
        let regex2 = try! NSRegularExpression(pattern: "\\S+")
        let textRange2 = NSRange(location: 0, length: textView.text.count)
        
        if let range = regex.firstMatch(in: textView.text, range: textRange)?.range {
            let range2 = regex2.firstMatch(in: textView.text, range: textRange2)?.range
            let x1 = (String(textView.text[Range(range, in: textView.text) ?? Range(range2 ?? NSRange(location: 0, length: 0), in: textView.text) ?? Range(NSRange(location: 0, length: 0), in: "")!]))
            if x1.first == "@" && x1.count > 1 {
                print("this is @ \(x1)")
                
                // search @ users in compose
                self.theReg = x1
                
                let request = Accounts.search(query: x1)
                StoreStruct.client.run(request) { (statuses) in
                    if let stat = (statuses.value) {
                        DispatchQueue.main.async {
                            StoreStruct.statusSearchUser = stat
                            self.tableView.reloadData()
                        }
                    }
                }
                
                self.cameraCollectionView.alpha = 0
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 180 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 180)
                    
                    
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch (deviceIdiom) {
                    case .phone:
                        textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(200) - Int(self.keyHeight))
                    case .pad:
                        textView.frame = CGRect(x:20, y:70, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(70) - Int(200) - Int(self.keyHeight))
                    default:
                        textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(200) - Int(self.keyHeight))
                    }
                    
                self.removeLabel.alpha = 0
                self.cameraButton.alpha = 0
                self.visibilityButton.alpha = 0
                self.warningButton.alpha = 0
                self.emotiButton.alpha = 0
                    self.tableView.alpha = 1
                })
            } else {
                
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
                self.bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 50)
                    
                    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
                    switch (deviceIdiom) {
                    case .phone:
                        textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(70) - Int(self.keyHeight))
                    case .pad:
                        textView.frame = CGRect(x:20, y:70, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(70) - Int(70) - Int(self.keyHeight))
                    default:
                        textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(70) - Int(self.keyHeight))
                    }
                    
                self.removeLabel.alpha = 0
                self.cameraButton.alpha = 1
                self.visibilityButton.alpha = 1
                self.warningButton.alpha = 1
                self.emotiButton.alpha = 1
                    self.tableView.alpha = 0
                }, completion: { finished in
                    self.cameraCollectionView.alpha = 1
                })
            }
        }
        
        StoreStruct.savedComposeText = textView.text ?? ""
        StoreStruct.savedInReplyText = self.inReplyText
    }
    
    
    @objc func showDraft() {
        
        Alertift.actionSheet()
            .backgroundColor(Colours.white)
            .titleTextColor(Colours.grayDark)
            .messageTextColor(Colours.grayDark)
            .messageTextAlignment(.left)
            .titleTextAlignment(.left)
            .action(.default("Save as Draft"), image: nil) { (action, ind) in
                print(action, ind)
                
                StoreStruct.drafts.append(self.textView.text!)
                UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
                
                self.textView.resignFirstResponder()
                
                StoreStruct.caption1 = ""
                StoreStruct.caption2 = ""
                StoreStruct.caption3 = ""
                StoreStruct.caption4 = ""
                
                self.dismiss(animated: true, completion: nil)
                
            }
            .action(.default("Discard Draft"), image: nil) { (action, ind) in
                self.textView.resignFirstResponder()
                
                StoreStruct.caption1 = ""
                StoreStruct.caption2 = ""
                StoreStruct.caption3 = ""
                StoreStruct.caption4 = ""
                
                self.dismiss(animated: true, completion: nil)
            }
            .action(.cancel("Dismiss")) { (action, ind) in
                self.textView.becomeFirstResponder()
            }
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
            }
            .popover(anchorView: self.closeButton)
            .show(on: self)
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableViewDrafts || tableView == self.tableViewASCII || tableView == self.tableViewEmoti {
            return 34
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 34)
        let title = UILabel()
        title.frame = CGRect(x: 15, y: 2, width: self.view.bounds.width, height: 24)
        if tableView == self.tableView {
            return nil
        } else if tableView == self.tableViewASCII {
            title.text = "ASCII Text Faces".localized
        } else if tableView == self.tableViewEmoti {
            if StoreStruct.mainResult.isEmpty {
                title.text = "No Instance Emoticons".localized
            } else {
                title.text = "Instance Emoticons".localized
            }
        } else {
            if StoreStruct.drafts.isEmpty {
                title.text = "No Drafts".localized
            } else {
                title.text = "All Drafts".localized
            }
        }
        title.textColor = UIColor.white
        title.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        vw.addSubview(title)
        vw.backgroundColor = Colours.tabSelected
        
        return vw
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return StoreStruct.statusSearchUser.count
        } else if tableView == self.tableViewASCII {
            return StoreStruct.ASCIIFace.count
        } else if tableView == self.tableViewEmoti {
            return StoreStruct.mainResult.count
        } else {
            return StoreStruct.drafts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellfolfol", for: indexPath) as! FollowersCell
            cell.configure(StoreStruct.statusSearchUser[indexPath.row])
            cell.profileImageView.tag = indexPath.row
            cell.backgroundColor = Colours.clear
            cell.userName.textColor = UIColor.white
            cell.userTag.textColor = UIColor.white
            cell.toot.textColor = UIColor.white.withAlphaComponent(0.6)
            let bgColorView = UIView()
            bgColorView.backgroundColor = Colours.clear
            cell.selectedBackgroundView = bgColorView
            return cell
            
        } else if tableView == self.tableViewASCII {
            
            let cell = tableViewASCII.dequeueReusableCell(withIdentifier: "TweetCellASCII", for: indexPath) as! UITableViewCell
            
            cell.textLabel?.text = StoreStruct.ASCIIFace[indexPath.row]
            cell.textLabel?.textAlignment = .left
            
                let backgroundView = UIView()
                backgroundView.backgroundColor = Colours.clear
                cell.selectedBackgroundView = backgroundView
            
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = Colours.clear
            return cell
            
        } else if tableView == self.tableViewEmoti {
            
            let cell = tableViewEmoti.dequeueReusableCell(withIdentifier: "TweetCellEmoti", for: indexPath) as! UITableViewCell
            
            
                cell.textLabel?.attributedText = StoreStruct.mainResult[indexPath.row]
            
            
            
            cell.textLabel?.textAlignment = .left
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = Colours.clear
            cell.selectedBackgroundView = backgroundView
            
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = Colours.clear
            return cell
            
        } else {
            
            let cell = tableViewDrafts.dequeueReusableCell(withIdentifier: "TweetCellDraft", for: indexPath) as! UITableViewCell
            
            if StoreStruct.drafts.isEmpty {
                cell.textLabel?.text = "No saved drafts"
                cell.textLabel?.textAlignment = .center
            } else {
                cell.textLabel?.text = StoreStruct.drafts[indexPath.row]
                cell.textLabel?.textAlignment = .left
                
                let backgroundView = UIView()
                backgroundView.backgroundColor = Colours.clear
                cell.selectedBackgroundView = backgroundView
            }
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.numberOfLines = 0
            cell.backgroundColor = Colours.clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var tabHeight = Int(UITabBarController().tabBar.frame.size.height) + Int(34)
        var offset = 88
        var closeB = 47
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2688:
                offset = 88
                closeB = 47
            case 2436, 1792:
                offset = 88
                closeB = 47
            default:
                offset = 64
                closeB = 24
                tabHeight = Int(UITabBarController().tabBar.frame.size.height)
            }
        }
        if tableView == self.tableView {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.textView.text = self.textView.text.replacingOccurrences(of: self.theReg, with: "@")
        self.textView.text = self.textView.text + StoreStruct.statusSearchUser[indexPath.row].acct + " "
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            self.bgView.frame = CGRect(x:0, y:Int(self.view.bounds.height) - 50 - Int(self.keyHeight), width:Int(self.view.bounds.width), height:Int(self.keyHeight) + 50)
            
            
            let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
            switch (deviceIdiom) {
            case .phone:
                self.textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(70) - Int(self.keyHeight))
            case .pad:
                self.textView.frame = CGRect(x:20, y:70, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(70) - Int(70) - Int(self.keyHeight))
            default:
                self.textView.frame = CGRect(x:20, y:offset, width:Int(self.view.bounds.width - 40), height:Int(self.view.bounds.height) - Int(offset) - Int(70) - Int(self.keyHeight))
            }
            
            self.removeLabel.alpha = 1
            self.cameraButton.alpha = 1
            self.visibilityButton.alpha = 1
            self.warningButton.alpha = 1
            self.emotiButton.alpha = 1
            self.tableView.alpha = 0
        }, completion: { finished in
            self.cameraCollectionView.alpha = 1
        })
        } else if tableView == self.tableViewASCII {
            self.tableViewASCII.deselectRow(at: indexPath, animated: true)
            
            if self.textView.text == "" {
                self.textView.text = StoreStruct.ASCIIFace[indexPath.row]
            } else {
                if self.textView.text.last == " " {
                    self.textView.text = "\(self.textView.text ?? "")\(StoreStruct.ASCIIFace[indexPath.row])"
                } else {
                    self.textView.text = "\(self.textView.text ?? "") \(StoreStruct.ASCIIFace[indexPath.row])"
                }
            }
            
            self.textView.becomeFirstResponder()
            self.bringBackDrawer()
            
        } else if tableView == self.tableViewEmoti {
            self.tableViewEmoti.deselectRow(at: indexPath, animated: true)
            
            if self.textView.text == "" {
                self.textView.text = ":\(StoreStruct.emotiFace[indexPath.row].shortcode):"
            } else {
                if self.textView.text.last == " " {
                    self.textView.text = "\(self.textView.text ?? ""):\(StoreStruct.emotiFace[indexPath.row].shortcode):"
                } else {
                    self.textView.text = "\(self.textView.text ?? "") :\(StoreStruct.emotiFace[indexPath.row].shortcode):"
                }
            }
            
            self.textView.becomeFirstResponder()
            self.bringBackDrawer()
            
        } else {
            self.tableView.deselectRow(at: indexPath, animated: true)
            
            self.textView.text = StoreStruct.drafts[indexPath.row]
            
            StoreStruct.drafts.remove(at: indexPath.row)
            UserDefaults.standard.set(StoreStruct.drafts, forKey: "savedDrafts")
            
            self.textView.becomeFirstResponder()
            self.bringBackDrawer()
            
            self.tableViewDrafts.reloadData()
        }
    }
    
    
}

extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
