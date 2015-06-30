//
//  MyContactCell.m
//  MyContacts
//
//  Created by qianfeng on 14-8-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "MyContactCell.h"

@implementation MyContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ContactModel *)model
{
    _model=model;
    _CellName.text=_model.modelName;
    _CellNum.text=_model.modelNum;
    _CellAddress.text=_model.modelAddress;
    _CellIcon.image=[UIImage imageNamed:_model.modelIcon];
}


@end
