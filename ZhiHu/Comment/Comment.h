//
//  Comment.h
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface Comment : UIScrollView
@property(nonatomic, strong) NSMutableArray *commentArray;
@property(nonatomic, strong) NSMutableArray *subcell;
@property(nonatomic, strong) UIView *container;


-(instancetype)initWithFrame:(CGRect)frame;
-(void)fetchZhiHuComment;
-(void)setCommentCell;
-(void)storeComment;
-(void)fetchZhiHuComment2;
-(void)fetchZhiHuComment3;
@end
NS_ASSUME_NONNULL_END

