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
    });

//    [self searchInfo];
//    [self test];
//    [self storeComment];
    // Do any additional setup after loading the view.
}

-(void)getPersistentContainer{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.container = delegate.persistentContainer;
}

//-(void)storeComment{
//    NSMutableArray *array = _page.comment.commentArray;
//    for (UserComment *comment in array) {
//        CommentDataModel *commentdatamodel = [NSEntityDescription entityForName:@"Comment" inManagedObjectContext:_container.viewContext];
//        commentdatamodel.author = comment.name;
//        commentdatamodel.avatar = comment.avatar;
//        commentdatamodel.content = comment.content;
//
//    }
//    NSError *error = nil;
//    if ([_container.viewContext hasChanges] && ![_container.viewContext save:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}


//-(void)searchInfo{
//    NSLog(@"start to search Info");
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    // 设置要查询的实体
//    request.entity = [NSEntityDescription entityForName:@"CommentDataModel" inManagedObjectContext:self.container.viewContext];
////    // 设置排序（按照age降序）
////    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
////    request.sortDescriptors = [NSArray arrayWithObject:sort];
//    // 设置条件过滤(搜索name中包含字符串"Itcast-1"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*Itcast-1*)
////    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*Itcast-1*"];
////    request.predicate = predicate;
//    // 执行请求
//    NSError *error = nil;
//    NSArray *objs = [self.container.viewContext executeFetchRequest:request error:&error];
//    if (error) {
//        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
//    }
//    // 遍历数据
//    for (NSManagedObject *obj in objs) {
//        NSLog(@"name=%@", [obj valueForKey:@"author"]);
//    }
//}
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
    [self.page addSubview:self.page.comment];
    self.page.comment.delegate = self;
    
    [self.page.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.3);
    }];
    //2.任务二：打水印
    NSBlockOperation *storeComment = [NSBlockOperation blockOperationWithBlock:^{
        [self storeComment];
    }];

    //3.任务三：上传图片
//    NSBlockOperation *setCommentCell = [NSBlockOperation blockOperationWithBlock:^{
//
//    }];

    //4.设置依赖
    [storeComment addDependency:fetch];      //任务二依赖任务一
//    [setCommentCell addDependency:storeComment];      //任务三依赖任务二

    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[storeComment, fetch] waitUntilFinished:NO];
    
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
//-(void)commentInit{
//    _page.comment = [[Comment alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * 0.4)];
//    [_page addSubview:_page.comment];
//    _page.comment.commentArray = [[NSMutableArray alloc] initWithCapacity:30];
//    _page.comment.subcell = NSMutableArray.new;
//    if (_page.comment.commentArray == nil || _page.comment.subcell == nil) {
//        NSLog(@"NSMutableArray create failed");
//    }
//    _page.comment.backgroundColor = UIColor.blueColor;
//    [_page.comment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(self.view.mas_height).multipliedBy(0.25);
//    }];

//
    
////    dispatch_group_async(group, queue, ^{
////        [self searchInfo];
////        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
////    });
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"notify execute");
//    });
////    self.page.comment.commentArray = NSMutableArray.new;
////    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
////        NSString *url = @"https://news-at.zhihu.com/api/4/story/9712509/short-comments";
////        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
////                    // 请求进度
////
////                 }
////             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////             NSLog(@"fetching data");
////            for (NSDictionary *dict in [responseObject valueForKey:@"comments"]) {
////                UserComment *user = UserComment.new;
////                user.name = [dict valueForKey:@"author"];
////                user.content = [dict valueForKey:@"content"];
////                user.avatar = [dict valueForKey:@"avatar"];
////                [self.page.comment.commentArray addObject:user];
////                NSLog(@"%@",[dict valueForKey:@"author"]);
////                NSLog(@"%@",[dict valueForKey:@"content"]);
////            }
////            NSLog(@"in block the num is %lu",(unsigned long)self.page.comment.commentArray.count);
//////            [self.page.comment setCommentCell];
////            [self test];
////
////                 }
////                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
////                     NSLog(@"请求失败：%@",error);
////            _page.comment.commentArray = nil;
////                 }];
//
//}

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
        
    #// 设置过渡视图的底边距（此设置将影响到scrollView的contentSize）这个也是关键的一步
//    [verticalContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (lastView == nil) {
//            NSLog(@"yes");
//            make.bottom.mas_equalTo(lastView.mas_bottom);
//
//        }
//        else{
//            NSLog(@"no");
//        }
//    }];
}

-(void)contentInit{
    _page.content = [[Content alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height * 0.6)];
    _page.content.backgroundColor = UIColor.whiteColor;
    [_page addSubview:_page.content];
    [_page.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.75);
    }];
}
@end
