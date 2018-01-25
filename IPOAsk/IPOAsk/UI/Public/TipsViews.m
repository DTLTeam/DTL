//
//  TipsViews.m
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "TipsViews.h"

@interface TipsViews()

@property (nonatomic,strong)void(^clicklbtn)(UIButton *btn);

@property (nonatomic,strong)void(^clickrbtn)(UIButton *btn);

@property (nonatomic,assign)int click;

@end

@implementation TipsViews

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _click = 0;
        
        [self setUpViews];
        
    }
    return self;
    
}

#pragma mark - 左边
- (void)leftbtn:(UIButton *)sender{
    _clicklbtn(sender);
}

#pragma mark - 右边
- (void)rightbtn:(UIButton *)sender{
    _clickrbtn(sender);
}


#pragma mark - 显示视图
-(void)showWithContent:(NSString *)content tipsImage:(NSString *)img LeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle block:(void (^)(UIButton *))lblock rightblock:(void (^)(UIButton *))rblock {
    
    _clicklbtn = lblock;
    _clickrbtn = rblock;
    
    [self show];
    
    //替换文字
    if (img) {
        UIImageView *ImageView = [_View viewWithTag:controlTag_img];
        if (ImageView) {
            ImageView.image = [UIImage imageNamed:img];
        }
    }
    
    if (content) {
        UILabel *contentLabel = [_View viewWithTag:controlTag_content];
        if (contentLabel) {
            contentLabel.text = content;
        }
    }
    
    if (leftTitle) {
        UIButton *leftbtn = [_View viewWithTag:controlTag_leftbtn];
        if (leftbtn) {
            [leftbtn setTitle:leftTitle forState:UIControlStateNormal];
        }
    }
    
    if (rightTitle) {
        UIButton *rightbtn = [_View viewWithTag:controlTag_rightbtn];
        if (rightbtn) {
            [rightbtn setTitle:rightTitle forState:UIControlStateNormal];
        }
    }
}

-(void)show{
    
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark - 隐藏视图
- (void)diss:(UITapGestureRecognizer *)sender{
    
    _click++;
    
    if (_click == 1) {
        [self dissmiss];
        _click = 0;
    }
    
}

- (void)dissmiss{
    
    [UIView animateWithDuration:0.38 delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        _clicklbtn = nil;
        _clickrbtn = nil;
        
        [self removeFromSuperview];
        
        
    }];
}

-(void)dealloc{
    NSLog(@"销毁");
}

#pragma mark - 视图
- (void)setUpViews{
    
    //背景虚化
    _bgView = [[UIView alloc]init];
    _bgView.userInteractionEnabled = YES;
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.65;
    _bgView.frame = self.frame;
    [self addSubview:_bgView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(diss:)];
    [_bgView addGestureRecognizer:tap];
    
    //容器
    _View = [[UIView alloc]init];
    _View.backgroundColor = [UIColor whiteColor];
    _View.layer.cornerRadius = 10;
    _View.layer.masksToBounds = YES;
    [self addSubview:_View];
    
    
    
    //tipsClose
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_View.mas_right).offset(-15);
        make.top.mas_equalTo(_View.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.backgroundColor = [UIColor greenColor];
    img.tag = controlTag_img;
    [_View addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom);
        make.centerX.mas_equalTo(_View.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 120));
    }];
    
    
    UILabel * content = [self returnlabelWithColor:HEX_RGB_COLOR(0x333333) TextFont:[UIFont systemFontOfSize:14] Text:@"申请成为答主才可以助力回复小伙伴的问题噢!"];
    content.numberOfLines = 0;
    content.tag = controlTag_content;
    [_View addSubview:content];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_View).mas_equalTo(15);
        make.top.mas_equalTo(img.mas_bottom).offset(15);
        make.right.mas_equalTo(_View.mas_right).offset(-15);
    }];
    
    
    //line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = HEX_RGB_COLOR(0xc8c8c8);
    [_View addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(_View);
        make.top.mas_equalTo(content.mas_bottom).offset(20);
        make.height.mas_equalTo(@0.5);
    }];
    
    //line
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = HEX_RGB_COLOR(0xc8c8c8);
    [_View addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.bottom.mas_equalTo(_View.mas_bottom);
        make.width.mas_equalTo(@0.5);
        make.centerX.mas_equalTo(line.center.x);
    }];
    
    //左按钮
    UIButton * leftbtn = [self returnbtnWithColor:[UIColor lightGrayColor] TextFont:[UIFont systemFontOfSize:18] action:@selector(leftbtn:) Text:NSLocalizedString(@"以后再说", nil)];
    leftbtn.tag = controlTag_leftbtn;
    [_View addSubview:leftbtn];
    
    
    [leftbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_View);
        make.top.mas_equalTo(line.mas_bottom).offset(5);
        make.right.mas_equalTo(line2.mas_left);
        make.height.mas_equalTo(@50);
    }];
    
    UIButton * rightbtn = [self returnbtnWithColor:HEX_RGB_COLOR(0x333333) TextFont:[UIFont boldSystemFontOfSize:18] action:@selector(rightbtn:) Text:NSLocalizedString(@"申请成为答主", nil)];
    rightbtn.tag = controlTag_rightbtn;
    [_View addSubview:rightbtn];
    
    [rightbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_View);
        make.top.mas_equalTo(line.mas_bottom).offset(5);
        make.left.mas_equalTo(line2.mas_right);
        make.height.mas_equalTo(@50);
        
    }];
    
    [_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.bottom.mas_equalTo(rightbtn.mas_bottom);
        make.width.mas_equalTo(SCREEN_HEIGHT >= 667 ? proportionW(320 - 100) : proportionW(280 - 100));
    }];
    
}


#pragma mark - 返回label
- (UILabel *)returnlabelWithColor:(UIColor *)color TextFont:(UIFont *)Font Text:(NSString *)text{
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.font = Font;
    label.textColor = color;
    
    return label;
}

#pragma mark - 返回按钮
- (UIButton *)returnbtnWithColor:(UIColor *)color TextFont:(UIFont *)Font action:(SEL)action Text:(NSString *)text {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = Font;
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

@end
