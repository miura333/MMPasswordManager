//
//  MMPMMainView.swift
//  MMPasswordManager
//
//  Created by miura on 2016/04/26.
//  Copyright © 2016年 miura. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MMPMMainView : APUTNavigationSubViewBase, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let texts = ["hello", "world", "hello", "Swift"];
    var _tableView:UITableView!;
    var _btn_edit:UIButton!;
    var _btn_cancel:UIButton!;
    var _btn_add:UIButton!;
    
    var _fetchResultController:NSFetchedResultsController!;
    
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        self.createHeader();
        
        let dim = AppUtil.getViewDimension();
        _tableView = UITableView(frame: CGRectMake(0, 64, dim.width, dim.height-64), style: UITableViewStyle.Plain);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.addSubview(_tableView);
        
        self.updateTableView();
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        let sec = self.fetchResultController.sections! as [NSFetchedResultsSectionInfo];
        return sec[0].numberOfObjects;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell");
        
        let account:MMPM_ACCOUNTS = self.fetchResultController.objectAtIndexPath(indexPath) as! MMPM_ACCOUNTS;
        cell.textLabel!.text = account.account_title;
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let account:MMPM_ACCOUNTS = self.fetchResultController.objectAtIndexPath(indexPath) as! MMPM_ACCOUNTS;
        
        let dim = AppUtil.getViewDimension();
        let view1:MMPMAddView = MMPMAddView(frame: CGRectMake(0, 0, dim.width, dim.height));
        view1.setAccount(account);
        
        self._nav?.pushView(view1, animationType: APUTNavAnimationType.kAnimationTypeSlideInOut);
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            
        }
    }
    
    private func createHeader() {
        let dim = AppUtil.getViewDimension();
        let base:UIView = UIView(frame: CGRectMake(0, 0, dim.width, 64));
        base.backgroundColor = AppUtil.getMMPMHeaderGrayColor();
        
        let border:UIView = UIView(frame: CGRectMake(0, 63, dim.width, 1));
        border.backgroundColor = AppUtil.getMMPMHeaderBorderColor();
        base.addSubview(border);
        
        self.addSubview(base);
        
        _btn_edit = UIButton(type: UIButtonType.RoundedRect);
        _btn_edit.frame = CGRectMake(0, 20, 75, 44);
        _btn_edit.setTitle("Edit", forState: UIControlState.Normal);
        _btn_edit.addTarget(self, action: #selector(editButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        base.addSubview(_btn_edit);
        
        _btn_cancel = UIButton(type: UIButtonType.RoundedRect);
        _btn_cancel.frame = CGRectMake(0, 20, 75, 44);
        _btn_cancel.setTitle("Cancel", forState: UIControlState.Normal);
        _btn_cancel.addTarget(self, action: #selector(cancelButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        base.addSubview(_btn_cancel);
        
        _btn_cancel.alpha = 0.0;
        
        _btn_add = UIButton(type: UIButtonType.ContactAdd);
        _btn_add.frame = CGRectMake(dim.width - 44, 20, 44, 44);
        _btn_add.addTarget(self, action: #selector(addButtonTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside);
        base.addSubview(_btn_add);
        
        _btn_add.alpha = 0.0;
    }
    
    func editButtonTapped(sender: AnyObject) {
        UIView.animateWithDuration(
            0.1,
            animations: {() -> Void in
                
                self._btn_edit.alpha = 0.0;
                self._btn_cancel.alpha = 1.0;
                self._btn_add.alpha = 1.0;
            },
            completion: { (Bool) -> Void in
                self._tableView.setEditing(true, animated: true);
            }
        );
    }
    
    func cancelButtonTapped(sender: AnyObject) {
        UIView.animateWithDuration(
            0.1,
            animations: {() -> Void in
                
                self._btn_edit.alpha = 1.0;
                self._btn_cancel.alpha = 0.0;
                self._btn_add.alpha = 0.0;
            },
            completion: { (Bool) -> Void in
                self._tableView.setEditing(false, animated: true);
                
                self.updateTableView();
            }
        );
    }
    
    func addButtonTapped(sender: AnyObject) {
        let dim = AppUtil.getViewDimension();
        let view1:MMPMAddView = MMPMAddView(frame: CGRectMake(0, 0, dim.width, dim.height));
        
        self._nav?.pushView(view1, animationType: APUTNavAnimationType.kAnimationTypeSlideUpDown);
    }
    
    override func popAnimationDidEnd() {
        self.cancelButtonTapped([]);
        
    }
    
    func updateTableView() {
        do {
            try self.fetchResultController.performFetch();
            _tableView.reloadData();
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    var fetchResultController:NSFetchedResultsController {
        if(_fetchResultController != nil) {
            return _fetchResultController;
        }
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
        let accountContext:NSManagedObjectContext = appDelegate.managedObjectContext;
        
        let fetchRequest:NSFetchRequest = NSFetchRequest();
        let accountEntity:NSEntityDescription = NSEntityDescription.entityForName("MMPM_ACCOUNTS", inManagedObjectContext: accountContext)!;
        fetchRequest.entity = accountEntity;
        fetchRequest.fetchBatchSize = 20;
        
        let sortDescriptor:NSSortDescriptor = NSSortDescriptor(key: "account_title", ascending: true);
        fetchRequest.sortDescriptors = [sortDescriptor];
        
        _fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: accountContext, sectionNameKeyPath: nil, cacheName: nil);
        _fetchResultController.delegate = self;
        
        return _fetchResultController;
    }
    
}
