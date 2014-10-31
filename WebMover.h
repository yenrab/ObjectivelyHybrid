//
//  WebMover.h
//  Objective-C work around
//
//  Created by Lee Barney on 10/31/14.
//  Copyright (c) 2014 Lee Barney. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebMover : NSObject
+(NSString*)moveDirectoriesAndWebFilesOfType:(NSArray*)webFileTypes error:(NSError**)error;
@end
