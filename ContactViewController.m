//
//  ContactViewController.m
//  MyContacts
//
//  Created by qianfeng on 14-8-22.
//  Copyright (c) 2014年 Qianfeng. All rights reserved.
//

#import "ContactViewController.h"
#import "AddPeopleVC.h"

#import "MyContactCell.h"
#import "MyContactDataSource.h"
#import "ContactModel.h"
#import "ChineseToPinyin.h"


@interface ContactViewController ()

@end

@implementation ContactViewController

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
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, 320, 440) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    _searchBar=[[UISearchBar alloc]init];
    _searchBar.frame=CGRectMake(0, 0, 320, 40);
    
    
    _searchDC=[[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
    _searchDC.searchResultsDelegate=self;
    _searchDC.searchResultsDataSource=self;
    
    
    [self createBtn];
    [self readFile];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_searchBar];
}


- (void)searchResult:(NSIndexPath*)indexPath
{
    if (_searchResultArr==nil) {
        _searchResultArr=[[NSMutableArray alloc]init];
    }
    [_searchResultArr removeAllObjects];
    
    for (int i=0; i<[_arrayTableView count]; i++) {
        NSArray* arraySub=[_arrayTableView objectAtIndex:i];
        
        NSPredicate* predicate=[NSPredicate predicateWithFormat:@"SELF contains[cd] %@",_searchBar.text];
        
        
        NSMutableArray* stringArr=[[NSMutableArray alloc]init];
        for (int j=0; j<[arraySub count]; j++) {
            ContactModel* contactModel=[arraySub objectAtIndex:j];
            [stringArr addObject:contactModel.modelName];
        }
        
        NSArray* arrResult=[stringArr filteredArrayUsingPredicate:predicate];
        
        NSMutableArray* resultContactArr=[[NSMutableArray alloc]init];
        for (NSString* str in arrResult) {
            for (int o=0; o<[_arrayTableView count]; o++) {
                for (ContactModel* model in [_arrayTableView objectAtIndex:o]) {
                    if ([model.modelName isEqualToString:str]) {
                        [resultContactArr addObject:model];
                    }
                }
            }
        }
        [_searchResultArr addObjectsFromArray:resultContactArr];
      
    }
    
    
    
//    for (int i = 0 ; i < _fullarr.count; i++)
//    {
//        NSMutableArray * arraySub = [_fullarr objectAtIndex:i] ;
//        
//        //    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@",_searchBar.text] ;
//        //    NSArray* arrResult = [arraySub  filteredArrayUsingPredicate:predicate];
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@",_searchBar.text] ;
//        
//        NSMutableArray * arr=[[NSMutableArray alloc]init];
//        
//        for (Poeple * zc in arraySub)   //evaluateWithObject
//        {
//            BOOL isContains = [predicate evaluateWithObject:zc.name];            //运气+勇气
//            if (isContains==YES)
//            {
//                [arr addObject:zc];
//            }
//        }
//        [_resultArr addObjectsFromArray:arr] ;
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [self readFile];
}



- (void)readFile
{
    MyContactDataSource* data=[MyContactDataSource sharedMyContactDataSource];
    [data loadData];
    
    _arrayData=data.arrayDataSource;
    [self sortNameInfo];
    [_tableView reloadData];
}



- (void)sortNameInfo
{
    _arrayTableView=[[NSMutableArray alloc]init];
    for (int i='A'; i<='Z'; i++) {
        NSMutableArray* arraySub=[[NSMutableArray alloc]init];
        for (int j=0; j<[_arrayData count]; j++) {
            ContactModel* model=[_arrayData objectAtIndex:j];
            NSString* str=[ChineseToPinyin pinyinFromChiniseString:model.modelName];
            int c=[str characterAtIndex:0];
            if (c==i) {
                [arraySub addObject:model];
            }
        }
        if ([arraySub count]) {
            [_arrayTableView addObject:arraySub];
        }
    }
}




- (void)createBtn
{
    self.navigationItem.title=@"所有联系人";
    _editBtn=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(pressEdit)];
    
    
    _finishBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(pressFinish)];
    
    _addBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pressAdd)];
    
    _deleteBtn=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(pressDelete)];
    
    self.navigationItem.rightBarButtonItem=_addBtn;
    self.navigationItem.leftBarButtonItem=_editBtn;
}


- (void)pressEdit
{
    self.navigationItem.leftBarButtonItem=_finishBtn;
    self.navigationItem.rightBarButtonItem=_deleteBtn;
    [_tableView setEditing:YES animated:YES];
    
    _deleteArr=[[NSMutableArray alloc]init];
}

- (void)pressFinish
{
    self.navigationItem.leftBarButtonItem=_editBtn;
    self.navigationItem.rightBarButtonItem=_addBtn;
    [_tableView setEditing:NO animated:YES];
}



- (void)pressAdd
{
    AddPeopleVC* add=[[AddPeopleVC alloc]init];
    UINavigationController* nav=[[UINavigationController alloc]initWithRootViewController:add];
    [self presentViewController:nav animated:YES completion:nil];
}




//删除部分

BOOL delete_same_name=NO;

- (void)pressDelete
{
    for (int i=0; i<[_deleteArr count]; i++) {
        ContactModel* model_delete=[_deleteArr objectAtIndex:i];
        for (int j=0; j<[_arrayTableView count]; j++) {
            NSMutableArray* model_inArr=[_arrayTableView objectAtIndex:j];
            [model_inArr removeObject:model_delete];
        }
    }
    
    
    //反写进文件
    MyContactDataSource* myData=[MyContactDataSource sharedMyContactDataSource];
    [myData saveData:_arrayTableView];
    [_tableView reloadData];
}








-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_deleteArr removeObject:[[_arrayTableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_deleteArr addObject:[[_arrayTableView objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[_arrayTableView objectAtIndex:section]count]) {
        NSString* str=[[[_arrayTableView objectAtIndex:section]objectAtIndex:0] modelName];
        NSString* strIndex=[ChineseToPinyin pinyinFromChiniseString:str];
        return [strIndex substringToIndex:1];
    }
    return nil;
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* strID=@"ID";
    MyContactCell* cell=[tableView dequeueReusableCellWithIdentifier:strID];
    if (cell==nil) {
        NSArray* array=[[NSBundle mainBundle]loadNibNamed:@"MyContactCell" owner:self options:nil];
        cell=[array lastObject];
    }
    ContactModel* model;
    if (tableView==_searchDC.searchResultsTableView) {
        model=[_searchResultArr objectAtIndex:indexPath.row];
    }
    
    else{
       model=[[_arrayTableView objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];}
    cell.model=model;
    
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==_searchDC.searchResultsTableView) {
        [self searchResult:nil];
        return 1;
    }
    
    return _arrayTableView.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_searchDC.searchResultsTableView) {
        return _searchResultArr.count;
    }
    
    return [[_arrayTableView objectAtIndex:section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
