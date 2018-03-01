//
//  QJVersionUpdateVIew.m
//  QJVersionUpdateView
//
//  Created by Justin on 16/3/8.
//  Copyright © 2016年 Justin. All rights reserved.
//

#import "QJVersionUpdateVIew.h"
#import "Masonry.h"

#define MSCREEN_HEIGHT ( IS_IPHONE_X ? 667 : SCREEN_HEIGHT)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#define WIDTH  Screen_Width * 580/2/375
#define HEIGHT Screen_Height * 627/2/667
#define SPACE  Screen_Height * 50/667
#define TITLEFONT 14
#define VERSIONFONT 15*Screen_Height/667
#define WIDTHSPACE Screen_Width * 15/375
// 屏幕宽高
#define Screen_Width    ([UIScreen mainScreen].bounds.size.width)
#define Screen_Height   ([UIScreen mainScreen].bounds.size.height)
#define WindowView      [[UIApplication sharedApplication] keyWindow]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define NavigationBarColor UIColorFromRGB(0x60689f)
#define SYSTEMVERSION [[[UIDevice currentDevice] systemVersion] floatValue]



@interface QJVersionUpdateVIew()<UITableViewDataSource,UITableViewDelegate>

/**
 *  头部视图
 */
@property(nonatomic, strong)UIView *topView;

/**
 *  标题
 */
@property(nonatomic, strong)UILabel *titleLablel;

/**
 *  版本
 */
@property(nonatomic, strong)UILabel *VersionLabel;


/**
 *  描述tableView
 */
@property(nonatomic, strong)UITableView *describeTableView;

/**
 *  描述内容
 */
@property(nonatomic, strong)NSArray *DescribeArr;

/**
 *  稍后提醒
 */
@property(nonatomic, strong)UIButton *laterBt;

/**
 *  立即更新
 */
@property(nonatomic, strong)UIButton *rightNowBt;

/**
 *  蒙版
 */
@property(nonatomic, strong)UIView *backView;

@end

@implementation QJVersionUpdateVIew


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWith:(NSString *)version Describe:(NSArray *)describeArr
{
    self = [super init];
    if (self) {
        self.frame = [self getViewFrame];
        self.backgroundColor = [UIColor whiteColor];
        [self loadData:version];
        self.DescribeArr = describeArr;
        self.layer.cornerRadius = 10;
        [self show];
        [self addSubview:self.describeTableView];
        [self addSubview:self.rightNowBt];
        [self addSubview:self.laterBt];
        [WindowView addSubview:self.backView];
        [WindowView bringSubviewToFront:self];
        
        
    }
    return self;
}

-(void)layoutSubviews
{
    [self.describeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
 
    
    [self.laterBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.describeTableView.mas_right).offset(35);
        make.top.equalTo(self.describeTableView.mas_top).offset(-30);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [self.rightNowBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.describeTableView.mas_centerX);
        make.top.equalTo(self.describeTableView.mas_bottom).offset(-SPACE/1.2 - 20);
        make.size.mas_equalTo(CGSizeMake(WIDTH * 0.6, IS_IPHONE_X ? MSCREEN_HEIGHT * 40/667 :  MSCREEN_HEIGHT * 50/667));
    }];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(WindowView);
    }];
    
}

-(CGRect)getViewFrame
{
    CGRect frame = CGRectZero;
    frame.size.height = MSCREEN_HEIGHT * 0.55;
    frame.size.width = WIDTH;
    frame.origin.x = (Screen_Width - WIDTH)/2;
    frame.origin.y = IS_IPHONE_X ? (MSCREEN_HEIGHT - MSCREEN_HEIGHT * 0.55 - 44 - 24) / 2 : (MSCREEN_HEIGHT - MSCREEN_HEIGHT * 0.55 ) / 2;
    return frame;
}

- (void)loadData:(NSString *)versionStr
{
    self.titleLablel.text = @"发现新版本";
}
-(UILabel *)titleLablel
{
    if (_titleLablel == nil) {
        _titleLablel = [[UILabel alloc] init];
        _titleLablel.font = [UIFont systemFontOfSize:TITLEFONT];
        _titleLablel.textColor = UIColorFromRGB(0x888888);
        _titleLablel.textAlignment = NSTextAlignmentLeft;
        _titleLablel.numberOfLines = 0;
    }
    return _titleLablel;
}

