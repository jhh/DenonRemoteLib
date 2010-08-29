// NSStream+Additions.m
//
// Copyright 2010 Jeffrey Hutchison
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "NSStream+Additions.h"

@implementation NSStream (DRAdditions)

+ (void)getStreamsToHostNamed:(NSString *)hostName 
                         port:(NSInteger)port 
                  inputStream:(NSInputStream **)inputStreamPtr 
                 outputStream:(NSOutputStream **)outputStreamPtr{

  CFReadStreamRef     readStream;
  CFWriteStreamRef    writeStream;
  
  assert(hostName != nil);
  assert( (port > 0) && (port < 65536) );
  assert( (inputStreamPtr != NULL) || (outputStreamPtr != NULL) );
  
  readStream = NULL;
  writeStream = NULL;
  
  CFStreamCreatePairWithSocketToHost(
                                     NULL, 
                                     (CFStringRef) hostName, 
                                     port, 
                                     ((inputStreamPtr  != nil) ? &readStream : NULL),
                                     ((outputStreamPtr != nil) ? &writeStream : NULL)
                                     );
  
  if (inputStreamPtr != NULL) {
    *inputStreamPtr  = [NSMakeCollectable(readStream) autorelease];
  }
  if (outputStreamPtr != NULL) {
    *outputStreamPtr = [NSMakeCollectable(writeStream) autorelease];
  }
}

@end