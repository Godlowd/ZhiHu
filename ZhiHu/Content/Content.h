//
//  Content.h
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Content : UIScrollView
@property(nonatomic, strong) UILabel *content;
@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) NSString *text;

-(void)fetchZhiHu;
-(void)setArticle;
@end

NS_ASSUME_NONNULL_END
