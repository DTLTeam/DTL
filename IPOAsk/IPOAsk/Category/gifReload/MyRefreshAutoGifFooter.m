//
//  MyRefreshAutoGifFooter.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyRefreshAutoGifFooter.h"

@interface MyRefreshAutoGifFooter()

@end

@implementation MyRefreshAutoGifFooter

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    MyRefreshAutoGifFooter *footer = [super footerWithRefreshingBlock:refreshingBlock];
    if (footer) {
        
        NSMutableArray *imgItems = [NSMutableArray array];
        for (NSInteger i = 0; i <= 5; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"上拉加载_%lu.png", i]];
            [imgItems addObject:img];
        }
        
        [footer setImages:imgItems duration:(0.1 * imgItems.count) forState:MJRefreshStateRefreshing];
        [footer setImages:imgItems duration:(0.1 * imgItems.count) forState:MJRefreshStatePulling];
        
    }
    
    return footer;
    
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateRefreshing || state == MJRefreshStatePulling) {

        if (self.gifView.animationImages.count > 0) { //存在动画图片

            if (self.gifView.hidden) {
                self.gifView.hidden = NO;
            }

        } else { //不存在动画图片

            if (!self.gifView.hidden) {
                self.gifView.hidden = YES;
            }

        }

    } else {

        if (!self.gifView.hidden) {
            self.gifView.hidden = YES;
        }

    }
}

@end
