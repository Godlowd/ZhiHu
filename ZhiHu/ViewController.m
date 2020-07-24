//
//  ViewController.m
//  ZhiHu
//
//  Created by New on 2020/7/22.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UserComment.h"
#import "CommentDataModel+CoreDataClass.h"
#import "CommentDataModel+CoreDataProperties.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPersistentContainer];
    [self pageInit];
//    [self contentInit];
    
    [self commentInit];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.page.comment setCommentCell];
        [self.page.content setArticle];
    });

    // Do any additional setup after loading the view.
}

-(void)getPersistentContainer{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.container = delegate.persistentContainer;
}
#pragma mark Init
-(void)pageInit{
    _page = [[Page alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _page.backgroundColor = UIColor.greenColor;
       [self.view addSubview:_page];
       [_page mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self.view);
       }];
    
}

-(void)commentInit{
    Comment *comment = [[Comment alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * 0.4)];
    comment.backgroundColor = UIColor.yellowColor;
    NSBlockOperation *fetch = [NSBlockOperation blockOperationWithBlock:^{
        [comment fetchZhiHuComment];
       
    }];
     self.page.comment = comment;
    self.page.comment.delegate = self;
    [self.page addSubview:self.page.comment];
    [self.page.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.3);
    }];
    //2.任务二：打水印
    NSBlockOperation *storeComment = [NSBlockOperation blockOperationWithBlock:^{
        [self storeComment];
    }];

    
    //4.设置依赖
    [storeComment addDependency:fetch];
//
    Content *content = [[Content alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * 0.6)];
    content.backgroundColor = UIColor.blueColor;
    self.page.content = content;
    [self.page addSubview:self.page.content];
    [self.page.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.7);
    }];
    NSBlockOperation *fetchContent = [NSBlockOperation blockOperationWithBlock:^{
        [content fetchZhiHu];
    }];
    
    
    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[fetchContent,storeComment, fetch] waitUntilFinished:NO];
    
}

-(void)storeComment{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    // 传入上下文，创建一个Person实体对象
    NSLog(@"store ");
    for (UserComment *user in self.page.comment.commentArray) {
        NSManagedObject *comment = [NSEntityDescription insertNewObjectForEntityForName:@"CommentDataModel" inManagedObjectContext:self.container.viewContext];
        // 设置Person的简单属性
        [comment setValue:user.name forKey:@"author"];
        [comment setValue:user.content forKey:@"content"];
        [comment setValue:user.avatar forKey:@"avatar"];
        // 利用上下文对象，将数据同步到持久化存储库
        NSError *error = nil;
        BOOL success = [self.container.viewContext save:&error];
        if (!success) {
            [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        }
    }
    dispatch_semaphore_signal(semaphore);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
-(void)search{
    
    // 初始化一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    request.entity = [NSEntityDescription entityForName:@"CommentDataModel" inManagedObjectContext:self.container.viewContext];
    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
    // 执行请求
    NSError *error = nil;
    NSArray *objs = [self.container.viewContext executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        NSLog(@"name=%@", [obj valueForKey:@"author"]);
    }
}


-(void)setCommentCell{
    self.page.comment.container = UIView.new;
    self.page.comment.pagingEnabled = true;
}

-(void)test{
    Comment *verticalScrollView = [[Comment alloc] init];
    verticalScrollView.backgroundColor = [UIColor greenColor];
    verticalScrollView.pagingEnabled =YES;
    // 添加scrollView添加到父视图，并设置其约束
    [self.view addSubview:verticalScrollView];
    [verticalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.bottom.and.right.mas_equalTo(-10.0);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.25);
    }];
    // 设置scrollView的子视图，即过渡视图contentSize，并设置其约束
    UIView *verticalContainerView = [[UIView alloc] init];
    [verticalScrollView addSubview:verticalContainerView];
    [verticalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.and.right.equalTo(verticalScrollView);
            make.width.equalTo(verticalScrollView);//垂直滚动宽度固定，这个很重要
        make.bottom.equalTo(verticalScrollView.mas_bottom);
    }];
    //过渡视图添加子视图
    UIView *lastView =nil;
    MASViewAttribute *lastviewbottom = nil;
    for (UserComment *user in self.page.comment.commentArray) {
        int num = self.page.comment.commentArray.count;
        NSLog(@"the num is %d",num);
            UILabel *label = UILabel.new;
            label.text = user.content;
            [verticalScrollView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.right.equalTo(self.container);
                make.height.mas_equalTo(verticalScrollView.mas_height).multipliedBy(0.25);
                
               if (lastView)  {
                    make.top.mas_equalTo(lastView.mas_bottom);
                }
                else  {
                    make.top.mas_equalTo(0);
                }
            }];
            
            lastView = label;
    }

}

@end
