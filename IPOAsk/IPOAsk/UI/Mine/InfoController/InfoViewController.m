//
//  InfoViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/27.
//  Copyright © 2018年 law. All rights reserved.
//

#import "InfoViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <UIButton+WebCache.h>
#import "UserDataManager.h"

@interface InfoViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) UIButton *HeadImageBtn;
@property (strong, nonatomic) NSArray *UserInfoArr;

@property (strong, nonatomic) UITextField *nickTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *companyTextField;
@property (strong, nonatomic) UITextView *introductionTextView;

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) InfoCellType Select;
@property (assign, nonatomic) CGFloat tableViewHeight;
@property (assign, nonatomic) CGRect keyboardFrame;


@property (strong, nonatomic)UserDataModel *ChangeUserModel;
@end

@implementation InfoViewController
{
    NSArray *dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArr = @[@[@"头像",@"昵称",@"真实姓名",@"绑定邮箱",@"公司名称",@"简介"],@[@"用户类型",@"是否答主"]];
    [self setupView];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(KeyboardDidHideNotification:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)setupView
{
    _ChangeUserModel = [[UserDataModel alloc]init];
    UserDataModel *UserModel = [UserDataManager shareInstance].userModel;
    
    _ChangeUserModel.nickName = UserModel.nickName;
    _ChangeUserModel.realName = UserModel.realName;
    _ChangeUserModel.email = UserModel.email;
    _ChangeUserModel.company = UserModel.company;
    _ChangeUserModel.details = UserModel.details;
    _ChangeUserModel.userID = UserModel.userID;
    _ChangeUserModel.phone = UserModel.phone;
    _ChangeUserModel.headIcon = UserModel.headIcon;
    _ChangeUserModel.userType = UserModel.userType;
    _ChangeUserModel.forbidden = UserModel.forbidden;
    _ChangeUserModel.isAnswerer = UserModel.isAnswerer;
    
    _UserInfoArr = @[_ChangeUserModel.headIcon,_ChangeUserModel.nickName,_ChangeUserModel.realName,_ChangeUserModel.email,_ChangeUserModel.company,_ChangeUserModel.details];
    self.view.backgroundColor = MineTopColor;
    
    _tableViewHeight = SCREEN_HEIGHT - NAVBAR_HEIGHT;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _tableViewHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = MineTopColor;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    
    [self.view addSubview:_tableView]; 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"个人资料";
    
    [self setUpNavBgColor:MineTopColor RightBtn:^(UIButton *btn) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self hiddenNav];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 6;
        }
            break;
        case 1:
        {
            return 2;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == InfoCellType_introduction)
    {
        return 150;
    }else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row != InfoCellType_introduction) {
                cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
            }
            
            switch (indexPath.row) {
                case InfoCellType_Head: //头像
                {
                    if (!_HeadImageBtn) {
                        _HeadImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        _HeadImageBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 10, 40, 40);
                        [_HeadImageBtn sd_setImageWithURL:[NSURL URLWithString:_ChangeUserModel.headIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
                        [_HeadImageBtn addTarget:self action:@selector(changeHead:) forControlEvents:UIControlEventTouchUpInside];
                        _HeadImageBtn.layer.cornerRadius = 20;
                        _HeadImageBtn.layer.masksToBounds = YES;
                    }
                    [cell addSubview:_HeadImageBtn];
                }
                    break;
                case InfoCellType_Nick: //昵称
                {
                    if (!_nickTextField) {
                        _nickTextField = [[UITextField alloc]init];
                        _nickTextField.placeholder = dataArr[indexPath.section][indexPath.row];
                        _nickTextField.keyboardType = UIKeyboardTypeDefault;
                        _nickTextField.delegate = self;
                        _nickTextField.font = [UIFont systemFontOfSize:15];
                        _nickTextField.textColor = HEX_RGB_COLOR(0x969ca1);
                        _nickTextField.textAlignment = NSTextAlignmentRight;
                        _nickTextField.tag = indexPath.row;
                        _nickTextField.text = [_UserInfoArr objectAtIndex:indexPath.row];
                    }
                    [cell addSubview:_nickTextField];
                    
                    [_nickTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).offset(27 + 60);
                        make.right.mas_equalTo(cell.mas_right).offset(-20);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.equalTo(@20);
                    }];
                }
                    break;
                case InfoCellType_Name: //名字
                {
                    if (!_nameTextField) {
                        _nameTextField = [[UITextField alloc]init];
                        _nameTextField.placeholder = dataArr[indexPath.section][indexPath.row];
                        _nameTextField.keyboardType = UIKeyboardTypeDefault;
                        _nameTextField.delegate = self;
                        _nameTextField.font = [UIFont systemFontOfSize:15];
                        _nameTextField.textColor = HEX_RGB_COLOR(0x969ca1);
                        _nameTextField.textAlignment = NSTextAlignmentRight;
                        _nameTextField.tag = indexPath.row;
                        _nameTextField.text = [_UserInfoArr objectAtIndex:indexPath.row];
                    }
                    [cell addSubview:_nameTextField];
                    
                    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).offset(27 + 60);
                        make.right.mas_equalTo(cell.mas_right).offset(-20);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.equalTo(@20);
                    }];
                }
                    break;
                case InfoCellType_Email: //电子邮箱
                {
                    if (!_emailTextField) {
                        _emailTextField = [[UITextField alloc]init];
                        _emailTextField.placeholder = dataArr[indexPath.section][indexPath.row];
                        _emailTextField.keyboardType = UIKeyboardTypeDefault;
                        _emailTextField.delegate = self;
                        _emailTextField.font = [UIFont systemFontOfSize:15];
                        _emailTextField.textColor = HEX_RGB_COLOR(0x969ca1);
                        _emailTextField.textAlignment = NSTextAlignmentRight;
                        _emailTextField.tag = indexPath.row;
                        _emailTextField.text = [_UserInfoArr objectAtIndex:indexPath.row];
                    }
                    [cell addSubview:_emailTextField];
                    
                    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).offset(27 + 60);
                        make.right.mas_equalTo(cell.mas_right).offset(-20);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.equalTo(@20);
                    }];
                }
                    break;
                case InfoCellType_CorporateName: //公司名称
                {
                    if (!_companyTextField) {
                        _companyTextField = [[UITextField alloc]init];
                        _companyTextField.placeholder = dataArr[indexPath.section][indexPath.row];
                        _companyTextField.keyboardType = UIKeyboardTypeDefault;
                        _companyTextField.delegate = self;
                        _companyTextField.font = [UIFont systemFontOfSize:15];
                        _companyTextField.textColor = HEX_RGB_COLOR(0x969ca1);
                        _companyTextField.textAlignment = NSTextAlignmentRight;
                        _companyTextField.tag = indexPath.row;
                        _companyTextField.text = [_UserInfoArr objectAtIndex:indexPath.row];
                    }
                    [cell addSubview:_companyTextField];
                    
                    [_companyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).offset(27 + 60);
                        make.right.mas_equalTo(cell.mas_right).offset(-20);
                        make.centerY.mas_equalTo(cell.mas_centerY);
                        make.height.equalTo(@20);
                    }];
                }
                    break;
                case InfoCellType_introduction: //简介
                {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 40, 20)];
                    label.textAlignment = NSTextAlignmentLeft;
                    label.text = dataArr[indexPath.section][indexPath.row];
                    [cell addSubview:label];
                    
                    if (!_introductionTextView) {
                        _introductionTextView = [[UITextView alloc]init];
                        _introductionTextView.delegate = self;
                        _introductionTextView.font = [UIFont systemFontOfSize:15];
                        _introductionTextView.textColor = HEX_RGB_COLOR(0x969ca1);
                        _introductionTextView.tag = indexPath.row;
                        _introductionTextView.text = [_UserInfoArr objectAtIndex:InfoCellType_introduction];
                    }
                    [cell addSubview:_introductionTextView];
                    
                    [_introductionTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(cell.mas_left).offset(80);
                        make.right.mas_equalTo(cell.mas_right).offset(-20);
                        make.top.mas_equalTo(cell.mas_top).offset(17);
                        make.bottom.mas_equalTo(cell.mas_bottom).offset(-17);
                    }];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
            
            UserDataModel *userMod = [[UserDataManager shareInstance] userModel];
            switch (indexPath.row) {
                case 0:
                {
                    cell.detailTextLabel.text = userMod.userType == 1 ? @"个人用户" : @"企业用户";
                }
                    break;
                case 1:
                {
                    cell.detailTextLabel.text = userMod.isAnswerer == 1 ? @"是" : @"否";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    _Select = textView.tag;
    
    [self keyboardShowChangeFrame:YES];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _Select = textField.tag;
    
    if (SCREEN_HEIGHT < 667 && (_Select == InfoCellType_CorporateName || _Select == InfoCellType_introduction)) {
        [self keyboardShowChangeFrame:YES];
        
    }else [self keyboardShowChangeFrame:NO];
    
    return YES;
}

- (void)changeHead:(UIButton *)sender{
    
    //更换头像
    if (_sheet == nil) {
        _sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍摄" otherButtonTitles:@"从手机相册中选择", nil];
        _sheet.destructiveButtonIndex = 0;
    }
    
    [_sheet showInView:self.view];
}

#pragma mark - 点击头像
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self takephoto:buttonIndex];
    }else if (buttonIndex == 1){
        
        [self takephoto:buttonIndex];
    }
}

