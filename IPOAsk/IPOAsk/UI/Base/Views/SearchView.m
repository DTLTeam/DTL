//
//  SearchView.m
//  IPOAsk
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 law. All rights reserved.
//

#import "SearchView.h"

@interface SearchView()<UITextFieldDelegate>


@property (nonatomic,strong)UITextField *TextField;


@property (nonatomic,strong)void (^(SearchClick))(NSString * searchtext);

@property (nonatomic,strong)void (^(AnswerClick))(BOOL answer);


@end

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame SearchClick:(void (^)(NSString *))searchClick WithAnswerClick:(void (^)(BOOL))answerclick{
    
    self = [super initWithFrame:frame];
    
    if (self) {
     
        _SearchClick = searchClick;
        
        _AnswerClick = answerclick;
        
        [self setUpViews];
        
    }
    
    return self;
}

- (void)setUpViews{
    
    UIView *aView = [[UIView alloc] init];
    aView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    aView.layer.borderWidth = 0.5;
    [self addSubview:aView];
    
    [aView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self).offset(-50);
        make.bottom.mas_equalTo(self).offset(-5);
    }];
    
    
    UIImageView *img = [[UIImageView alloc] init];
    img.backgroundColor = [UIColor greenColor];
    [aView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(aView.mas_left).offset(5);
        make.centerY.mas_equalTo(aView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15,15));
    }];
    
    UIButton * answerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [answerbtn setBackgroundColor:[UIColor clearColor]];
    [answerbtn setBackgroundColor:[UIColor greenColor]];
    [answerbtn addTarget:self action:@selector(answerclick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:answerbtn];
    
    [answerbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(aView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _TextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, aView.bounds.size.width - 60, aView.bounds.size.height - 20)];
    _TextField.placeholder = @"输入关键字搜索感兴趣的问题";
    _TextField.delegate = self;
    [aView addSubview:_TextField];
    
    [_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(img.mas_right).offset(5);
        make.centerY.mas_equalTo(aView.mas_centerY);
        make.right.mas_equalTo(answerbtn.mas_left).offset(-5);
    }];
    
    
}

- (void)answerclick:(UIButton *)sender{
    
    [self endEditing:YES];
    
    _AnswerClick(sender);
    
}

-(void)StopSearch{
    [_TextField endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    _SearchClick([NSString stringWithFormat:@"%@%@",textField.text,string]);
    
    return YES;
}

@end
