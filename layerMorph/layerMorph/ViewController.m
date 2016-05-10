//
//  ViewController.m
//  layerMorph
//
//  Created by James Sadlier on 18/03/2016.
//  Copyright © 2016 SpoonWare. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createShape];
    [self loadShapes];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeShape)];
    [self.view addGestureRecognizer:tap];
    
//    NSTimer *automatedShapeShift = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(changeShape) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createShape
{
    shapeCenter = (CGPoint){self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5};
    shapeRadius = (self.view.bounds.size.width > self.view.bounds.size.height)?self.view.bounds.size.height*0.2:self.view.bounds.size.width*0.2;
    shapeColor = [UIColor colorWithHue:(arc4random()%10)/10.0 saturation:1.0 brightness:1.0 alpha:1.0];
    currentShape = SHAPE_TYPE_TRIANGLE;
    shapeLayer = [self getCurrenShapeLayer];
    [[self.view layer] addSublayer:shapeLayer];
}

- (CAShapeLayer*)getPlus
{
    CAShapeLayer *plus = [[CAShapeLayer alloc] init];
    UIBezierPath *plusPath = [[UIBezierPath alloc] init];
    
    double halfPlusWidth = shapeRadius * 0.25;
    
    [plusPath moveToPoint:(CGPoint){shapeCenter.x - halfPlusWidth, shapeCenter.y - shapeRadius}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x + halfPlusWidth, shapeCenter.y - shapeRadius}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x + halfPlusWidth, shapeCenter.y - halfPlusWidth }];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y - halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y + halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x + halfPlusWidth, shapeCenter.y + halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x + halfPlusWidth, shapeCenter.y + shapeRadius}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x - halfPlusWidth, shapeCenter.y + shapeRadius}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x - halfPlusWidth, shapeCenter.y + halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y + halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y - halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x - halfPlusWidth, shapeCenter.y - halfPlusWidth}];
    [plusPath addLineToPoint:(CGPoint){shapeCenter.x - halfPlusWidth, shapeCenter.y - shapeRadius}];
    
    plus.path = plusPath.CGPath;
    plus.strokeColor = shapeColor.CGColor;
    plus.fillColor = shapeColor.CGColor;
    plus.lineWidth = 1;
    
    return plus;
}

- (CAShapeLayer*)getSquare
{
    CAShapeLayer *square = [[CAShapeLayer alloc] init];
    UIBezierPath *squarePath = [[UIBezierPath alloc] init];
    
    [squarePath moveToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y - shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y + shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y + shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y - shapeRadius}];
    [squarePath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y - shapeRadius}];
    
    square.path = squarePath.CGPath;
    square.strokeColor = shapeColor.CGColor;
    square.fillColor = shapeColor.CGColor;
    square.lineWidth = 1;
    
    return square;
}

- (CAShapeLayer*)getTriangle
{
    CAShapeLayer *triangle = [[CAShapeLayer alloc] init];
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    
    [trianglePath moveToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y + shapeRadius}];
    [trianglePath addLineToPoint:(CGPoint){shapeCenter.x, shapeCenter.y - shapeRadius}];
    [trianglePath addLineToPoint:(CGPoint){shapeCenter.x + shapeRadius, shapeCenter.y + shapeRadius}];
    [trianglePath addLineToPoint:(CGPoint){shapeCenter.x - shapeRadius, shapeCenter.y + shapeRadius}];
    
    triangle.path = trianglePath.CGPath;
    triangle.strokeColor = shapeColor.CGColor;
    triangle.fillColor = shapeColor.CGColor;
    triangle.lineWidth = 1;
    
    return triangle;
}

- (CAShapeLayer*)getCircle
{
    CAShapeLayer *circle = [[CAShapeLayer alloc] init];
    UIBezierPath *circlePath = [[UIBezierPath alloc] init];
    [circlePath addArcWithCenter:shapeCenter radius:shapeRadius startAngle:0 endAngle:M_PI*2 clockwise:YES];
    circle.path = circlePath.CGPath;
    circle.strokeColor = shapeColor.CGColor;
    circle.fillColor = shapeColor.CGColor;
    circle.lineWidth = 1;
    
    return circle;
}

