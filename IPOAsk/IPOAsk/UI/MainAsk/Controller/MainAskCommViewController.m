//
//  MainAskCommViewController.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MainAskCommViewController.h"

#import "SearchView.h"

@interface MainAskCommViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UserHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *CommDate;
@property (weak, nonatomic) IBOutlet UIButton *SeeBtn;
@property (weak, nonatomic) IBOutlet UIButton *LikeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *CommScrollView; 


@end

@implementation MainAskCommViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    UIButton *lbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIBarButtonItem *leftBtn = [UIBarButtonItem returnTabBarItemWithBtn:lbtn image:@"back" bgimage:nil  Title:@"" SelectedTitle:@" " titleFont:12 itemtype:Itemtype_left SystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    [lbtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    leftBtn = nil;
    
    [self.view addSubview:lbtn];
    
    SearchView *view = [[SearchView alloc]initWithFrame:CGRectMake(44, 20, SCREEN_WIDTH - 44, 44) SearchClick:^(NSString * searchtext) {
        
        NSLog(@"%@",searchtext);
    } WithAnswerClick:^(BOOL answer) {
        NSLog(@"点击发表");
    }];
    
    lbtn.center = CGPointMake(lbtn.center.x, view.center.y);
    
    [self.view addSubview:view];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 更新数据
-(void)UpdateContentWithModel:(AnswerModel *)model{
    
    _TitleLabel.text = model.title;
    _UserNameLabel.text = model.userName;
    _CommDate.text = model.dateStr;
    [_SeeBtn setTitle:[NSString stringWithFormat:@"%ld",model.lookNum] forState:UIControlStateNormal];
    [_LikeBtn setTitle:[NSString stringWithFormat:@"%ld",model.likeNum] forState:UIControlStateNormal];
    
   
    UILabel *commlabel = [[UILabel alloc]init];
    [_CommScrollView addSubview:commlabel];
    commlabel.text = [NSString stringWithFormat:@"%@%@%@",model.content,model.content,model.content];
    commlabel.numberOfLines = 0;
    commlabel.font = [UIFont systemFontOfSize:SCREEN_HEIGHT >= 667 ? 16 : 14];
    
    _CommScrollView.contentSize = CGSizeMake(0, 0);
    
    [commlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(_CommScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH - 24);
    }];
    [commlabel.superview layoutIfNeeded];
    
    _CommScrollView.contentSize = CGSizeMake(0, CGRectGetHeight(commlabel.frame) + 20);
    
    
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
