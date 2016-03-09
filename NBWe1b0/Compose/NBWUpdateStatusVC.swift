//
//  NBWUpdateStatusVC.swift
//  NBWe1b0
//
//  Created by ChanLiang on 3/7/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

import UIKit
import Alamofire

protocol DismissSuperVCDelegate{
    func dissmissSuperVC()
}

class NBWUpdateStatusVC: UIViewController {
    
    let statusUpdateURL = "https://api.weibo.com/2/statuses/update.json"
    var visibleNumber = 0
    var shareWithImagesArray = ["public","onlyMe","friendsCircle"]
    let shareButtonWidthArray:[CGFloat] = [68,86,116]
    
    var navigationBasicItem:UINavigationItem?
    var textView:UITextView?
    var delegete:DismissSuperVCDelegate?
    var superVC:NBWComposeViewController?
    
    //AccessoryView
    var accessoryView:UIView?
    var locationButton:UIButton?
    var shareWithButton:UIButton?
    var numberOfWordsLabel:UILabel?
    var toolBar:UIToolbar?
    var textInitialLabel:UILabel?
    var rightButton:UIButton?
    
    init(compseVC:NBWComposeViewController){
        super.init(nibName: nil, bundle: nil)
        superVC = compseVC
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()

        setupNavigationBar()
        
        setupTextView()
        
        setupAccessoryBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar(){
        
        let navigationBar                       = UINavigationBar.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: navigationBarHeight!+20))
        
        navigationBasicItem                     = UINavigationItem.init(title: "NewWeibo")
        