-(UITableView *)describeTableView
{
    if (_describeTableView == nil) {
        _describeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _describeTableView.delegate = self;
        _describeTableView.dataSource = self;
        _describeTableView.showsHorizontalScrollIndicator = NO;
        _describeTableView.showsVerticalScrollIndicator = NO;
        _describeTableView.scrollEnabled = [self IfScrollEnabled];
        _describeTableView.layer.cornerRadius = 7;
        _describeTableView.backgroundColor = [UIColor whiteColor];
        _describeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _describeTableView;
}

-(UIButton *)laterBt
{
    if (_laterBt == nil) {
        _laterBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_laterBt setImage:[UIImage imageNamed:@"xx"] forState:UIControlStateNormal];
        [_laterBt addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _laterBt;
}

-(UIButton *)rightNowBt
{
    if (_rightNowBt == nil) {
        _rightNowBt = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightNowBt setTitle:@"立即升级" forState:UIControlStateNormal];
//        [_rightNowBt setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//        [_rightNowBt setTitleColor:UIColorFromRGB(0x716fd7) forState:UIControlStateHighlighted];
        _rightNowBt.titleLabel.font = [UIFont systemFontOfSize:TITLEFONT + 2];
        
        [_rightNowBt setBackgroundImage:[UIImage imageNamed:@"立即升级"] forState:UIControlStateNormal];
        
        [_rightNowBt addTarget:self action:@selector(goToAppStore) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNowBt;
}

- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5f;
        _backView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _backView;
}

- (void)show
{
    [WindowView addSubview:self];
    __block CGFloat h = MSCREEN_HEIGHT * 0.55 * 0.7 + SPACE/1.2 + 40;
    [self.DescribeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        h += [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:self.DescribeArr[idx]];
    }];
                 
    [UIView animateWithDuration:0.25 animations:^{
        
        self.frame = CGRectMake((Screen_Width - WIDTH)/2, ([UIScreen mainScreen].bounds.size.height - h) / 2 , WIDTH, h);
        
    }];
    /*  //抖动
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    [animation setDelegate:self];
    animation.values = @[@(M_PI/64),@(-M_PI/64),@(M_PI/64),@(0)];
    animation.duration = 0.5;
    [animation setKeyPath:@"transform.rotation"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:@"shake"];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MSCREEN_HEIGHT * 0.55 * 0.7;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    _topView = [[UIView alloc]init]; 
    [self addSubview:_topView];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(_describeTableView);
        make.height.equalTo(@(MSCREEN_HEIGHT * 0.55 * 0.7));
    }];
    
    //头部
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new"]];
    [_topView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(_topView);
        make.height.equalTo(@(MSCREEN_HEIGHT * 0.55 * 0.55));
    }];
    
    [_topView addSubview:self.titleLablel];
    
    [_titleLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_topView.mas_right);
        make.top.mas_equalTo(img.mas_bottom).offset(5);
        make.height.equalTo(@(MSCREEN_HEIGHT * 0.55 * 0.2));
        make.left.mas_equalTo(_topView.mas_left);
    }];
    _titleLablel.textAlignment = NSTextAlignmentCenter;
    
    return _topView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DescribeArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHight = [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:self.DescribeArr[indexPath.row]];
    return rowHight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"statusCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    [self configCellSubViews:cell Index:indexPath.row];
    return cell;
}

/**
 *  计算高度
 *
 *  @param width   label width
 *  @param font    label font
 *  @param content label content
 *
 *  @return hight
 */
- (float)calculateSizeWithWidth:(float)width font:(UIFont *)font content:(NSString *)content
{
   
    CGSize maximumSize =CGSizeMake(width,9999);
    NSDictionary *textDic = @{NSFontAttributeName : font};
    CGSize contentSize = [content boundingRectWithSize:maximumSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    CGSize oneLineSize = [@"test" boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:textDic context:nil].size;
    return (contentSize.height/oneLineSize.height) * 10 + contentSize.height;
    
}

- (void)configCellSubViews:(UITableViewCell *)cell Index:(NSInteger)index
{
    NSString *contentStr = self.DescribeArr[index];
    UILabel *DescribeLabel = [[UILabel alloc] init];
    DescribeLabel.font = [UIFont systemFontOfSize:TITLEFONT];
    DescribeLabel.numberOfLines = 0;
    DescribeLabel.text = contentStr;
    DescribeLabel.textColor = UIColorFromRGB(0x3c3c3c);
    [cell.contentView addSubview:DescribeLabel];
    
    CGFloat rowHight = [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:contentStr];
    [DescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.height.mas_equalTo(rowHight);
        make.left.equalTo(cell.contentView).offset(20);
        make.right.equalTo(cell.contentView).offset(-20); 
    }];
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    [DescribeLabel setAttributedText:attributedString];
    
    DescribeLabel.textAlignment = NSTextAlignmentCenter;
    
}

-(BOOL)IfScrollEnabled
{
    BOOL ee;
    float height;
    height = [self returnRowHight:0 Index:0];
    ee = height < HEIGHT - 80 - SPACE || height == HEIGHT - 80 - SPACE ? NO : YES;
    return ee;
}

- (float)returnRowHight:(float)height Index:(NSInteger)index
{
    if (index > self.DescribeArr.count - 1) {
        return height;
    }else{
        height = height + [self calculateSizeWithWidth:WIDTH - 40 font:[UIFont systemFontOfSize:VERSIONFONT] content:self.DescribeArr[index]];
        index ++;
        return [self returnRowHight:height Index:index];
    }
    return 0;
}

- (void)removeView
{
    [UIView animateWithDuration:0.25 animations:^{
        [self setFrame:CGRectMake((Screen_Width - WIDTH)/2, MSCREEN_HEIGHT, WIDTH, MSCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        self.backView = nil;
        [self removeFromSuperview];
        if (self.removeUpdateViewBlock) {
            self.removeUpdateViewBlock();
        }
    }];
    
}

- (void)goToAppStore
{
    if (self.GoTOAppstoreBlock) {
        self.GoTOAppstoreBlock();
    }
    [self removeView];
}


@end
