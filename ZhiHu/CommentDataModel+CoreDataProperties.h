//
//  CommentDataModel+CoreDataProperties.h
//  
//
//  Created by New on 2020/7/22.
//
//

#import "CommentDataModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CommentDataModel (CoreDataProperties)

+ (NSFetchRequest<CommentDataModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *author;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSString *avatar;

@end

NS_ASSUME_NONNULL_END
