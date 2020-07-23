//
//  CommentCell.m
//  ZhiHu
//
//  Created by New on 2020/7/22.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "CommentCell.h"
#import <Masonry.h>
@implementation CommentCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    
    _author = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _author.text = @"";
    [self addSubview:_author];
    [_author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    _content.text = @"";
    [self addSubview:_content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.author.mas_bottom).with.offset(20);
        make.left.equalTo(self.mas_left).with.offset(20);
        make.bottom.equalTo(self.mas_bottom).with.offset(20);
    }];
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
