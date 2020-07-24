//
//  ContentDataModel+CoreDataProperties.m
//  
//
//  Created by New on 2020/7/24.
//
//  This file was automatically generated and should not be edited.
//

#import "ContentDataModel+CoreDataProperties.h"

@implementation ContentDataModel (CoreDataProperties)

+ (NSFetchRequest<ContentDataModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ContentDataModel"];
}

@dynamic content;

@end
