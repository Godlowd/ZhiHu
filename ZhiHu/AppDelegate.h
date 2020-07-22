//
//  AppDelegate.h
//  ZhiHu
//
//  Created by New on 2020/7/22.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

