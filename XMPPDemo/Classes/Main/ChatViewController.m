//
//  ChatViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "ChatViewController.h"
#import "InputView.h"
#import "UIImageView+WebCache.h"
#import "ChatCell.h"
#import "WQTMessage.h"
#import "WQTMessageFrame.h"
@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSFetchedResultsController * _fetchedResultController;
}
@property (nonatomic,strong) NSLayoutConstraint * inputViewBottomContraint;
@property (nonatomic,strong) NSLayoutConstraint * inputViewHeightContraint;// inputView高度约束
@property (nonatomic,weak) InputView * inputView;
@property (nonatomic,weak) UITableView * tableView;
@property (nonatomic,strong) NSArray * messagesFrame;
@end

@implementation ChatViewController

- (NSArray *)messagesFrame {
    if (_messagesFrame == nil) {
        NSArray * tmp = _fetchedResultController.fetchedObjects;
        NSMutableArray * array = [NSMutableArray array];
        for (XMPPMessageArchiving_Message_CoreDataObject * msg in tmp)
        {
//            NSLog(@"%@",msg);
           NSString * type;
            
            if ([msg.outgoing isEqualToNumber:@1]) {
                type = @"1";
            } else {
                type = @"0";
            }

            NSDictionary * dic = @{@"text":msg.body,@"type":type,@"time":msg.timestamp};
            
            WQTMessage * message = [WQTMessage messageWithDict:dic];
           
            WQTMessageFrame * lastMF = [array lastObject];
            NSDate * date = [[lastMF message].time dateByAddingTimeInterval:60];
            
//            NSDate * nextDay = [date ]
            NSDate * earDate = [date earlierDate:msg.timestamp];
            if ([earDate isEqualToDate:msg.timestamp]) {
                message.hiddenTime = YES;
            } else {
                message.hiddenTime = NO;
            }
//             NSLog(@"%@",message);
            WQTMessageFrame * mF = [[WQTMessageFrame alloc] init];
            mF.message = message;
            [array addObject:mF];
        }
        _messagesFrame = array;
        
    }
    return _messagesFrame;

}

- (HttpTool *)httpTool {
    if (_httpTool == nil) {
        _httpTool = [[HttpTool alloc] init];
    }
    return _httpTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadMsgs];
    [self setUpView];
    // 键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
   
    
}


- (void)keyboardWillShow:(NSNotification *)noti {
    // 获取键盘高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrm.size.height;
    self.inputViewBottomContraint.constant = kbHeight;
    // 表格滚动到底部
    [self scrollToTableBottom];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    self.inputViewBottomContraint.constant = 0;
}

//- (void)kbFrmWillChange:(NSNotification *)noti {
//    NSLog(@"%@",noti.userInfo);
//    // 获取窗口的高度
//    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
//    
//    // 键盘约束的frame
//    
//    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    // 获取键盘结束的y值
//    CGFloat kbEndY = kbEndFrm.origin.y;
//    
//    self.inputViewBottomContraint.constant = windowH - kbEndY;
//}

- (void)setUpView {
    // 代码方式实现自动布局 VFL
    // 创建一个TableView
    UITableView * tableView = [[UITableView alloc] init];
    tableView.separatorStyle = NO;
    tableView.backgroundColor = [UIColor grayColor];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
#warning 代码实现自动布局,要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    
    // 创建一个输入框的View
    InputView * inputView = [InputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.textView.delegate = self;
    _inputView = inputView;
    [_inputView.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputView];
    
    // 自动布局
    
    
    // 水平方向的约束
    NSDictionary * views = @{
                             @"tableView":tableView,
                             @"inputView":inputView
                             };
    // 1 tableView水平方向的约束
    NSArray * tableHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableHConstraints];
    
    // 2 inputView水平方向的约束
    NSArray * inputHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputHConstraints];
    
    
    // 垂直方向的约束
    
    NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    // 添加inputView的高度的越是
    self.inputViewHeightContraint = vConstraints[2];
    self.inputViewBottomContraint = [vConstraints lastObject];
    [self.view addConstraints:vConstraints];
    
}

