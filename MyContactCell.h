//
//  MyContactCell.h
//  MyContacts
//
//  Created by qianfeng on 14-8-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
@interface MyContactCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *CellName;
@property (retain, nonatomic) IBOutlet UILabel *CellNum;
@property (retain, nonatomic) IBOutlet UILabel *CellAddress;
@property (retain, nonatomic) IBOutlet UIImageView *CellIcon;

@property (retain,nonatomic)ContactModel* model;
@end
