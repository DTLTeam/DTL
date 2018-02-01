//
//  TextFieldViews.m
//  IPOAsk
//
//  Created by adminMac on 2018/1/30.
//  Copyright © 2018年 law. All rights reserved.
//

#import "TextFieldViews.h"

@interface TextFieldViews()

@property (nonatomic,strong)UITextField *textfield;

@property (nonatomic,strong)UILabel *label;

@property (nonatomic,assign)CGFloat Height;



@end

@implementation TextFieldViews

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)textFieldPlaceholder:(NSString *)placeholder KeyboardType:(UIKeyboardType)type SecureTextEntry:(BOOL)secure Height:(CGFloat)height{
    
    _Height = height;
    
    _textfield = [[UITextField alloc]init];
    _textfield.keyboardType = type;
    _textfield.delegate = self;
    _textfield.secureTextEntry = secure;
    _textfield.font = [UIFont systemFontOfSize:15];
    [self addSubview:_textfield];
    
    [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, _Height / 2));
        make.bottom.mas_equalTo(self.mas_bottom); 
    }];
    
    _label = [[UILabel alloc]init];
    _label.text = placeholder;
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = HEX_RGB_COLOR(0x969CA1);
    [self addSubview:_label];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(_Height / 2);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.height.equalTo(@0.5);
    }];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        [self changeFrame:YES];
    }else [self changeFrame:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    
    if (textField.text.length == 0) {
        [self changeFrame:YES];
    }else [self changeFrame:NO];
    
    
}

-(void)changeFrame:(BOOL)hidden{ 
    
    if (hidden) {
        
        if (_textfield.text.length == 0) {
          
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.38 animations:^{
                
                [_label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.mas_equalTo(self);
                    make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
//                    make.top.mas_equalTo(self.mas_top).offset( _Height / 2);
                }];
                
                [self layoutIfNeeded];
            }];
            _label.font = [UIFont systemFontOfSize:15];
            
        }
        
    }else{
        
        [self layoutIfNeeded];
        [UIView animateWithDuration:0.38 animations:^{
            
            [_label mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.mas_equalTo(self);
                make.bottom.mas_equalTo(self.mas_bottom).offset(- _Height / 2 + 10);
//                make.top.mas_equalTo(self.mas_top);
            }];
            [self layoutIfNeeded];
        }];
        _label.font = [UIFont systemFontOfSize:12];
        
    }
}

-(void)changeSecureTextEntry:(BOOL)secure{
    _textfield.secureTextEntry = secure;
}


-(void)changePlaceholderText:(NSString *)text{
    _label.text = text;
}

-(NSString *)text{
    return _textfield.text;
}

-(void)clearText{
    _textfield.text = @"";
    
    [self changeFrame:YES]; 
}
@end