- (void)loadMsgs {
    // 上下文
    NSManagedObjectContext * context = [XMPPTool defaultTool].msgStorage.mainThreadManagedObjectContext;
    
    
    // 请求对象
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    // 过滤 排序
    // 1 当前登录用户的jid
     // 2 好友的jid的信息
    
    
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[UserInfo defaultUserInfo].jid,self.friendJid.bare];
    request.predicate = pre;
   // 排序
    // 升序
    NSSortDescriptor * timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    // 查询
    _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultController.delegate = self;
    NSError * error = nil;
    
    [_fetchedResultController performFetch:&error];
    if (error) {
        WCLog(@"%@",error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchBegan");
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _fetchedResultController.fetchedObjects.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString * cellID = @"ChatCell";
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//    }
//    
//    // 获取聊天消息对象
//    XMPPMessageArchiving_Message_CoreDataObject * msg = _fetchedResultController.fetchedObjects[indexPath.row];
////    NSString * type =
//    NSDictionary * dic = @{@"text":msg.messageStr,@"type":msg.outgoing?@"me":@"other",@"time":msg.timestamp};
//    NSString * chatType = [msg.message attributeStringValueForName:@"bodyType"];
//    
//  if ([chatType isEqualToString:@"text"]) {
//        if ([msg.outgoing boolValue]) { // 自己发的
//            // 显示消息
//            cell.textLabel.text = [NSString stringWithFormat:@"Me: %@",msg.body];
//        } else { // 别人发的
//            cell.textLabel.text = [NSString stringWithFormat:@"Other: %@",msg.body];
//            
//        }
//        cell.imageView.image = nil;
//  } else if ([chatType isEqualToString:@"image"]) {
//      // 下载图片
//      [cell.imageView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:[UIImage imageNamed:@"DefaultProfileHead_qq"]];
//      cell.textLabel.text = nil;
//  }
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell * chatCell = [ChatCell chatCellWithTableView:tableView];

    chatCell.friendJID = self.friendJid;

   
    WQTMessageFrame * mFrame = self.messagesFrame[indexPath.row];
   
    chatCell.mFrame = mFrame;
    
    
    return chatCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQTMessageFrame * mFrame = self.messagesFrame[indexPath.row];
    return mFrame.cellHeight;
}


#pragma mark resultController 代理
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // 刷新数据
    _messagesFrame = nil;
    [self.tableView reloadData];
    [self scrollToTableBottom];
}

- (void)textViewDidChange:(UITextView *)textView {
    // 获取contentSize
    CGFloat contentHeight = textView.contentSize.height;
    NSLog(@"textView的content的高度是 %f",contentHeight);
    // 大于33 超过一行的高度 / 小于68 高度是三行之内的
    if (contentHeight > 33 && contentHeight < 68) {
        self.inputViewHeightContraint.constant = contentHeight + 18;
    }
    
    
    NSLog(@"%@",textView.text);
    NSString * text = textView.text;
    if ([text rangeOfString:@"\n"].length != 0) {
        NSLog(@"发送数据 %@",text);
        NSRange range = [text rangeOfString:@"\n"];
        [self sendMsgWithText:[text substringToIndex:range.location] bodyType:@"text"];
        textView.text = nil;
        // 发送完消息,把inputView的高度改回来
        self.inputViewHeightContraint.constant = 50;
    } else {
        NSLog(@"%@",textView.text);
    }
    
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//      [_inputView.textView endEditing:YES];
//}
#pragma mark 发送聊天消息
- (void)sendMsgWithText:(NSString *)text bodyType:(NSString *)bodyType{
    XMPPMessage * msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    // 设置内容
    [msg addBody:text];
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    NSLog(@"%@",msg);
    [[XMPPTool defaultTool].xmppStream sendElement:msg];
}

#pragma mark 滚动到底部
- (void)scrollToTableBottom {
    if (_fetchedResultController.fetchedObjects.count > 0) {
        NSInteger lastRow = _fetchedResultController.fetchedObjects.count - 1;
        NSIndexPath * lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
}



- (void)addBtnClick {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%@",info);
    // 获取图片
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    // 把图片发送到文件服务器
    
    NSString * uploadUrl = [@"http://127.0.0.1/share/xmppfileupload/" stringByAppendingString:@"0006.jpg"];
    
    // 图片发送成功,把图片的URL上传Openfire的服务器
    [self.httpTool uploadData:UIImageJPEGRepresentation(image, 0.75) url:[NSURL URLWithString:uploadUrl] progressBlock:nil completion:^(NSError *error) {
        if (!error) {
            NSLog(@"上传成功");
            [self sendMsgWithText:uploadUrl bodyType:@"image"];
        }
    }];
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
