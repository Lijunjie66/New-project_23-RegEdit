//
//  CLIParser.h
//  New-project_23-RegEdit
//
//  Created by Geraint on 2018/5/7.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLIParser : NSObject

// 初始化了一个CLIParser对象，使用输入参数的值设置它的状态。
- (id) initWithCount:(int)argc arguments:(const char *[])argv;
// 解析了命令行输入参数，通过间接方式设置这些参数的值
- (BOOL) parseWithRegister:(uint32_t *)registerValue
                byteNymber:(NSInteger *)byteN
                 doSetByte:(BOOL)diSet
                 byteValue:(unsigned int *)byteValue
                     error:(NSError *)anerror;

@end
