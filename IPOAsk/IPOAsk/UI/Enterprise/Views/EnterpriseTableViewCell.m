//
//  EnterpriseTableViewCell.m
//  IPOAsk
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 law. All rights reserved.
//

#import "EnterpriseTableViewCell.h"

//View
#import "EnterpriseAnswerTableViewCell.h"

@interface EnterpriseTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UILabel       *questionTitleLabel;
@property (strong, nonatomic) UITableView   *answerTableView;

@property (strong, nonatomic) NSArray<AnswerModel *> *answerItems;

@end

@implementation EnterpriseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupInterface];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupInterface];
    }
    return self;
}


#pragma mark - 界面

- (void)setupInterface {
    
    _questionTitleLabel = [[UILabel alloc] init];
    _questionTitleLabel.textAlignment = NSTextAlignmentLeft;
    _questionTitleLabel.textColor = HEX_RGBA_COLOR(0x666666, 1);
    _questionTitleLabel.font = [UIFont systemFontOfSize:17];
    _questionTitleLabel.numberOfLines = 0;
    [self addSubview:_questionTitleLabel];
    
    _answerTableView = [[UITableView alloc] init];
    _answerTableView.backgroundColor = [UIColor whiteColor];
    _answerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _answerTableView.scrollEnabled = NO;
    _answerTableView.rowHeight = UITableViewAutomaticDimension;
    _answerTableView.estimatedRowHeight = 9999;
    _answerTableView.delegate = self;
    _answerTableView.dataSource = self;
    _answerTableView.showsVerticalScrollIndicator = NO;
    _answerTableView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_answerTableView];
    
    [_questionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(15);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
        } else {
            make.top.equalTo(self.mas_top).offset(15);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }
    }];
    
    [_answerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_questionTitleLabel.mas_safeAreaLayoutGuideBottom).offset(15);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.top.equalTo(_questionTitleLabel.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }
    }];
    
}


#pragma mark - 功能

- (void)updateWithModel:(EnterpriseModel *)model likeClick:(likeClick)likeClickBlock {
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的问题:  %@", model.questionMod.title]];
    NSRange range = NSMakeRange(0, [content.string length]);
    [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:range];
    [content addAttribute:NSForegroundColorAttributeName value:HEX_RGBA_COLOR(0x666666, 1) range:range];
    range = NSMakeRange(0, 5);
    [content addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:range];
    [content addAttribute:NSForegroundColorAttributeName value:HEX_RGBA_COLOR(0x333333, 1) range:range];
    _questionTitleLabel.attributedText = content;
    
    _answerItems = model.answerItems;
    [_answerTableView reloadData];
    [_answerTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(_questionTitleLabel.mas_safeAreaLayoutGuideBottom).offset(15);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).offset(-10);
            if (_answerItems.count == 0) {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            } else {
                make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).offset(-10);
            }
        } else {
            make.top.equalTo(_questionTitleLabel.mas_bottom).offset(15);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            if (_answerItems.count == 0) {
                make.bottom.equalTo(self.mas_bottom);
            } else {
                make.bottom.equalTo(self.mas_bottom).offset(-10);
            }
        }
//        make.height.offset(_answerTableView.contentSize.height);
    }];
    
}

- (void)Like {
   
    
    
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _answerItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"answerCell";
    
    EnterpriseAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EnterpriseAnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell refreshWithModel:_answerItems[indexPath.section]];
    
    return cell;
    
}

@end
