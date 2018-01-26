//
//  MineHeadView.h
//  IPOAsk
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeadViewDelegate<NSObject>
 
- (void)clickMyQuestion:(UITapGestureRecognizer *)sender;
- (void)clickMyAnswer:(UITapGestureRecognizer *)sender;
- (void)clickMyFollow:(UITapGestureRecognizer *)sender;
- (void)clickMyAchievements:(UITapGestureRecognizer *)sender;

@end

@interface MineHeadView : UIView

@property (nonatomic,weak)id<MineHeadViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *bottomLine;

@end
