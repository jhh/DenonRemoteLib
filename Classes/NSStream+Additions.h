/*
 *  NSStream+Additions.h
 *  DenonTool
 *
 *  Created by Jeffrey Hutchison on 3/22/09.
 *  Copyright 2009 Jeff Hutchison. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

// From Technical Q&A QA1652
@interface NSStream (DRAdditions)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
                         port:(NSInteger)port 
                  inputStream:(NSInputStream **)inputStreamPtr 
                 outputStream:(NSOutputStream **)outputStreamPtr;
@end
