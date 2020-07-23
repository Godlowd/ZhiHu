//
//  UserComment.h
//  ZhiHu
//
//  Created by New on 2020/7/21.
//  Copyright © 2020 Godlowd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserComment : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *avatar;
@end

NS_ASSUME_NONNULL_END
