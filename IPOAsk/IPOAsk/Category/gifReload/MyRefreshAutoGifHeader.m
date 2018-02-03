//
//  MyRefreshAutoGifHeader.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyRefreshAutoGifHeader.h"

@interface MyRefreshAutoGifHeader()

@property (nonatomic,strong)FLAnimatedImageView *animaImgView;

@end

@implementation MyRefreshAutoGifHeader 

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
    
    self.mj_h = 48 + 10; //更改默认高度
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.animaImgView.constraints.count) return;
    
    
    self.animaImgView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.animaImgView.contentMode = UIViewContentModeCenter;
    } else {
        self.animaImgView.contentMode = UIViewContentModeRight;
        self.animaImgView.mj_w = self.mj_w * 0.5 - self.labelLeftInset - self.stateLabel.mj_textWith * 0.5;
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
