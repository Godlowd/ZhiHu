//
//  CommentDataModel+CoreDataProperties.m
//  
//
//  Created by New on 2020/7/22.
//
//

#import "CommentDataModel+CoreDataProperties.h"

@implementation CommentDataModel (CoreDataProperties)

+ (NSFetchRequest<CommentDataModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"CommentDataModel"];
}

@dynamic author;
@dynamic content;
@dynamic avatar;

@end
