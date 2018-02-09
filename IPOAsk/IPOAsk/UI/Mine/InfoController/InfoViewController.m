//
//  InfoViewController.m
//  IPOAsk
//
//  Created by lzw on 2018/1/27.
//  Copyright © 2018年 law. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "InfoViewController.h"

@interface InfoViewController () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic)UIActionSheet *sheet;
@property (strong, nonatomic)UIButton *HeadImageBtn;

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) InfoCellType Select;
@property (assign, nonatomic) CGFloat tableViewHeight;
@property (assign, nonatomic) CGFloat keyboardHeight;

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
    
    self.view.backgroundColor = MineTopColor;
    
    _tableViewHeight = 150 + 7 * 60 + 10;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    [self setUpNavBgColor:MineTopColor];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hiddenNav];
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
    if (section == 0) {
        return 6;
    }else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == InfoCellType_introduction)
    {
        return 150;
    }else
    {
        return 60.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = MineTopColor;
        return view;
    }
    return [[UIView alloc]init];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row != InfoCellType_introduction || (indexPath.section == 1 && indexPath.row == 1)) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 60, SCREEN_WIDTH, 0.5)];
            view.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.8];
            [cell addSubview:view];
        }
    }
    
    
    
    if (indexPath.section == 0) {
        if (indexPath.row == InfoCellType_Head) {
       
            
            cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
            _HeadImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _HeadImageBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 10, 40, 40);
            [_HeadImageBtn setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
            [_HeadImageBtn addTarget:self action:@selector(changeHead:) forControlEvents:UIControlEventTouchUpInside];
            _HeadImageBtn.layer.cornerRadius = 20;
            _HeadImageBtn.layer.masksToBounds = YES;
            [cell addSubview:_HeadImageBtn];
            
            
        }else if (indexPath.row == InfoCellType_introduction)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 17, 40, 20)];
            label.text = dataArr[indexPath.section][indexPath.row];
            [cell addSubview:label];
            
            UITextView * textView = [[UITextView alloc]init];
//            textfield.placeholder = dataArr[indexPath.section][indexPath.row];
            textView.delegate = self;
            textView.font = [UIFont systemFontOfSize:15];
            textView.textColor = HEX_RGB_COLOR(0x969ca1);
            textView.tag = indexPath.row;
            [cell addSubview:textView];
            
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).offset(27 + 60);
                make.right.mas_equalTo(cell.mas_right).offset(-20);
                make.top.mas_equalTo(cell.mas_top).offset(17);
                make.bottom.mas_equalTo(cell.mas_bottom);
            }];
            
        }else
        {
            cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
            
            
            UITextField *textfield = [[UITextField alloc]init];
            textfield.placeholder = dataArr[indexPath.section][indexPath.row];
            textfield.keyboardType = UIKeyboardTypeDefault;
            textfield.delegate = self;
            textfield.font = [UIFont systemFontOfSize:15];
            textfield.textColor = HEX_RGB_COLOR(0x969ca1);
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.tag = indexPath.row;
            [cell addSubview:textfield];
            
            [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).offset(27 + 60);
                make.right.mas_equalTo(cell.mas_right).offset(-20);
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.height.equalTo(@20);
            }];
        }
    }
    else if (indexPath.section == 1  && indexPath.section == 1) {
        cell.textLabel.text = dataArr[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"个人用户";
        }else
        {
            cell.detailTextLabel.text = @"否";
        }
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
    _keyboardHeight = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    if (_Select == InfoCellType_introduction) {
        
        [self keyboardShowChangeFrame:YES];
    }
}

- (void)keyboardShowChangeFrame:(BOOL)change{
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.38 animations:^{
        
        if (change) {
            
            _tableView.frame = CGRectMake(0, -_keyboardHeight, SCREEN_WIDTH, _tableViewHeight + _keyboardHeight);
        }else{
            _tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _tableViewHeight);
        }
        
        [self.view layoutIfNeeded];
    }];
    
  
}


#pragma mark -拍照/相册
- (void)takephoto:(NSInteger)photoType
{
    NSString *mediaType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if((authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) && photoType == 0){
        
        [AskProgressHUD AskShowDetailsAndTitleInView:self.view Title:@"您禁用了拍照功能" Detail:@"请前往系统设置打开拍照功能!" viewtag:100];
        [AskProgressHUD AskHideAnimatedInView:self.view viewtag:100 AfterDelay:3];
        
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
     
        [_HeadImageBtn setImage:img forState:UIControlStateNormal];
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

- (void)editInfo
{
    __weak InfoViewController *WeakSelf = self;
    //昵称长度要在2到10个字内
    [[AskHttpLink shareInstance] post:@"http://int.answer.updrv.com/api/v1" bodyparam:@{@"cmd":@"updateUserInfo",@"userID":@"9093a3325caeb5b33eb08f172fe59e7c",@"nickName":@"c2c",@"email":@"398819874@qq.com",@"details":@"c2c",@"company":@"1",@"realName":@"A"} backData:NetSessionResponseTypeJSON success:^(id response) {
        GCD_MAIN(^{
            if ([response[@"status"] intValue] == 1) {
                
            }else
            {
                NSString *msg = response[@"msg"];
                [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
                [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:msg viewtag:2 AfterDelay:3];
            }
        });
    } requestHead:nil faile:^(NSError *error) {
        GCD_MAIN(^{
            [AskProgressHUD AskHideAnimatedInView:WeakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:WeakSelf.view Title:@"修改失败" viewtag:2 AfterDelay:3];
        });
    }];
}

- (void)editHead
{
    [[AskHttpLink shareInstance] POSTImage:@"" data:nil name:@"" finish:^(id response) {
        
    }];
}

@end
