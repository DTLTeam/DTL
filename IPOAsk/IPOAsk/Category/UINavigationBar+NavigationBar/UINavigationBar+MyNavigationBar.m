//
//  UINavigationBar+MyNavigationBar.m
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "UINavigationBar+MyNavigationBar.h"
#import <objc/runtime.h>


@implementation UINavigationBar (MyNavigationBar)


+(void)load {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [self InstanceMethodWithOriginSel:@selector(layoutSubviews)
                                     dSel:@selector(sx_layoutSubviews)];
    });
}

-(void)sx_layoutSubviews{
    [self sx_layoutSubviews];
    
    if (IS_IOS11LATER) {//需要调节
        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = 0;
        for (UIView *subview in self.subviews) {
            
            if ([NSStringFromClass(subview.class) containsString:@"ContentView"] || [NSStringFromClass(subview.class) containsString:@"ContentView"]    ) {
                subview.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);
                break;
            }
        }
    }
}

+ (void)InstanceMethodWithOriginSel:(SEL)oriSel dSel:(SEL)swiSel {
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method dAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self MethodWithOriginSel:oriSel oriMethod:originAddObserverMethod dSel:swiSel dMethod:dAddObserverMethod class:self];
}

+ (void)MethodWithOriginSel:(SEL)oriSel
                  oriMethod:(Method)oriMethod
                       dSel:(SEL)dSel
                    dMethod:(Method)dMethod
                      class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(dMethod), method_getTypeEncoding(dMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, dSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, dMethod);
    }
}

@end
