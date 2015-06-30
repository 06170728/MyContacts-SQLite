//
//  ContactViewController.h
//  MyContacts
//
//  Created by qianfeng on 14-8-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UIBarButtonItem* _editBtn;
    UIBarButtonItem* _finishBtn;
    UIBarButtonItem* _addBtn;
    UIBarButtonItem* _deleteBtn;
    
    UITableView* _tableView;
    
    NSMutableArray* _arrayData;
    NSMutableArray* _arrayTableView;
    NSMutableArray* _deleteArr;
    
    
    UISearchBar* _searchBar;
    UISearchDisplayController* _searchDC;
    NSMutableArray* _searchResultArr;
    
}
@end
