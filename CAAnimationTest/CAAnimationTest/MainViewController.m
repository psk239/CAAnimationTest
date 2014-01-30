//
//  MainViewController.m
//  CAAnimationTest
//
//  Created by Paul Kim on 1/29/14.
//
//

#import "MainViewController.h"
#import "Model.h"

typedef NS_ENUM(NSUInteger, AnimationType) {
    AnimationTypeNone,
    AnimationTypeFade,
    AnimationTypeScaleAndRotate
};

@interface MainViewController () //private
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) Model *model;
@property (nonatomic, strong) UILabel* statusLabel;
@property (nonatomic) AnimationType currentAnimationType;
@end

@implementation MainViewController
@synthesize imageView, model, statusLabel;

#pragma mark - Initializers

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"robokill2_Icon.png"]]; //heh.
        [self.imageView setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
        self.model = [[Model alloc] init];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return self;
}

#pragma mark - Apple Provided Methods

- (void) loadView
{
    [super loadView];
    
    CGSize btnSize = CGSizeMake(self.view.bounds.size.width/2, 50.0f);
    
    //Generate Fade Button
    CGRect fadeRect = self.view.bounds;
    fadeRect.size = btnSize;
    fadeRect.origin.y = self.view.bounds.size.height - btnSize.height;
    fadeRect.origin.x = 0;
    
    UIButton *fadeAnimationBtn = [[UIButton alloc] initWithFrame:fadeRect];
    [fadeAnimationBtn setTitle:NSLocalizedString(@"Fade In", @"Fade In") forState:UIControlStateNormal];
    [fadeAnimationBtn setBackgroundColor:[UIColor yellowColor]];
    [fadeAnimationBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [fadeAnimationBtn addTarget:self action:@selector(startFadeAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //Generate Slide and Rotate Button
    CGRect slideRect = fadeRect;
    slideRect.origin.x = btnSize.width;
    
    UIButton *slideAnimationBtn = [[UIButton alloc] initWithFrame:slideRect];
    [slideAnimationBtn setTitle:NSLocalizedString(@"Slide and Rotate", @"Slide and Rotate") forState:UIControlStateNormal];
    [slideAnimationBtn setBackgroundColor:[UIColor greenColor]];
    [slideAnimationBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [slideAnimationBtn addTarget:self action:@selector(startSlideAndRotateAnimation) forControlEvents:UIControlEventTouchUpInside];
    
    
    //Generate Status Label
    CGRect labelRect = self.view.bounds;
    labelRect.size.height = 50.0f;
    labelRect.origin.y = fadeAnimationBtn.frame.origin.y - labelRect.size.height;
    
    [self.statusLabel setFrame:labelRect];
    [self.statusLabel setNumberOfLines:2];
    [self.statusLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self centerImageView];

    
    // Add everything to the view
    [self.view addSubview:fadeAnimationBtn];
    [self.view addSubview:slideAnimationBtn];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.imageView];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
        
    [self.model addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    [self startFadeAnimation];
}

- (void) dealloc
{
    @try {
        [self.model removeObserver:self forKeyPath:@"value"];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Unable to remove %@ as observer of model value", [self class]);
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"value"])
    {
        if (self.currentAnimationType == AnimationTypeFade)
        {
            [self startFadeAnimation];
        }
        else
        {
            [self startSlideAndRotateAnimation];
        }
    }
}

#pragma mark - Animations

- (void) startFadeAnimation
{
    //Reset to prepare for animation
    [self.imageView.layer removeAllAnimations];
    [self centerImageView];
    self.currentAnimationType = AnimationTypeFade;
    
    //prepare value states
    double duration = fabs(self.model.value);
    NSArray* times = @[@0, @0.4, @0.8, @1.0];
    
    //update label
    [self updateStatusValueWithValue:duration];
    
    //animate
    CAKeyframeAnimation* fade = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fade.values = @[@0, @1, @1, @1];
    fade.keyTimes = times;
    
    CAKeyframeAnimation* stretch = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    stretch.values = @[@0.2, @1.2, @0.9, @1];
    stretch.keyTimes = times;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration;
    group.repeatCount = MAXFLOAT;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = [NSArray arrayWithObjects:fade, stretch, nil];

    [self.imageView.layer addAnimation:group forKey:@"fadeAnimation"];
}

- (void) startSlideAndRotateAnimation
{
    //Reset to prepare for animation
    [self.imageView.layer removeAllAnimations];
    [self centerImageView];
    [self.imageView setAlpha:1.0f];
    self.currentAnimationType = AnimationTypeScaleAndRotate;
    
    //prepare value states
    NSArray* times = @[@0, @1];
    float finalXVal = self.view.bounds.size.width/2;
    float xVal = finalXVal + (self.model.value/self.model.maxVal) * (self.view.frame.size.width/2); //I realized this value was far too small so I have to scale it up
    
    //update label
    [self updateStatusValueWithValue:xVal];
    
    //animate
    CAKeyframeAnimation* positionX = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    positionX.values = @[[NSNumber numberWithFloat:xVal], [NSNumber numberWithFloat:finalXVal]];
    positionX.keyTimes = times;
    
    CAKeyframeAnimation* positionY = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
    positionY.values = @[[NSNumber numberWithFloat:self.view.bounds.size.height/2], [NSNumber numberWithFloat:self.view.bounds.size.height/2]];
    positionY.keyTimes = times;

    
    CAKeyframeAnimation* rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.values = @[@0, [NSNumber numberWithFloat:(M_PI*2.0f)]];
    rotate.keyTimes = times;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 3.0f;
    group.repeatCount = MAXFLOAT;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    group.animations = [NSArray arrayWithObjects:positionX, positionY, rotate, nil];
    
    [self.imageView.layer addAnimation:group forKey:@"slideAndRotateAnimation"];
}

#pragma mark - Convenience Methods

- (void) updateStatusValueWithValue:(float) value
{
    [self.statusLabel setText:[NSString stringWithFormat: @"Update Interval: %f\nCurrent value = %f", [self.model getTimerInterval], value]];
}

- (void) centerImageView
{
    CGRect imageRect = self.imageView.frame;
    imageRect.origin.x = (self.view.bounds.size.width - imageRect.size.width)/2;
    imageRect.origin.y = (self.view.bounds.size.height - imageRect.size.height)/2;
    [self.imageView setFrame:imageRect];
}

@end
