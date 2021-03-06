//
//  MainAskCommViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskCommViewController.h"

#import <UIImageView+WebCache.h>

//Controller
#import "BaseNavigationController.h"

@interface MainAskCommViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView   *UserHeadImageView;
@property (strong, nonatomic) UILabel       *UserNameLabel;
@property (strong, nonatomic) UILabel       *CommDate;
@property (strong, nonatomic) UIButton      *SeeBtn;
@property (strong, nonatomic) UIButton      *LikeBtn;

@property (strong, nonatomic) NSString *questionTitle;
@property (strong, nonatomic) AnswerDataModel *model;

@end

@implementation MainAskCommViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupInterface];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showNavBar];
    [self showSearchNavBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self showNavBar];
    [self showSearchNavBar];
    
    [self requestInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_refreshBlock && _model) {
        _refreshBlock(_model);
    }
}


#pragma mark - 界面

- (void)setupInterface {
    
    _questionID = @"";
    _answerID = @"";
    
    if (@available(iOS 11.0, *)) {
        _contentTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    _contentTableView.rowHeight = UITableViewAutomaticDimension;
    _contentTableView.estimatedRowHeight = 9999;
    
}


#pragma mark - 事件响应

- (void)likeAction:(id)sender {
    
    [AskProgressHUD AskShowTitleInView:self.view Title:@"加载中..." viewtag:1];
    
    __weak typeof(self) weakSelf = self;
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    
    NSDictionary *infoDic = @{@"cmd":@"addLike",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"aID":(_answerID ? _answerID : @""),
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
            
            if (response && ([response[@"status"] intValue] == 1)) {
                
                NSDictionary *dic = response[@"data"];
                
                //点击事件请求成功
                [weakSelf.model changeLikeStatus:[dic[@"isLike"] boolValue] count:[dic[@"likeCount"] integerValue]];
                
                NSString *numStr = weakSelf.model.likeNum <= 0 ? @"" : [NSString stringWithFormat:@"%lu", weakSelf.model.likeNum];
                UIImage *likeImg = weakSelf.model.isLike ? [UIImage imageNamed:@"点赞-回复-按下"] : [UIImage imageNamed:@"点赞-回复"];
                UIColor *likeTextColor = weakSelf.model.isLike ? HEX_RGBA_COLOR(0x0B98F2, 1) : HEX_RGBA_COLOR(0x969CA1, 1);
                [weakSelf.LikeBtn setTitleColor:likeTextColor forState:UIControlStateNormal];
                [weakSelf.LikeBtn setTitle:numStr forState:UIControlStateNormal];
                [weakSelf.LikeBtn setImage:likeImg forState:UIControlStateNormal];
                [weakSelf.LikeBtn setImage:likeImg forState:UIControlStateHighlighted];
                
            } else {
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"加载失败" viewtag:1 AfterDelay:1.5];
                
            }
            
        }));
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
        });
        
    }];
    
}


