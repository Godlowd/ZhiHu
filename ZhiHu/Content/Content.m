//
//  Content.m
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "Content.h"
#import <AFNetworking.h>
@implementation Content
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self fetchZhiHu];
    return self;
}

-(void)fetchZhiHu{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"https://news-at.zhihu.com/api/4/story/9712509/short-comments";
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                // 请求进度

             }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        for (NSDictionary *dict in [responseObject valueForKey:@"comments"]) {
//            NSLog(@"%@",[dict valueForKey:@"author"]);
//            NSLog(@"%@",[dict valueForKey:@"content"]);
        }

             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {

                 NSLog(@"请求失败：%@",error);

             }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
