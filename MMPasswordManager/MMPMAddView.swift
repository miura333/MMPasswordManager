//
//  MMPMAddView.swift
//  MMPasswordManager
//
//  Created by miura on 2016/04/26.
//  Copyright © 2016年 miura. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MMPMAddView : APUTNavigationSubViewBase, UITextFieldDelegate {
    private let MMPM_TITLE_TAG:Int = 30001;
    private let MMPM_USERNAME_TAG:Int = 30002;
    private let MMPM_PASSWD_TAG:Int = 30003;
    private let CELL_HEIGHT:CGFloat = 72;
    
    var _tf_title:UITextField!;
    var _tf_username:UITextField!;
    var _tf_passwd:UITextField!;
    var _btn_close:UIButton!;
    
    weak var _account:MMPM_ACCOUNTS?;
    
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.createHeader();
        
        var y1:CGFloat = 64;
        let dim = AppUtil.getViewDimension();
        
        self.createGroupItem("Title", y: y1, action: #selector(titleButtonTapped(_:)), btn_id: MMPM_TITLE_TAG);
        
        _tf_title = UITextField(frame: CGRectMake(dim.width - 220, y1, 210, CELL_HEIGHT));
        _tf_title.font = UIFont.systemFontOfSize(16);
        _tf_title.textColor = AppUtil.getMMPMHeaderBorderColor();
        _tf_title.backgroundColor = UIColor.clearColor();
        _tf_title.textAlignment = NSTextAlignment.Left;
        _tf_title.delegate = self;
        self.addSubview(_tf_title);
        
        y1 += CELL_HEIGHT;
        
        self.createGroupItem("UserName", y: y1, action: #selector(usernameButtonTapped(_:)), btn_id: MMPM_USERNAME_TAG);
        
        _tf_username = UITextField(frame: CGRectMake(dim.width - 220, y1, 210, CELL_HEIGHT));
        _tf_username.font = UIFont.systemFontOfSize(16);
        _tf_username.textColor = AppUtil.getMMPMHeaderBorderColor();
        _tf_username.backgroundColor = UIColor.clearColor();
        _tf_username.textAlignment = NSTextAlignment.Left;
        _tf_username.delegate = self;
        self.addSubview(_tf_username);
        
        y1 += CELL_HEIGHT;
        
        self.createGroupItem("Password", y: y1, action: #selector(passwdButtonTapped(_:)), btn_id: MMPM_PASSWD_TAG);
        
        _tf_passwd = UITextField(frame: CGRectMake(dim.width - 220, y1, 210, CELL_HEIGHT));
        _tf_passwd.font = UIFont.systemFontOfSize(16);
        _tf_passwd.textColor = AppUtil.getMMPMHeaderBorderColor();
        _tf_passwd.backgroundColor = UIColor.clearColor();
        _tf_passwd.textAlignment = NSTextAlignment.Left;
        _tf_passwd.delegate = self;
        self.addSubview(_tf_passwd);
    }
    
    private func createHeader() {
        let dim = AppUtil.getViewDimension();
        let base:UIView = UIView(frame: CGRectMake(0, 0, dim.width, 64));
        base.backgroundColor = AppUtil.getMMPMHeaderGrayColor();
        
        let border:UIView = UIView(frame: CGRectMake(0, 63, dim.width, 1));
        border.backgroundColor = AppUtil.getMMPMHeaderBorderColor();
        base.addSubview(border);
        
        self.addSubview(base);
        
        _btn_close = UIButton(type: UIButtonType.Custom);
        _btn_close.frame = CGRectMake(0, 20, 44, 44);
        _btn_close.setImage(UIImage(named: "00-btn_close"), forState: UIControlState.Normal);
        _btn_close.addTarget(self, action: #selector(closeButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        base.addSubview(_btn_close);
        
        let btn_save:UIButton = UIButton(type: UIButtonType.RoundedRect);
        btn_save.frame = CGRectMake(dim.width - 75, 20, 75, 44);
        btn_save.setTitle("Save", forState: UIControlState.Normal);
        btn_save.addTarget(self, action: #selector(saveButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        base.addSubview(btn_save);
        
    }
    
    func closeButtonTapped(sender: AnyObject) {
        if(_account == nil) {
            self._nav?.popCurrentView(APUTNavAnimationType.kAnimationTypeSlideUpDown);
        }else{
            self._nav?.popCurrentView(APUTNavAnimationType.kAnimationTypeSlideInOut);
        }
    }
    
    func saveButtonTapped(sender: AnyObject) {
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let accountContext:NSManagedObjectContext = appDelegate.managedObjectContext;
        
        if(_account == nil) {
            let accountEntity:NSEntityDescription = NSEntityDescription.entityForName("MMPM_ACCOUNTS", inManagedObjectContext: accountContext)!;
            
            let newAccount:MMPM_ACCOUNTS = MMPM_ACCOUNTS(entity: accountEntity, insertIntoManagedObjectContext: accountContext);
            
            newAccount.account_title = _tf_title.text;
            newAccount.username = _tf_username.text;
            newAccount.password = _tf_passwd.text;
            newAccount.url = "";
            
            appDelegate.saveContext();
            
            self._nav?.popCurrentView(APUTNavAnimationType.kAnimationTypeSlideUpDown);
        }else{
            _account?.account_title = _tf_title.text;
            _account?.username = _tf_username.text;
            _account?.password = _tf_passwd.text;
            
            appDelegate.saveContext();
            
            self._nav?.popCurrentView(APUTNavAnimationType.kAnimationTypeSlideInOut);
        }
        
    }
    
    func titleButtonTapped(sender: AnyObject) {
        self.updateButtonBackground(MMPM_TITLE_TAG);
        _tf_title.becomeFirstResponder();
    }
    
    func usernameButtonTapped(sender: AnyObject) {
        self.updateButtonBackground(MMPM_USERNAME_TAG);
        _tf_username.becomeFirstResponder();
    }
    
    func passwdButtonTapped(sender: AnyObject) {
        self.updateButtonBackground(MMPM_PASSWD_TAG);
        _tf_passwd.becomeFirstResponder();
    }
    
    private func createGroupItem(title:String, y:CGFloat, action: Selector, btn_id:Int) {
        let dim = AppUtil.getViewDimension();
        let btn1:UIButton = UIButton(type: UIButtonType.Custom);
        btn1.frame = CGRectMake(0, y, dim.width, CELL_HEIGHT);
        btn1.backgroundColor = UIColor.whiteColor();
        btn1.tag = btn_id;
        if(action != nil) {
            btn1.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside);
        }
        self.addSubview(btn1);
        
        let label1:UILabel = UILabel(frame: CGRectMake(14, 0, 100, CELL_HEIGHT));
        label1.font = UIFont.systemFontOfSize(16);
        label1.textColor = UIColor.blackColor();
        label1.backgroundColor = UIColor.clearColor();
        label1.textAlignment = NSTextAlignment.Left;
        label1.text = title;
        btn1.addSubview(label1);
        
        let line1:UIView = UIView(frame: CGRectMake(0, CELL_HEIGHT-1, dim.width, 1));
        line1.backgroundColor = AppUtil.getMMPMHeaderBorderColor();
        btn1.addSubview(line1);
    }
    
    private func updateButtonBackground(btn_id:Int) {
        let btn_title:UIButton? = self.viewWithTag(MMPM_TITLE_TAG) as? UIButton;
        if(btn_title != nil) {btn_title!.backgroundColor = UIColor.whiteColor();}
        let btn_username:UIButton? = self.viewWithTag(MMPM_USERNAME_TAG) as? UIButton;
        if(btn_username != nil) {btn_username!.backgroundColor = UIColor.whiteColor();}
        let btn_passwd:UIButton? = self.viewWithTag(MMPM_PASSWD_TAG) as? UIButton;
        if(btn_passwd != nil) {btn_passwd!.backgroundColor = UIColor.whiteColor();}
        
        let btn1:UIButton? = self.viewWithTag(btn_id) as? UIButton;
        if(btn1 != nil) {
            btn1?.backgroundColor = AppUtil.getMMPMHeaderGrayColor();
        }
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField == _tf_title) {
            self.updateButtonBackground(MMPM_TITLE_TAG);
        }else if(textField == _tf_username) {
            self.updateButtonBackground(MMPM_USERNAME_TAG);
        }else if(textField == _tf_passwd) {
            self.updateButtonBackground(MMPM_PASSWD_TAG);
        }
    }
    
    func setAccount(account:MMPM_ACCOUNTS) {
        _account = account;
        
        _tf_title.text = account.account_title;
        _tf_username.text = account.username;
        _tf_passwd.text = account.password;
        
        _btn_close.setImage(UIImage(named: "00-btn_arrow"), forState: UIControlState.Normal);
    }
}