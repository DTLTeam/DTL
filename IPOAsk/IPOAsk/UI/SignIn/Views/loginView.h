//
//  loginView.h
//  IPOAsk
//
//  Created by adminMac on 2018/1/30.
//  Copyright © 2018年 law. All rights reserved.
//
 

typedef enum : NSUInteger {
    btnType_login = 100,
    btnType_forgot,
    btnType_pass,
    btnType_register,
    
} btnType;

#import <UIKit/UIKit.h>

@interface loginView : UIView

-(instancetype)initWithAction:(void(^)(btnType tag,NSString *userName,NSString *Password))block;

- (void)changeType:(loginType)type;

@end
