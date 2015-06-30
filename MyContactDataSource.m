//
//  MyContactDataSource.m
//  MyContacts
//
//  Created by qianfeng on 14-8-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "MyContactDataSource.h"
#import "ContactModel.h"
#import "FMDatabase.h"

@implementation MyContactDataSource
+ (MyContactDataSource*)sharedMyContactDataSource
{
    static MyContactDataSource* _sington=nil;
    if (_sington==nil) {
        _sington=[[MyContactDataSource alloc]init];
    }
    return _sington;
}

- (void)loadData
{
    //文件读取
//    NSString* strPath=[NSString stringWithFormat:@"%@/Documents/MyContacts",NSHomeDirectory()];
//    NSString* strFilePath=[NSString stringWithFormat:@"%@/contact.plist",strPath];
//    
//    NSFileManager* fm=[NSFileManager defaultManager];
//    
//    NSMutableArray* array;
//    if ([fm fileExistsAtPath:strFilePath]==NO) {
//        return;
//    }
//    
//    else{
//        array=[NSMutableArray arrayWithContentsOfFile:strFilePath];
//    }
//    
//    _arrayDataSource=[[NSMutableArray alloc]init];
//    
//    for (NSDictionary* dic in array) {
//        
//        ContactModel* model=[[ContactModel alloc]init];
//        
//        model.modelName=[dic objectForKey:@"Name"];
//        model.modelAddress=[dic objectForKey:@"Address"];
//        model.modelNum=[dic objectForKey:@"Num"];
//        model.modelIcon=@"Icon.png";
//        [_arrayDataSource addObject:model];
//    }
    
    //SQLite 读取
     NSString* strPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/contact.datebase"];
    FMDatabase* fmdb=[FMDatabase databaseWithPath:strPath];
    [fmdb open];
    
    _arrayDataSource=[[NSMutableArray alloc]init];
    NSString* strQuery=@"select * from myContact;";
    FMResultSet* resultSet=[fmdb executeQuery:strQuery];
    NSLog(@"%d",[resultSet next]);
    
    while ([resultSet next]) {
        ContactModel* model=[[ContactModel alloc]init];
        model.modelName=[resultSet stringForColumn:@"Name"];
        
        NSLog(@"%@",[resultSet stringForColumn:@"Name"]);
        
        model.modelNum=[resultSet stringForColumn:@"PhoneNum"];
        model.modelAddress=[resultSet stringForColumn:@"Address"];
        [_arrayDataSource addObject:model];
    }
    
    [fmdb close];
    

}



- (void)saveData:(NSMutableArray*)arr
{

    NSString* strPath=[NSString stringWithFormat:@"%@/Documents/MyContacts",NSHomeDirectory()];
    NSString* strFilePath=[NSString stringWithFormat:@"%@/contact.plist",strPath];
    
    NSFileManager* fm=[NSFileManager defaultManager];
    
    NSMutableArray* array;
    
    if ([fm fileExistsAtPath:strFilePath]==NO) {
        [fm createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fm createFileAtPath:strFilePath contents:nil attributes:nil];
    }
    
    array=[[NSMutableArray alloc]init];

    
    for (int i=0; i<[arr count]; i++) {
        NSMutableArray* arraySub=[arr objectAtIndex:i];
        NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
        for (int j=0; j<[arraySub count]; j++) {
            ContactModel* model=[arraySub objectAtIndex:j];
            [dic setObject:model.modelIcon forKey:@"Icon"];
            [dic setObject:model.modelName forKey:@"Name"];
            [dic setObject:model.modelNum forKey:@"Num"];
            [dic setObject:model.modelAddress forKey:@"Address"];
        }
        [array addObject:dic];
    }
    
    [array writeToFile:strFilePath atomically:YES];
}


@end
