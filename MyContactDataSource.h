//
//  MyContactDataSource.h
//  MyContacts
//
//  Created by qianfeng on 14-8-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyContactDataSource : NSObject
@property (retain,nonatomic)NSMutableArray* arrayDataSource;
+ (MyContactDataSource*)sharedMyContactDataSource;

- (void)loadData;

- (void)saveData:(NSMutableArray*)arr;
@end
