//
//  SearchView.h
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView


-(instancetype)initWithFrame:(CGRect)frame SearchClick:(void (^)(NSString *searchtext))searchClick WithAnswerClick:(void (^)(BOOL answer))answerclick;
 
@end