#pragma mark - 功能

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestInfo {
    
    __weak typeof(self) weakSelf = self;
    
    [AskProgressHUD AskShowTitleInView:self.view Title:@"加载中..." viewtag:1];
    
    UserDataModel *userMod = [UserDataManager shareInstance].userModel;
    NSDictionary *infoDic = @{@"cmd":@"getQuestionByQID",
                              @"userID":(userMod ? userMod.userID : @""),
                              @"qID":(_questionID ? _questionID : @""),
                              @"pageSize":@20,
                              @"page":@(0),
                              @"maxAID":@(0),
                              @"aID":(_answerID ? _answerID : @"")
                              };
    [[AskHttpLink shareInstance] post:SERVER_URL bodyparam:infoDic backData:NetSessionResponseTypeJSON success:^(id response) {
        
        GCD_MAIN((^{
            
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
            
            if (response && ([response[@"status"] intValue] == 1)) {
                
                if (response[@"data"][@"question"] && ![response[@"data"][@"question"] isKindOfClass:[NSNull class]]) {
                    
                    AskDataModel *mod = [[AskDataModel alloc] init];
                    [mod refreshModel:response[@"data"][@"question"]];
                    weakSelf.questionTitle = mod.questionTitle;
                    weakSelf.titleLabel.text = mod.questionTitle;
                    
                }
                
                NSDictionary *dic = [response[@"data"][@"answer"][@"data"] lastObject];
                if (dic) {
                    AnswerDataModel *answerMod = [[AnswerDataModel alloc] init];
                    [answerMod refreshModel:dic];
                    weakSelf.model = answerMod;
                }
                
                [weakSelf.contentTableView reloadData];
                
            } else {
                
                [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:response[@"msg"] viewtag:1 AfterDelay:1.5];
                
            }
            
        }));
        
    } requestHead:nil faile:^(NSError *error) {
        
        GCD_MAIN(^{
            
            [AskProgressHUD AskHideAnimatedInView:weakSelf.view viewtag:1 AfterDelay:0];
            [AskProgressHUD AskShowOnlyTitleInView:weakSelf.view Title:@"网络连接错误" viewtag:1 AfterDelay:1.5];
            
        });
        
    }];
    
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_model) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = HEX_RGBA_COLOR(0xEFEFF4, 1);
    
    UIView *titleBGView = [[UIView alloc] init];
    titleBGView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleBGView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleBGView addSubview:_titleLabel];
    
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:bgView];
    
    CGFloat headImgWidth = 30;
    _UserHeadImageView = [[UIImageView alloc] init];
    _UserHeadImageView.contentMode = UIViewContentModeScaleAspectFit;
    _UserHeadImageView.layer.masksToBounds = YES;
    _UserHeadImageView.layer.cornerRadius = headImgWidth / 2;
    _UserHeadImageView.image = [UIImage imageNamed:@"默认头像.png"];
    [bgView addSubview:_UserHeadImageView];
    
    _UserNameLabel = [[UILabel alloc] init];
    _UserNameLabel.font = [UIFont systemFontOfSize:13];
    _UserNameLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    _UserNameLabel.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_UserNameLabel];
    
    _CommDate = [[UILabel alloc] init];
    _CommDate.font = [UIFont systemFontOfSize:13];
    _CommDate.textColor = HEX_RGBA_COLOR(0x999999, 1);
    _CommDate.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:_CommDate];
    
    _SeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _SeeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_SeeBtn setImage:[UIImage imageNamed:@"查看.png"] forState:UIControlStateNormal];
    [_SeeBtn setTitleColor:HEX_RGBA_COLOR(0x999999, 1) forState:UIControlStateNormal];
    _SeeBtn.userInteractionEnabled = NO;
    [bgView addSubview:_SeeBtn];
    
    //点赞数量
    _LikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _LikeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_LikeBtn setTitleColor:HEX_RGBA_COLOR(0x999999, 1) forState:UIControlStateNormal];
    [_LikeBtn setImage:[UIImage imageNamed:@"点赞-回复.png"] forState:UIControlStateNormal];
    [_LikeBtn setImage:[UIImage imageNamed:@"点赞-回复.png"] forState:UIControlStateHighlighted];
    [_LikeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_LikeBtn];
    
    
    [titleBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
        make.height.offset(50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBGView.mas_top).offset(5);
        make.bottom.equalTo(titleBGView.mas_bottom).offset(-5);
        make.left.equalTo(titleBGView.mas_left).offset(10);
        make.right.equalTo(titleBGView.mas_right).offset(-10);
    }];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBGView.mas_bottom).offset(10);
        make.bottom.equalTo(headerView.mas_bottom).offset(-1);
        make.left.equalTo(headerView.mas_left);
        make.right.equalTo(headerView.mas_right);
    }];

    [_UserHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_UserHeadImageView.superview.mas_centerY);
        make.left.equalTo(_UserHeadImageView.superview.mas_left).offset(10);
        make.width.offset(headImgWidth);
        make.height.equalTo(_UserHeadImageView.mas_width);
    }];

    [_UserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_UserHeadImageView.mas_centerY).offset(-10);
        make.left.equalTo(_UserHeadImageView.mas_right).offset(10);
        make.height.offset(20);
        make.right.lessThanOrEqualTo(_SeeBtn.mas_left).offset(-30);
    }];

    [_CommDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_UserHeadImageView.mas_centerY).offset(10);
        make.left.equalTo(_UserNameLabel.mas_left);
        make.height.equalTo(_UserNameLabel.mas_height);
        make.right.lessThanOrEqualTo(_SeeBtn.mas_left).offset(-30);
    }];
    
    [_SeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_LikeBtn.mas_centerY);
        make.right.equalTo(_LikeBtn.mas_left).offset(-30);
    }];
    
    [_LikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView.mas_centerY);
        make.right.equalTo(bgView.mas_right).offset(-10);
    }];
    
    
    if (_model) {
        
        _titleLabel.text = _questionTitle;
        
        if (_model.isAnonymous) { //匿名
            _UserHeadImageView.image = [UIImage imageNamed:@"默认头像.png"];
            _UserNameLabel.text = @"匿名";
        } else {
            [_UserHeadImageView sd_setImageWithURL:[NSURL URLWithString:_model.headImageUrlStr] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
            _UserNameLabel.text = _model.nickName;
        }
        
        _CommDate.text = _model.dateStr;
        
        NSString *numStr = _model.lookNum <= 0 ? @"" : [NSString stringWithFormat:@" %lu", _model.lookNum];
        [_SeeBtn setTitle:numStr forState:UIControlStateNormal];
        
        numStr = _model.likeNum <= 0 ? @"" : [NSString stringWithFormat:@" %lu", _model.likeNum];
        UIImage *likeImg = _model.isLike ? [UIImage imageNamed:@"点赞-回复-按下"] : [UIImage imageNamed:@"点赞-回复"];
        UIColor *likeTextColor = _model.isLike ? HEX_RGBA_COLOR(0x0B98F2, 1) : HEX_RGBA_COLOR(0x969CA1, 1);
        [_LikeBtn setTitleColor:likeTextColor forState:UIControlStateNormal];
        [_LikeBtn setTitle:numStr forState:UIControlStateNormal];
        [_LikeBtn setImage:likeImg forState:UIControlStateNormal];
        [_LikeBtn setImage:likeImg forState:UIControlStateHighlighted];
    }
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = HEX_RGBA_COLOR(0x333333, 1);
    cell.textLabel.numberOfLines = 0;
    
    if (_model) {
        NSMutableString *s = [NSMutableString string]; 
        [s appendString:_model.answerContent];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineHeightMultiple = 1.5; //行间距倍数
        [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, s.length)];
        cell.textLabel.attributedText = str;
    } else {
        cell.textLabel.text = @"";
    }
    
    return cell;
}

@end