- (void)changeShape
{
    if ( animating )
        return;
    animating = YES;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.73];//1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    currentShape = [self nextShape];
    CAShapeLayer *newLayer = [self getCurrenShapeLayer];
    shapeColor = [UIColor colorWithHue:( arc4random() % 10 ) /10.0 saturation:1.0 brightness:1.0 alpha:1.0];
    
    [CATransaction setCompletionBlock:^{
        animating = NO;
    }];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    //pathAnimation.duration = 2;
    pathAnimation.fromValue = (__bridge id _Nullable)(shapeLayer.path);
    pathAnimation.toValue = (__bridge id _Nullable)(newLayer.path);
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.cumulative = YES;
    [shapeLayer addAnimation:pathAnimation forKey:@"path"];
    [shapeLayer setPath:newLayer.path];
    
    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    //fillColorAnimation.duration = 2;
    
    fillColorAnimation.fromValue = (__bridge id _Nullable)(shapeLayer.fillColor);
    fillColorAnimation.toValue = (__bridge id _Nullable)(shapeColor.CGColor);
    fillColorAnimation.removedOnCompletion = NO;
    fillColorAnimation.cumulative = YES;
    [shapeLayer addAnimation:fillColorAnimation forKey:@"fillColor"];
    [shapeLayer setFillColor:shapeColor.CGColor];
    CABasicAnimation *strokeColorAnimation = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    //strokeColorAnimation.duration = 2;
    
    strokeColorAnimation.fromValue = (__bridge id _Nullable)(shapeLayer.fillColor);
    strokeColorAnimation.toValue = (__bridge id _Nullable)(shapeColor.CGColor);
    strokeColorAnimation.removedOnCompletion = NO;
    strokeColorAnimation.cumulative = YES;
    [shapeLayer addAnimation:strokeColorAnimation forKey:@"strokeColor"];
    [shapeLayer setStrokeColor:shapeColor.CGColor];
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    void (^animationCompletionBlock)(void) = [anim valueForKey:@"animationCompletionBlock"];
    if (animationCompletionBlock)
        animationCompletionBlock();
    [shapeLayer removeAllAnimations];
}

- (SHAPE_TYPE)nextShape
{
    if(!shapes)
        return 0;
    
    SHAPE_TYPE nextShape = currentShape;
    while (nextShape == currentShape) {
        nextShape = arc4random() % [shapes count];
    }
    return nextShape;
}

-(CAShapeLayer*)getShapeLayerForShape:(SHAPE_TYPE)shapeType
{
//    switch (shapeType) {
//        case SHAPE_TYPE_CIRCLE:
//            return [self getCircle];
//        case SHAPE_TYPE_SQUARE:
//            return [self getSquare];
//        case SHAPE_TYPE_TRIANGLE:
//            return [self getTriangle];
//        //case SHAPE_TYPE_PLUS:
//            //return [self getPlus];
//    }
    if(!shapes)
        return [self getSquare];
    return [shapes objectAtIndex:currentShape];
}

-(CAShapeLayer*)getCurrenShapeLayer
{
    return [self getShapeLayerForShape:currentShape];
}


- (void)loadShapes
{
    shapes = [[NSMutableArray alloc] init];
    [shapes addObject:[self getCircle]];
    [shapes addObject:[self getSquare]];
    [shapes addObject:[self getTriangle]];
    [shapes addObject:[self getPlus]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
    NSLog(@"files array %@", filePathsArray);
    for (int i = 0; i < [filePathsArray count]; i++ )
    {
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[filePathsArray objectAtIndex:i]];
        NSString *shapeString = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
        CAShapeLayer *newShape = [self shapePointsFromString:shapeString];
        [newShape setFrame:self.view.bounds];
        [shapes addObject:newShape];
    }
}

- (CAShapeLayer*)shapePointsFromString:(NSString*)shapeString
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"<path d=\"(.*)Z\"" options:NSRegularExpressionCaseInsensitive error:nil];
    
    // Create a range for it. We do the replacement on the whole
    // range of the text view, not only a portion of it.
    NSRange range = NSMakeRange(0, shapeString.length);
    
    NSArray *matches = [regex matchesInString:shapeString options:NSMatchingCompleted range:range];
    if ([matches count] < 1) {
        return nil;
    }
    NSRange foundRange = ((NSTextCheckingResult*)[matches firstObject]).range;
    NSString *afterText = [shapeString substringWithRange:foundRange];
    afterText = [afterText stringByReplacingOccurrencesOfString:@"<path d=\"" withString:@""];
    afterText = [afterText stringByReplacingOccurrencesOfString:@"Z\"" withString:@""];
    afterText = [afterText stringByReplacingOccurrencesOfString:@"M" withString:@""];
    afterText = [afterText stringByReplacingOccurrencesOfString:@"L" withString:@""];
    
    NSArray *points = [afterText componentsSeparatedByString:@" "];
    
    CAShapeLayer *newShape = [[CAShapeLayer alloc] init];
    UIBezierPath *shapePath = [[UIBezierPath alloc] init];
    
    NSArray *point = [[points firstObject] componentsSeparatedByString:@","];
    double mod = (shapeRadius*2) / 270.0;
    
    NSMutableArray *pathPoints = [[NSMutableArray alloc] init];
    for( int i = 0; i < [points count] - 1; i++ )
    {
        point = [[points objectAtIndex:i] componentsSeparatedByString:@","];
        [pathPoints addObject:[NSValue valueWithCGPoint:(CGPoint){([[point firstObject] floatValue] * mod) + (0.5*shapeCenter.x), ([[point lastObject] floatValue] * mod) + (0.5*shapeCenter.y) + shapeRadius }]];
    }
    
    [shapePath moveToPoint:[[pathPoints objectAtIndex:0] CGPointValue]];
    for( int i = 1; i < [points count] - 1; i++ )
    {
        [shapePath addLineToPoint:[[pathPoints objectAtIndex:i] CGPointValue]];
    }
    [shapePath addLineToPoint:[[pathPoints objectAtIndex:0] CGPointValue]];
    
    newShape.path = shapePath.CGPath;
    
    newShape.strokeColor = shapeColor.CGColor;
    newShape.fillColor = shapeColor.CGColor;
    newShape.lineWidth = 1;
    
    return newShape;
}
@end
