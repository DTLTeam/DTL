//
//  MyRefreshAutoGifHeader.m
//  IPOAsk
//
//  Created by adminMac on 2018/2/3.
//  Copyright © 2018年 law. All rights reserved.
//

#import "MyRefreshAutoGifHeader.h"

@interface MyRefreshAutoGifHeader()

@end

@implementation MyRefreshAutoGifHeader

+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    
    MyRefreshAutoGifHeader *header = [super headerWithRefreshingBlock:refreshingBlock];
    if (header) {
        
        NSMutableArray *imgItems = [NSMutableArray array];
        for (NSInteger i = 0; i <= 6; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"下拉刷新_%lu.png", i]];
            [imgItems addObject:img];
        }
        
        [header setImages:imgItems duration:(0.1 * imgItems.count) forState:MJRefreshStateRefreshing];
        [header setImages:imgItems duration:(0.1 * imgItems.count) forState:MJRefreshStatePulling];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        
    }
    
    return header;
    
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
