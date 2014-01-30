//
//  Model.h
//  CAAnimationTest
//
//  Created by Paul Kim on 1/29/14.
//
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property (nonatomic) double value;
@property (nonatomic) double maxVal;

- (double) getTimerInterval;

@end
