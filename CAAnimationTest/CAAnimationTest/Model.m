//
//  Model.m
//  CAAnimationTest
//
//  Created by Paul Kim on 1/29/14.
//
//

#import "Model.h"

static double DEFAULT_MAX_VAL = 10.0f;
static double DEFAULT_VALUE = 4.0f;

@interface Model () //private
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) double interval;

@end

@implementation Model
@synthesize value;
@synthesize timer;
@synthesize interval;

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        srand48(time(0)); // seed the random double generator

        self.interval = arc4random_uniform(10) + 1;
        NSLog(@"Timer interval = %f", self.interval);
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(changeValue) userInfo:nil repeats:TRUE];
        
        self.maxVal = DEFAULT_MAX_VAL;
        self.value = DEFAULT_VALUE;
    }
    return self;
}

- (void) changeValue
{
    float signVal = arc4random_uniform(2) ? -1.0f : 1.0f;
    
    double r = drand48() * self.maxVal;
    self.value = r * signVal;
}

- (double) getTimerInterval
{
    return self.interval;
}

- (void) dealloc
{
    [self.timer invalidate];
}

@end
