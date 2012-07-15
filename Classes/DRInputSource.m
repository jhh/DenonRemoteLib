// DRInputSource.m
// DenonRemoteLib
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

#import "DRInputSource.h"
#import "DRDebuggingMacros.h"
#import "DREvent.h"


@implementation DRInputSource

@synthesize source = _source;
@synthesize name   = _name;

- (id) initWithSource:(NSString *)aSource andName:(NSString *)aName {
    if ((self = [super init])) {
        _source = [aSource copy];
        _name   = [aName copy];
    }
    return self;
}

- (id) initWithEvent:(DREvent *)event {
    NSRange range = [event.parameter rangeOfString:@" "];

    NSString * src, * nm;
    if (range.location != NSNotFound) {
        src = [event.parameter substringToIndex:range.location];
        nm = [[event.parameter substringFromIndex:range.location+1]
                stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        src = event.parameter;
        nm = event.parameter;
    }

    return [self initWithSource:src andName:nm];
}

- (NSString *) description {
    return [NSString stringWithFormat:@"%@ %@ => %@", [super description], self.source, self.name] ;
}


- (BOOL) isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if (![self.source isEqual:[(DRInputSource *)other source]])
        return NO;
    return YES;
}

- (NSUInteger) hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    result = prime + [self.source hash];
    result = prime * result + [self.name hash];
    return result;
}

@end
