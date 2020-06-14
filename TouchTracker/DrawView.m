//
//  DrawView.m
//  TouchTracker
//
//  Created by nuko on 2020/6/9.
//  Copyright © 2020 nuko. All rights reserved.
//

#import "DrawView.h"
#import "Line.h"

@interface DrawView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
//@property (nonatomic, strong) Line *currentLine;
@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@property (nonatomic, weak) Line *selectedLine;

@end

@implementation DrawView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *t = [touches anyObject];
    // get the touch location in view
//    CGPoint location = [t locationInView:self];
//
//    self.currentLine = [[Line alloc] init];
//    self.currentLine.begin = location;
//    self.currentLine.end = location;
    NSLog(@"%@", NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        
        Line *line = [[Line alloc] init];
        line.begin = location;
        line.end = location;
        // NSValue can contain any c or objective-c data
        // use this method, we do not keep a strong ref
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *t = [touches anyObject];
//    CGPoint location = [t locationInView:self];
//
//    self.currentLine.end = location;
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line = self.linesInProgress[key];
        
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.finishedLines addObject:self.currentLine];
//
//    self.currentLine = nil;
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        Line *line = self.linesInProgress[key];
        
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        
        // enable multi touch
        self.multipleTouchEnabled = YES;
        
        // gesture recognizer
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        
        doubleTapRecognizer.numberOfTapsRequired = 2;
        // delay event deliver to view
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        // need wait double tap fail, so it will take a little amount of time
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        
        [self addGestureRecognizer:tapRecognizer];
        
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [self addGestureRecognizer:pressRecognizer];
        
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        
        self.moveRecognizer.delegate = self;
        
        // allow touches deliver to the view
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
        
        
    }
    
    return self;
}

- (void)moveLine:(UIPanGestureRecognizer *)gr{
    if (!self.selectedLine) {
        return;
    }
    
    if (gr.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gr translationInView:self];
        
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        
        [self setNeedsDisplay];
        
        // reset translation to zero
        [gr setTranslation:CGPointZero inView:self];
    }
}

// protocol, share touches
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

- (void)longPress:(UIGestureRecognizer *)gr{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    }else if(gr.state == UIGestureRecognizerStateEnded){
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

- (void)tap:(UIGestureRecognizer *)gr{
    NSLog(@"Recognized Tap");
    
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES];
    }else{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

- (void)deleteLine:(id)sender{
    [self.finishedLines removeObject:self.selectedLine];
    
    [self setNeedsDisplay];
}

// the custom view must return YES if we want it to be firstResponder
- (BOOL)canBecomeFirstResponder{
    return YES;
}

// when double tap, clear all lines
- (void)doubleTap:(UIGestureRecognizer *)gr{
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [[UIColor blackColor] set];
    // draw the finished lines with black
    for (Line *line in self.finishedLines) {
        [self strokeLine:line];
    }
    
    // draw the current line with red
//    if (self.currentLine) {
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
    
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
    
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
}

- (Line *)lineAtPoint:(CGPoint)p{
    for (Line *l  in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        
        // if the distance between some point at line and given point near than 20 point, we just pick it
        for (float t=0.0; t <= 1.0; t += 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            if (hypot(x - p.x, y - p.y) < 20.0) {
                return l;
            }
        }
    }
    
    return nil;
}

// draw a line
- (void)strokeLine:(Line *)line{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
