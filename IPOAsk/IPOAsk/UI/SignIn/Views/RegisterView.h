//
//  RegisterView.h
//  IPOAsk
//
//  Created by adminMac on 2018/1/31.
//  Copyright © 2018年 law. All rights reserved.
//

typedef enum : NSUInteger {
    RegisterbtnType_Code = 100,
    RegisterbtnType_Security,
    RegisterbtnType_Register,
    RegisterbtnType_Login,
    RegisterbtnType_Agreement,
    
} RegisterbtnType;

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

-(instancetype)initWithAction:(void(^)(RegisterbtnType type,NSString *phone,NSString *Password,NSString *Code))block;

- (void)changeType:(loginType)type;
 
- (void)clear;


@end
