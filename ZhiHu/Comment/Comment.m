//
//  Comment.m
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "Comment.h"
#import <AFNetworking.h>
#import "UserComment.h"
#import "CommentCell.h"
#import <Masonry.h>
@implementation Comment
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.commentArray = NSMutableArray.new;
    _subcell = NSMutableArray.new;
    return self;
}



-(void)setCommentCell{
    NSLog(@"start to set cell");
    _container = [[UIView alloc] init];
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
    _container.backgroundColor = UIColor.lightGrayColor;
    self.scrollEnabled = true;
    __strong UIView *lastView = nil;
    if (self.commentArray.count == 0) {
        NSLog(@"没有数据!");
        return;
    }
    for (NSUInteger num = 0; num < self.commentArray.count; num++) {
        CommentCell *cell = [[CommentCell alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        UserComment *user = [self.commentArray objectAtIndex:num];
        cell.author.text = user.name;
        cell.content.text = user.content;
        cell.backgroundColor = UIColor.whiteColor;
        [_container addSubview:cell];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.container);
//            make.height.equalTo(self.mas_height).multipliedBy(0.25);
            if (!lastView) {
                make.top.mas_equalTo(0);
            }
            else{
                make.top.mas_equalTo(lastView.mas_bottom);
            }
        }];
        
        lastView = cell;
    }
//    for (UserComment *user in self.commentArray) {
//        CommentCell *cell = [[CommentCell alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
//        cell.author.text = user.name;
//        cell.content.text = user.content;
//        cell.backgroundColor = UIColor.redColor;
//        [_container addSubview:cell];
//        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.equalTo(_container);
//            make.height.equalTo(_container.mas_height).multipliedBy(0.25);
//            if (!lastView) {
//                make.top.equalTo(0);
//            }
//            else{
//                make.top.equalTo(lastView.mas_bottom);
//            }
//        }];
//
//        lastView = cell;
//
////        if (!lastView) {
////            [_container mas_updateConstraints:^(MASConstraintMaker *make) {
////                make.bottom.equalTo(self.mas_bottom);
////            }];
////    }
//}
    if (lastView) {
           [_container mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.equalTo(lastView.mas_bottom);
         }];
    }
    else{
        NSLog(@"failed");
    }
 
//
//    _container = [[UIView alloc] initWithFrame:UIScreen.mainScreen.bounds];
//    [self addSubview:_container];
//    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.bottom.and.right.equalTo(self);
//        make.width.equalTo(self);
//    }];
//    self.pagingEnabled =YES;
//    UIView *lastView =nil;
//
//    __block CommentCell *formercell = nil;
//    static int cellcount = -1;
//
//    for (UserComment *user in _commentArray) {
//
//        cellcount++;
////        CommentCell *cell = [[CommentCell alloc] initWithFrame:CGRectMake(0, 50 * cellcount, self.bounds.size.width, 50)];
////        NSLog(@"the y is %d",50 * (cellcount +1));
////        cell.tag = cellcount;
////        [_subcell addObject:cell];
////        cell.author.text = user.name;
////        cell.content.text = user.content;
////        cell.backgroundColor = UIColor.blackColor;
////        [self.container addSubview:cell];
////
////        NSLog(@"the former cell's tag is %lu",formercell.tag);
////        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.left.and.right.equalTo(self.container);
////            make.height.mas_equalTo(self.container.mas_height).multipliedBy(0.25);
////            if (!formercell) {
////                make.top.mas_equalTo(0);
////            }
////            else{
////                make.top.mas_equalTo(formercell.mas_bottom);
////        }
////
////            formercell = cell;
//////            make.top.equalTo(formercell.mas_bottom);
////        }];
//        UILabel *label = UILabel.new;
//        label.text = user.content;
//        [self.container addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.and.right.equalTo(self.container);
//            make.height.mas_equalTo(self.container.mas_height).multipliedBy(0.25);
//
//           if (lastView)  {
//                make.top.mas_equalTo(lastView.mas_bottom);
//            }
//            else  {
//                make.top.mas_equalTo(0);
//            }
//        }];
//
//        lastView = label;
//    }
//
//    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(lastView.mas_bottom);
//    }];
//    [self layoutIfNeeded];
}

-(void)fetchZhiHuComment{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = @"https://news-at.zhihu.com/api/4/story/9712509/short-comments";
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                         // 请求进度

                      }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSLog(@"fetch data successfully");
                 for (NSDictionary *dict in [responseObject valueForKey:@"comments"]) {
                     UserComment *user = UserComment.new;
                     user.name = [dict valueForKey:@"author"];
                     user.content = [dict valueForKey:@"content"];
                     user.avatar = [dict valueForKey:@"avatar"];
                     [self.commentArray addObject:user];
                     NSLog(@"the author is %@",[dict valueForKey:@"author"]);
                     NSLog(@"the content is %@",[dict valueForKey:@"content"]);
                 }
                 dispatch_semaphore_signal(semaphore);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
                          NSLog(@"请求失败：%@",error);
                 dispatch_semaphore_signal(semaphore);
                 self.commentArray = nil;
                      }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


@end