        navigationBasicItem!.leftBarButtonItem  = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("dismissVC:"))
        
        let rightBarButtonContextView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 20))
        rightButton = UIButton(frame: rightBarButtonContextView.frame)
        rightButton!.setImage(UIImage(named: "noSend"), forState: .Normal)
        rightButton?.addTarget(self, action: Selector("updateWeibo:"), forControlEvents: .TouchUpInside)
        rightBarButtonContextView.addSubview(rightButton!)

        navigationBasicItem?.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarButtonContextView)
        navigationBasicItem?.rightBarButtonItem?.enabled = false
        
        navigationBar.tintColor = UIColor.lightGrayColor()
        navigationBar.setItems([navigationBasicItem!], animated: true)
     
        
        view.addSubview(navigationBar)
    }
    
    func setupTextView(){
        
        textInitialLabel = UILabel(frame: CGRect(x: 12, y: navigationBarHeight! + 35, width: view.frame.width - 16, height: 20))
        textInitialLabel?.text = "What's on your mind?"
        textInitialLabel?.textColor = UIColor.lightGrayColor()
        view.addSubview(textInitialLabel!)
        
        textView = UITextView(frame: CGRect(x: 8, y: navigationBarHeight! + 28, width: view.frame.width - 16, height: view.frame.height - navigationBarHeight!-20))
        textView?.font = UIFont.systemFontOfSize(17)
        textView?.backgroundColor = UIColor.clearColor()
        textView?.becomeFirstResponder()
        textView?.delegate = self
        view.addSubview(textView!)
    }
    
    func setupAccessoryBar(){
        
        accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 72))
        
        shareWithButton = UIButton(frame: CGRect(x: view.frame.width - shareButtonWidthArray[0] - 8, y: 0, width: shareButtonWidthArray[0], height: 20))
        shareWithButton!.setImage(UIImage(named: "public"), forState: .Normal)
        shareWithButton?.addTarget(self, action: Selector("shareWith:"), forControlEvents: .TouchUpInside)
        accessoryView?.addSubview(shareWithButton!)
        
        numberOfWordsLabel = UILabel(frame: CGRect(x: view.frame.width - (shareWithButton?.frame.width)! - 26, y: 0, width: 10, height: 20))
        numberOfWordsLabel!.text = "4"
        accessoryView?.addSubview(numberOfWordsLabel!)
        
        locationButton = UIButton(frame: CGRect(x: 8, y: 0, width: 200, height: 20))
        locationButton?.setImage(UIImage(named: "addLocation"), forState: .Normal)
        accessoryView?.addSubview(locationButton!)
        
        toolBar  = UIToolbar.init(frame: CGRect(x: 0, y: 28, width: self.view.frame.width, height: 44))
        
        let flexibleSpaceButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        let photoButtonItem         = UIBarButtonItem.init(image: UIImage(named: "photo48"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("fetchPhoto"))
        
        let atButtonItem            = UIBarButtonItem.init(image: UIImage(named: "at48"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("atFriends"))
        
        let linkButtonItem          = UIBarButtonItem.init(image: UIImage(named: "link48"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("link"))
        
        let emojiButtonItem         = UIBarButtonItem.init(image: UIImage(named: "emoji48"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("sendEmoji"))
        
        let addButtonItem           = UIBarButtonItem.init(image: UIImage(named: "add48"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("add"))
        
        toolBar?.items         = [flexibleSpaceButtonItem,photoButtonItem,flexibleSpaceButtonItem,atButtonItem,flexibleSpaceButtonItem,linkButtonItem,flexibleSpaceButtonItem,emojiButtonItem,flexibleSpaceButtonItem,addButtonItem,flexibleSpaceButtonItem]
        
        toolBar?.tintColor = UIColor.lightGrayColor()
        
        accessoryView?.addSubview(toolBar!)
        
        textView?.inputAccessoryView = accessoryView
    }
    
    //MARK: - UIButton
    
    func shareWith(sender:AnyObject){
        let shareWithTVC = NBWShareWithTableVC.init()
        shareWithTVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        shareWithTVC.preferredContentSize = CGSize(width: 120, height: 90)
        shareWithTVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        shareWithTVC.delegate = self
        
        let popover = shareWithTVC.popoverPresentationController
        popover?.barButtonItem = sender as? UIBarButtonItem
        popover?.sourceView = shareWithTVC.view
        popover?.sourceRect = CGRect(x: (shareWithButton?.center.x)! , y: view.frame.height - 288, width: 0, height: 0)
        popover?.delegate = self
        presentViewController(shareWithTVC, animated: true, completion: nil)
    }
    
    func dismissVC(sender:AnyObject){
        textView?.resignFirstResponder()
        dismissViewControllerAnimated(true) { () -> Void in
            self.superVC?.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func updateWeibo(sender:AnyObject){
        Alamofire.request(.POST, statusUpdateURL, parameters: ["access_token":accessToken,"status":(textView?.text)!,"visible":visibleNumber], encoding: ParameterEncoding.URL, headers: nil)
        dismissVC(self)
    }
}

extension NBWUpdateStatusVC:UITextViewDelegate{
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.count > 0 {
            navigationBasicItem?.rightBarButtonItem?.enabled = true
            rightButton?.setImage(UIImage(named: "send"), forState: .Normal)
            textInitialLabel?.text = ""
        }else{
            textInitialLabel?.text = "What's on your mind?"
            navigationBasicItem?.rightBarButtonItem?.enabled = false
            rightButton?.setImage(UIImage(named: "noSend"), forState: .Normal)
        }
    }
    
}

extension NBWUpdateStatusVC:UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

extension NBWUpdateStatusVC:SendIndexDelegate{
    func sendIndex(index: Int) {
        visibleNumber = index
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.shareWithButton?.setImage(UIImage(named: self.shareWithImagesArray[index]), forState: .Normal)
            self.shareWithButton?.frame = CGRect(x: self.view.frame.width - self.shareButtonWidthArray[index] - 8, y: 0, width: self.shareButtonWidthArray[index], height: 20)
            self.numberOfWordsLabel?.frame = CGRect(x: self.view.frame.width - self.shareButtonWidthArray[index] - 26, y: 0, width: 10, height: 20)
        }
    }
}
