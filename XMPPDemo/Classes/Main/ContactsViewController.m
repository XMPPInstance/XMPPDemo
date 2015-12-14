//
//  ContactsViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "ContactsViewController.h"
#import "XMPPUserCoreDataStorageObject.h"
@interface ContactsViewController ()
@property (nonatomic,strong) NSArray * friends;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 从数据库里加载好友列表显示
    [self loadFriends];
    
}

- (void)loadFriends {
    // 使用CoreData获取数据
    // 1 上下文[关联到数据库XMPPDemo.sqlite]
    NSManagedObjectContext * context = [XMPPTool defaultTool].rosterStorage.mainThreadManagedObjectContext;
    // 2 FetchReques[查哪张表]
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    // 3 设置过滤和排序
    // 过滤当前登录用户的好友
    NSString * jid = [UserInfo defaultUserInfo].jid;
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    // 排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    // 4 执行请求获取数据
    self.friends = [context executeFetchRequest:request error:nil];
    NSLog(@"%@",self.friends);
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"ContactCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 获取对应好友
    XMPPUserCoreDataStorageObject * friend = self.friends[indexPath.row];
    cell.textLabel.text = friend.jidStr;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
