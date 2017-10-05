//
//  UIView+UIViewShadow.m
//  AstroTV
//
//  Created by Hung Nguyen Thanh on 10/2/17.
//  Copyright © 2017 Hung Nguyen Thanh. All rights reserved.
//

#import "UIView+UIViewShadow.h"
#import "AstroTV-Swift.h"

@implementation UIView (UIViewShadow)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if ([[self class] respondsToSelector:@selector(makeSwizzling)]) {
            
            [[self class] performSelector:@selector(makeSwizzling) withObject:nil];
        }
    });
    
}

@end
