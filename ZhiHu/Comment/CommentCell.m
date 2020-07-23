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
    
    
    _author = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    _author.text = @"";
    [self addSubview:_author];
    [_author mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(50);
    }];
    _author.font = [UIFont systemFontOfSize:20];
    _author.lineBreakMode = NSLineBreakByWordWrapping;
    _author.numberOfLines = 0;
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width-50, 10)];
    _content.text = @"";
    [self addSubview:_content];
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.author.mas_bottom).with.offset(5);
        make.left.equalTo(self.mas_left).with.offset(50);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    _content.font = [UIFont systemFontOfSize:15];
    
    _content.lineBreakMode = NSLineBreakByWordWrapping;
     _content.numberOfLines = 0;
   
    
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
