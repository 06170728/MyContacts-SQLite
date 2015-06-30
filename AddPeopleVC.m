//
//  AddPeopleVC.m
//  MyContacts
//
//  Created by qianfeng on 14-8-25.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "AddPeopleVC.h"
#import "FMDatabase.h"

@interface AddPeopleVC ()

@end

@implementation AddPeopleVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",NSHomeDirectory());
    UILabel* label_name=[[UILabel alloc]init];
    label_name.frame=CGRectMake(50, 100, 60, 30);
    label_name.text=@"姓名:";
    
    UILabel* label_num=[[UILabel alloc]init];
    label_num.frame=CGRectMake(50, 150, 60, 30);
    label_num.text=@"手机号:";
    
    UILabel* label_address=[[UILabel alloc]init];
    label_address.frame=CGRectMake(50, 200, 60, 30);
    label_address.text=@"归属地:";
    
    
    _tx_name=[[UITextField alloc]initWithFrame:CGRectMake(110, 100, 150, 30)];
    _tx_name.borderStyle=UITextBorderStyleRoundedRect;
    _tx_name.clearButtonMode=UITextFieldViewModeAlways;
    _tx_name.clearsOnBeginEditing=YES;

    
    _tx_num=[[UITextField alloc]initWithFrame:CGRectMake(110, 150, 150, 30)];
    _tx_num.borderStyle=UITextBorderStyleRoundedRect;
    _tx_num.clearButtonMode=UITextFieldViewModeAlways;
    _tx_num.clearsOnBeginEditing=YES;
  
    
    _tx_address=[[UITextField alloc]initWithFrame:CGRectMake(110, 200, 150, 30)];
    _tx_address.borderStyle=UITextBorderStyleRoundedRect;
    _tx_address.clearButtonMode=UITextFieldViewModeAlways;
    _tx_address.clearsOnBeginEditing=YES;

    
    [self.view addSubview:_tx_num];
    [self.view addSubview:_tx_name];
    [self.view addSubview:_tx_address];
    
    [self.view addSubview:label_name];
    [self.view addSubview:label_num];
    [self.view addSubview:label_address];
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self createBtn];
}

- (void)createBtn
{
    UIBarButtonItem* cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(pressCancel)];
    UIBarButtonItem* saveBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(pressSave)];
    self.navigationItem.leftBarButtonItem=cancelBtn;
    self.navigationItem.rightBarButtonItem=saveBtn;
}

- (void)pressCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)pressSave
{
    
    //文件写入
//    NSString* strPath=[NSString stringWithFormat:@"%@/Documents/MyContacts",NSHomeDirectory()];
//    NSString* strFilePath=[NSString stringWithFormat:@"%@/contact.plist",strPath];
//    
//    NSFileManager* fm=[NSFileManager defaultManager];
//    NSMutableArray* array;
//    if ([fm fileExistsAtPath:strFilePath]==NO) {
//        [fm createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fm createFileAtPath:strFilePath contents:nil attributes:nil];
//        array=[[NSMutableArray alloc]init];
//    }
//    
//    else{
//        array=[NSMutableArray arrayWithContentsOfFile:strFilePath];
//    }
//    
//    NSMutableDictionary* dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:_tx_name.text forKey:@"Name"];
//    [dic setObject:_tx_address.text forKey:@"Address"];
//    [dic setObject:_tx_num.text forKey:@"Num"];
//    [array addObject:dic];
//    [array writeToFile:strFilePath atomically:YES];
    
    
    //SQLite写入
    NSString* strPath=[NSHomeDirectory() stringByAppendingString:@"/Documents/contact.datebase"];
    FMDatabase* fmdb=[FMDatabase databaseWithPath:strPath];
    [fmdb open];
    
    static int ID=1;
    NSString* creatTB=@"create table if not exists myContact(ID integer,Name varchar(128),Address varchar(128),PhoneNum varchar(128));";
    BOOL isCreate=[fmdb executeUpdate:creatTB];
    
    if (isCreate) {
        NSLog(@"建表成功");
    }
    

    NSString* strInsert=@"insert into myContact(ID,Name,Address,PhoneNum)" "values(?,?,?,?)";
    BOOL isOk=[fmdb executeUpdate:strInsert,[NSNumber numberWithInt:ID],_tx_name.text,_tx_address.text,_tx_num.text];
    

    if (isOk) {
        NSLog(@"数据写入成功");
    }
    
    //插入数据,?表示后面可以使用对象内容替换
   
    
   
    ID++;
    [fmdb close];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
