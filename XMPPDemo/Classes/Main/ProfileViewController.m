//
//  ProfileViewController.m
//  XMPPDemo
//
//  Created by 王亓泰 on 15/12/13.
//  Copyright © 2015年 QianFeng. All rights reserved.
//

#import "ProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "EditCardProfileViewController.h"
@interface ProfileViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,EditCardProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerView; // 头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel; // 昵称
@property (weak, nonatomic) IBOutlet UILabel *weChatNumLabel; // 微信号
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel; // 公司
@property (weak, nonatomic) IBOutlet UILabel *orgUnitLabel; // 部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 职位
@property (weak, nonatomic) IBOutlet UILabel *telLabel; // 电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel; // 邮件

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"个人信息";
    [self loadVCard];

    
}

- (void)loadVCard {
    XMPPvCardTemp * myVCard = [XMPPTool defaultTool].vCard.myvCardTemp;
    if (myVCard.photo) {
        self.headerView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    self.nickNameLabel.text = myVCard.nickname;
    
    self.weChatNumLabel.text = [UserInfo defaultUserInfo].user;
    // 公司
    self.orgNameLabel.text = myVCard.orgName;
    // 部门
    if (myVCard.orgUnits.count > 0) {
        self.orgUnitLabel.text = myVCard.orgUnits[0];
    }
    // 职位
    self.titleLabel.text = myVCard.title;
    // 电话
#warning myVCard.telecomsAddresses 这个get方法,没有对电子名片的xml数据进行解析
    // 使用note字段充当电话
    self.telLabel.text = myVCard.note;
    // 邮件
#warning myVCard.emailAddresses 这个get方法,没有解析
    // 用mailer 字段充当 email
    self.emailLabel.text = myVCard.mailer;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取cell的tag
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger tag = cell.tag;
    
    if (tag == 2) {
       // 不做任何操作
        WCLog(@"不做任何操作");
        return;
    }
    
    if (tag == 0) {
        WCLog(@"选择照片");
        UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
        
    } else {
         WCLog(@"跳到下一个控制器");
        [self performSegueWithIdentifier:@"EditCardSegue" sender:cell];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 获取编辑个人信息的控制器

    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[EditCardProfileViewController class]]) {
        EditCardProfileViewController * editVc = destVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}

#pragma mark actionSheet的delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) { // 取消
        return;
    }
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    // 设置代理
    imagePicker.delegate = self;
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
    
    
    
    if (buttonIndex == 0) { // 照相
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else { // 选择照片
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    WCLog(@"%@",info);
    // 获取图片 设置图片
    UIImage * image = info[UIImagePickerControllerEditedImage];
    self.headerView.image = image;

  
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 更新服务器
   
    [self editProfileViewControllerDidSave];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editProfileViewControllerDidSave {
    // 保存
    // 获取当前的电子名片信息
    XMPPvCardTemp * myVCard = [XMPPTool defaultTool].vCard.myvCardTemp;
    
    myVCard.photo = UIImagePNGRepresentation(self.headerView.image);
    // 昵称
    myVCard.nickname = self.nickNameLabel.text;
    // 公司
    myVCard.orgName = self.orgNameLabel.text;
    
    // 部门
    if (self.orgUnitLabel.text.length > 0) {
        myVCard.orgUnits = @[self.orgUnitLabel.text];
    }
    // 职位
    myVCard.title = self.titleLabel.text;
    // 电话
    myVCard.note = self.telLabel.text;
    // 邮件
    myVCard.mailer = self.emailLabel.text;
    
    // 更新 这个方法会内部会实现数据上传到服务器,无需程序自己操作
    [[XMPPTool defaultTool].vCard updateMyvCardTemp:myVCard];

}

@end
