//
//  NBWCommentViewController.swift
//  NBWe1b0
//
//  Created by ChanLiang on 2/17/16.
//  Copyright © 2016 JackChan. All rights reserved.
//

import UIKit
import Alamofire

class NBWCommentViewController: NBWBasicViewController {
    
    let commentCreateURL = "https://api.weibo.com/2/comments/create.json"
    var idInt:Int?
    var commentOri:Int = 0
    var keyboardSize:CGSize?
    var alsoRepostButton:UIButton?
    var alseRepostBool = false
    
    override init(id: String, navigationBarHeight: CGFloat) {
        super.init(id: id, navigationBarHeight: navigationBarHeight)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.idInt = Int(self.id!)
        
        registerForKeyboardNotifications()
        
        setupAlsoRepostButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForKeyboardNotifications(){
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShow:"), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name: UIKeyboardDidHideNotification, object: nil)
    }
    
    func keyboardWasShow(notif:NSNotification){
        
        let info = notif.userInfo! as NSDictionary
        
        let value = info.objectForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
    
        self.keyboardSize = value.CGRectValue().size
        
//        print(self.keyboardSize!.height)
        
    }
    
    func keyboardWasHidden(notif:NSNotification){
        
        let info = notif.userInfo! as NSDictionary
        let value = info.objectForKey(UIKeyboardFrameBeginUserInfoKey) as! NSValue
        self.keyboardSize = value.CGRectValue().size
        
//        print(self.keyboardSize?.height)
    }
    
    func setupAlsoRepostButton(){
        
        self.alsoRepostButton = UIButton.init(frame: CGRect(x: 8, y: self.view.frame.height - 330, width: 150, height: 20))
        self.alsoRepostButton?.setTitle("  Also Repost", forState: .Normal)
        self.alsoRepostButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        self.alsoRepostButton?.titleLabel?.font = UIFont.systemFontOfSize(15)
        self.alsoRepostButton?.setImage(UIImage(named: "frame"), forState: .Normal)
        self.alsoRepostButton?.addTarget(self, action: Selector("alsoRepostOrNot"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.alsoRepostButton!)
    }
    
    override func sendTextViewContext() {
        super.sendTextViewContext()
        
        Alamofire.request(.POST, commentCreateURL, parameters: ["access_token":accessToken,"comment":(self.textView?.text)!,"id":self.idInt!,"comment_ori":self.commentOri], encoding: ParameterEncoding.URL, headers: nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alsoRepostOrNot(){
        
        if self.alseRepostBool == false {
            self.alseRepostBool = true
            self.alsoRepostButton?.setImage(UIImage(named: "tick"), forState: .Normal)
            self.commentOri = 1
        }else{
            self.alseRepostBool = false
            self.alsoRepostButton?.setImage(UIImage(named: "frame"), forState: .Normal)
            self.commentOri = 0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
