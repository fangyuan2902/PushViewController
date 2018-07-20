//
//  ViewControllerManager.m
//  PushViewController
//
//  Created by 远方 on 2017/5/19.
//  Copyright © 2018年 远方. All rights reserved.
//

#import "ViewControllerManager.h"
#import <objc/runtime.h>

@implementation ViewControllerManager

+ (void)pushViewController:(UIViewController *)sourceViewController targetViewController:(NSString *)viewController {
    [ViewControllerManager pushViewController:sourceViewController targetViewController:viewController withParameters:nil isProperty:YES];
}

+ (void)pushViewController:(UIViewController *)sourceViewController targetViewController:(NSString *)viewController withParameters:(id)parameters isProperty:(BOOL)isProperty {
    [ViewControllerManager pushViewController:sourceViewController targetViewController:viewController withParameters:parameters isProperty:isProperty block:nil];
}

+ (void)pushViewController:(UIViewController *)sourceViewController targetViewController:(NSString *)viewController withParameters:(id)parameters isProperty:(BOOL)isProperty block:(void (^)(id object))block {
    UIViewController *targetViewController;
    if (!isProperty) {
        targetViewController = [ViewControllerManager targetViewController:viewController withParameters:parameters];
    } else {
        targetViewController = [ViewControllerManager viewController:sourceViewController getProperty:viewController withParameters:parameters block:^(id object) {
            block(object);
        }];
    }
    
    if(targetViewController && [targetViewController isKindOfClass:[UIViewController class]]) {
        targetViewController.hidesBottomBarWhenPushed = YES;
        [sourceViewController.navigationController pushViewController:targetViewController animated:YES];
    }
}

/**
 初始化目标controller

 @param viewController 目标controller
 @param parameters 参数
 @return 返回目标controller
 */
+ (UIViewController *)targetViewController:(NSString *)viewController withParameters:(id)parameters {
    UIViewController *targetViewController = nil;
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        if ([ViewControllerManager isContainsMethod:viewController]) {
            targetViewController = [[NSClassFromString(viewController) alloc] initWithDictionary:parameters];
        } else {
            targetViewController = [[NSClassFromString(viewController) alloc] init];
            NSLog(@"can not found initWithDictionary:");
        }
    } else {
        targetViewController = [[NSClassFromString(viewController) alloc] init];
        NSLog(@"parameters is not kinds of NSDictionary");
    }
    
    return targetViewController;
}

/**
 初始化目标controller

 @param source 源controller
 @param viewController 目标controller
 @param parameters 参数
 @param block 回调
 @return return 返回目标controller
 */
+ (UIViewController *)viewController:(UIViewController *)source getProperty:(NSString *)viewController withParameters:(id)parameters block:(void (^)(id object))block {
    UIViewController *targetViewController = [[NSClassFromString(viewController) alloc] init];
    if (!targetViewController) {
        return nil;
    }
    NSArray *array = [ViewControllerManager getArray:targetViewController withParameters:parameters];
    for (NSString *str in array) {
        if ([str containsString:@"Delegate"]) {
            [targetViewController setValue:source forKey:str];
        } else if ([str containsString:@"Block"]) {
            [targetViewController setValue:block forKey:str];
        }
    }
    if ([parameters isKindOfClass:[NSString class]]) {
        NSString *string = [NSString stringWithFormat:@"%@",parameters];
        NSString *first = [[string componentsSeparatedByString:@":"] firstObject];
        if ([array containsObject:first]) {
            [targetViewController setValue:[[string componentsSeparatedByString:@":"] lastObject] forKey:first];
        } else {
            NSLog(@"can not find this key: %@",first);
        }
    } else if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for(int i = 0;i < array.count; i++) {
            NSString *propName = [array objectAtIndex:i];
            id value = [parameters valueForKey:propName];
            if (value) {
                [dic setObject:value forKey:propName];
            }
        }
        [targetViewController setValuesForKeysWithDictionary:dic];
    }
    
    return targetViewController;
}

/**
 验证是否响应该方法

 @param viewController 目标controller
 @return return value description
 */
+ (BOOL)isContainsMethod:(NSString *)viewController {
    Method method1 = class_getInstanceMethod([NSClassFromString(viewController) class], @selector(initWithDictionary:));
    if (method1 != NULL) {
        return YES;
    } else {
        return NO;
    }
}

/**
 获取属性名称

 @param viewController 目标controller
 @param parameters 参数
 @return return value description
 */
+ (NSArray *)getArray:(UIViewController *)viewController withParameters:(id)parameters {
    NSMutableArray *array = [NSMutableArray array];
    unsigned int propsCount = 0;
    objc_property_t *props = class_copyPropertyList([viewController class], &propsCount);
    for(int i = 0;i < propsCount; i++) {
        objc_property_t property = props[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        [array addObject:propName];
    }
    free(props);
    
    return array;
}

@end
