//
//  ViewControllerManager.h
//  PushViewController
//
//  Created by 远方 on 2017/5/19.
//  Copyright © 2018年 远方. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewControllerManager : NSObject

/**
 跳转到一个任意viewcontroller，带有参数
 
 @param sourceViewController 跳转的源
 @param viewController 要跳转到的vc的类
 */
+ (void)pushViewController:(UIViewController *)sourceViewController targetViewController:(NSString *)viewController;

/**
 跳转到一个任意viewcontroller，带有参数
 
 @param sourceViewController 跳转的源
 @param viewController 要跳转到的vc的类
 @param parameters 参数
 @param isProperty 设置参数方式
 */
+ (void)pushViewController:(UIViewController *)sourceViewController targetViewController:(NSString *)viewController withParameters:(id)parameters isProperty:(BOOL)isProperty;

/**
 跳转到一个任意viewcontroller，带有参数
 
 @param sourceViewController 跳转的源
 @param viewController 要跳转到的vc的类
 @param parameters 参数
 @param isProperty 设置参数方式
 @param block block description
 */
+ (void)pushViewController:(UIViewController *)sourceViewController targetViewController:(NSString *)viewController withParameters:(id)parameters isProperty:(BOOL)isProperty block:(void (^)(id object))block;

@end
