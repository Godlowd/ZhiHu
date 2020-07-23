//
//  Page.m
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "Page.h"
#import "Content.h"
#import "Comment.h"
#import <Masonry.h>
@implementation Page
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    

    
    return self;
}

//-(void)commentInit{
//    _commment = [[Comment alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * 0.6)];
//    [self addSubview:_commment];
//    _commment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
