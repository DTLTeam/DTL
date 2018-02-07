//
//  MyRefreshAutoGifFooter.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyRefreshAutoGifFooter.h"


@interface MyRefreshAutoGifFooter()

@property (nonatomic,strong)FLAnimatedImageView *animaImgView;

@end

@implementation MyRefreshAutoGifFooter

- (FLAnimatedImageView *)animaImgView{
    if (!_animaImgView) {
        _animaImgView = [[FLAnimatedImageView alloc] init];
        
        [self addSubview:_animaImgView];
        
    }
    return _animaImgView;
}

-(void)setUpGifImage:(NSString *)gif{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:gif ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
    _animaImgView.animatedImage = animatedImage;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = 20;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.animaImgView.constraints.count) return;
 
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.1 animations:^{
        self.mj_h = self.animaImgView.animatedImage.size.width; //更改默认高度
        [self layoutIfNeeded];
    }];
    
    self.animaImgView.frame = self.bounds;
    if (self.isRefreshingTitleHidden) {
        self.animaImgView.contentMode = UIViewContentModeCenter;
    } else {
        self.animaImgView.mj_w = self.animaImgView.animatedImage.size.width / 2 ;
        self.animaImgView.mj_h = self.animaImgView.animatedImage.size.width / 2 ;
        self.animaImgView.mj_x = self.mj_w * 0.5 - self.labelLeftInset - self.stateLabel.mj_textWith * 0.5 - 15;
        self.animaImgView.mj_y = (self.mj_h - self.animaImgView.mj_h) / 2;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateRefreshing) {
        FLAnimatedImage *img = self.animaImgView.animatedImage;
        if (!img) return;
        [self.animaImgView stopAnimating];
        
        self.animaImgView.hidden = NO;
        
    } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.animaImgView stopAnimating];
        self.animaImgView.hidden = YES;
    }
}
 

@end
