//
//  EditQuestionViewController.h
//  IPOAsk
//
//  Created by updrv on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

typedef enum : NSUInteger {
    AnswerType_Answer, //回答问题
    AnswerType_AskQuestionPerson, //个人提问
    AnswerType_AskQuestionEnterprise, //企业提问
} AnswerType;

#import "BaseViewController.h"

//Model
#import "DraftsModel.h"

@interface EditQuestionViewController : BaseViewController

@property (strong, nonatomic) NSString *questionID;

/**
 编辑
 **/
- (void)UserType:(AnswerType)type NavTitle:(NSString *)title;


/**
 草稿箱修改
 **/
- (void)EditModel:(DraftsModel *)model  WithHaveChangeClick:(void (^)(BOOL Change))ChangeClick;;

@end
