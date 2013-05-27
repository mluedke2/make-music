//
//  PerformanceListGetter.h
//  Make Music
//
//  Created by Matt Luedke on 5/14/13.
//  Copyright (c) 2013 Matt Luedke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceListGetter : NSObject {
    
    NSMutableData *responseData;
    
}

- (void)getPerformanceList:(NSString *)location;


@end