#pragma mark -触摸空白地方隐藏键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 键盘状态改变通知

#pragma mark -键盘隐藏时隐藏评论工具栏
- (void)KeyboardDidHideNotification:(NSNotification *)notification
{
    [self keyboardShowChangeFrame:NO];
}

#pragma mark -键盘显示时弹出评论工具栏
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    _keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (_Select == InfoCellType_introduction) {
        [self keyboardShowChangeFrame:YES];
    }
}

- (void)keyboardShowChangeFrame:(BOOL)change{
//    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.38 animations:^{
        
        if (change) {
            CGRect frame = _tableView.frame;
            frame.size.height = _tableViewHeight - _keyboardFrame.size.height;
            _tableView.frame = frame;
        } else {
            CGRect frame = _tableView.frame;
            frame.size.height = _tableViewHeight;
            _tableView.frame = frame;
        }
        
//        [self.view layoutIfNeeded];
        
    }];
    
}


#pragma mark -拍照/相册
- (void)takephoto:(NSInteger)photoType
{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if((authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) && photoType == 0){
        
        [AskProgressHUD AskShowDetailsAndTitleInView:self.view Title:@"您禁用了拍照功能" Detail:@"请前往系统设置打开拍照功能!" viewtag:InfoCellType_HudTag];
        [AskProgressHUD AskHideAnimatedInView:self.view viewtag:InfoCellType_HudTag AfterDelay:3];
        
        return;
    }
    
    @autoreleasepool {
        
        UIImagePickerController *ipc=[[UIImagePickerController alloc] init];
        ipc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        ipc.delegate = self;
        
        if (photoType == 1)
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            ipc.allowsEditing = YES;
        }
        else
        {
            ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
            ipc.allowsEditing = YES;
        }
        
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage* original_image;
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            original_image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        else if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
        {
            original_image = [info objectForKey:UIImagePickerControllerEditedImage];
        }
    }
    UIImage *img = nil;
    if (original_image) {
        NSData *imgData = UIImageJPEGRepresentation(original_image, 0.5);
        img = [UIImage imageWithData:imgData];
        [self editHead:SERVER_URL img:imgData imgName:@"head.jpg"];
    }
    
    __block NSURL *imageAssetUrl = [info objectForKey:UIImagePickerControllerReferenceURL];
    if (imageAssetUrl == nil) {
        ALAssetsLibrary *libarary = [[ALAssetsLibrary alloc] init];
        [libarary writeImageToSavedPhotosAlbum:img.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
            if (assetURL) {
                imageAssetUrl = assetURL;
                [picker dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

//取消选择头像
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)RightClick{
    [self editInfo];
}

- (void)editInfo
{
    __weak InfoViewController *WeakSelf = self;
    __weak UserDataModel *WeakChangeUserModel = _ChangeUserModel;
    __weak UserDataModel *UserModel = [UserDataManager shareInstance].userModel;
    
    
    WeakChangeUserModel.nickName = ((UITextField *)[_tableView viewWithTag:InfoCellType_Nick]).text;
    WeakChangeUserModel.realName = ((UITextField *)[_tableView viewWithTag:InfoCellType_Name]).text;
    WeakChangeUserModel.email = ((UITextField *)[_tableView viewWithTag:InfoCellType_Email]).text;
    WeakChangeUserModel.company = ((UITextField *)[_tableView viewWithTag:InfoCellType_CorporateName]).text;
    WeakChangeUserModel.details = ((UITextField *)[_tableView viewWithTag:InfoCellType_introduction]).text;
    
    
    if (WeakChangeUserModel.nickName.length == 0) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请填写昵称！" viewtag:InfoCellType_HudTag AfterDelay:3];
        return;
    }else if (WeakChangeUserModel.nickName.length < 2 || WeakChangeUserModel.realName.length > 10) {
        //昵称长度要在2到10个字内
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"昵称长度要在2到10个字内～" viewtag:InfoCellType_HudTag AfterDelay:3];
        return;
    }else if (WeakChangeUserModel.realName.length == 0) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请填写姓名！" viewtag:InfoCellType_HudTag AfterDelay:3];
        return;
    }else  if (WeakChangeUserModel.email.length == 0) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请填写邮箱！" viewtag:InfoCellType_HudTag AfterDelay:3];
        return;
    }else  if (WeakChangeUserModel.company.length == 0) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请填写公司名称！" viewtag:InfoCellType_HudTag AfterDelay:3];
        return;
    }else  if (WeakChangeUserModel.details.length == 0) {
        
        [AskProgressHUD AskShowOnlyTitleInView:self.view Title:@"请填写简介！" viewtag:InfoCellType_HudTag AfterDelay:3];
        return;
    }
    
    if ([WeakChangeUserModel.nickName isEqualToString:UserModel.nickName] &&
        [WeakChangeUserModel.realName isEqualToString:UserModel.realName] &&
        [WeakChangeUserModel.email isEqualToString:UserModel.email] &&
        [WeakChangeUserModel.company isEqualToString:UserModel.company] &&
        [WeakChangeUserModel.details isEqualToString:UserModel.details] ) {
        //没有修改
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:@{@"cmd":@"updateUserInfo",@"userID":UserModel.userID,@"nickName":WeakChangeUserModel.nickName,@"email":WeakChangeUserModel.email,@"details":WeakChangeUserModel.details,@"company":WeakChangeUserModel.company,@"realName":WeakChangeUserModel.realName} backData:NetSessionResponseTypeJSON success:^(id response) {
                    GCD_MAIN(^{
       
                        if ([response[@"status"] intValue] == 1) {
                            //保存本地数据
                            [[UserDataManager shareInstance] loginSetUpModel:WeakChangeUserModel];
                            [WeakSelf.navigationController popViewControllerAnimated:YES];
                            
                        }else{
                            NSString *msg = response[@"msg"];
                            [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:InfoCellType_HudTag AfterDelay:0];
                            [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:InfoCellType_HudTag AfterDelay:3];
                        }
                     
                    });
   
    } requestHead:nil faile:^(NSError *error) {
        GCD_MAIN(^{
            [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:InfoCellType_HudTag AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"修改失败" viewtag:InfoCellType_HudTag AfterDelay:3];
        });
    }];
}

- (void)editHead:(NSString *)url img:(NSData *)imgData imgName:(NSString *)name
{
    [[AskHttpLink shareInstance] POSTImage:url data:imgData name:name finish:^(id response) {
        if ([response[@"status"] intValue] == 1) {
            NSString *imgurl = response[@"data"];
            [_HeadImageBtn sd_setImageWithURL:[NSURL URLWithString:imgurl] forState:UIControlStateNormal];
        }
    }];
}

@end
