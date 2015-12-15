//
//  ChatViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/14.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "ChatViewController.h"
#import "InputView.h"
@interface ChatViewController ()
@property (nonatomic,strong) NSLayoutConstraint * inputViewContraint; // inputView地步约束
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    // 键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kbFrmWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)kbFrmWillChange:(NSNotification *)noti {
    NSLog(@"%@",noti.userInfo);
    // 获取窗口的高度
    CGFloat windowH = [UIScreen mainScreen].bounds.size.height;
    
    // 键盘约束的frame
    
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 获取键盘结束的y值
    CGFloat kbEndY = kbEndFrm.origin.y;
    
    self.inputViewContraint.constant = windowH - kbEndY;
}

- (void)setUpView {
    // 代码方式实现自动布局 VFL
    // 创建一个TableView
    UITableView * tableView = [[UITableView alloc] init];
#warning 代码实现自动布局,要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:tableView];
    
    // 创建一个输入框的View
    InputView * inputView = [InputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
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
    
    NSArray * vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    self.inputViewContraint = [vConstraints lastObject];
    [self.view addConstraints:vConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
