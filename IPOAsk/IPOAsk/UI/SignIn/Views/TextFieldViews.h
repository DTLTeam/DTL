//
//  TextFieldViews.h
//  IPOAsk
//
//  Created by adminMac on 2018/1/30.
//  Copyright © 2018年 law. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldViews : UIView<UITextFieldDelegate>



- (void)textFieldPlaceholder:(NSString *)placeholder KeyboardType:(UIKeyboardType)type SecureTextEntry:(BOOL)secure Height:(CGFloat)height;

- (void)changeFrame:(BOOL)hidden;

- (void)changePlaceholderText:(NSString *)text;

- (void)clearText;

- (void)changeSecureTextEntry:(BOOL)secure;

- (NSString *)text;


@end
