//
//  Page.h
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Content.h"
#import "Comment.h"

@interface Page : UIScrollView
@property(nonatomic, strong) Comment *comment;
@property(nonatomic, strong) Content *content;
@end

