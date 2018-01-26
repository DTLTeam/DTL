//
//  MineHeadView.m
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MineHeadView.h"

@implementation MineHeadView

#pragma mark - 头部按钮

#pragma mark - 我的提问
- (IBAction)MyQuestion:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(clickMyQuestion:)]) {
        [self.delegate clickMyQuestion:sender];
    }
}

#pragma mark - 我的回答
- (IBAction)MyAnswer:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(clickMyAnswer:)]) {
        [self.delegate clickMyAnswer:sender];
    }
}

#pragma mark - 我的关注
- (IBAction)MyFollow:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(clickMyFollow:)]) {
        [self.delegate clickMyFollow:sender];
    }
    
}

#pragma mark - 我的成就

- (IBAction)MyAchievements:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(clickMyAchievements:)]) {
        [self.delegate clickMyAchievements:sender];
    }
}
@end
