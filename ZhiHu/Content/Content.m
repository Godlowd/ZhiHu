//
//  Content.m
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "Content.h"
#import <AFNetworking.h>
#import <Masonry.h>
@implementation Content
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.content = UILabel.new;
    self.container = UIView.new;
    return self;
}

-(void)setArticle{
    NSLog(@"start to set article");
    [self addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
     _container.backgroundColor = UIColor.lightGrayColor;
    self.content.numberOfLines = 0;
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    self.scrollEnabled = YES;
    [self.container addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.container);
        make.top.and.bottom.equalTo(self.container);
    }];
}

-(void)fetchZhiHu{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = @"https://news-at.zhihu.com/api/4/story/9712509";
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                // 请求进度

             }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[responseObject valueForKey:@"body"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.content.attributedText = attrStr;
//        self.content.text = [responseObject valueForKey:@"body"];
        NSLog(@"the content is %@", self.content.text);
        dispatch_semaphore_signal(semaphore);
             }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {

                 NSLog(@"请求失败：%@",error);
dispatch_semaphore_signal(semaphore);
             }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


@end
