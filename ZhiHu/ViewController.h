//
//  ViewController.h
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Page.h"
@interface ViewController : UIViewController
@property(nonatomic, strong)NSPersistentContainer *container;
@property(nonatomic, strong) Page *page;
@end

