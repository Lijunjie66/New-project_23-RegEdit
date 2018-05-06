//
//  RegEdit.h
//  New-project_23-RegEdit
//
//  Created by Geraint on 2018/5/7.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegEdit : NSObject


@property (readonly) uint32_t regSetting; // 这个只读属性，用于存储寄存器每个位的二进制值（1/0）。类型为UI那天32，即标准的C语言无符号、32位整型，因此，寄存器的容量为32位。

- (id) initWithValue:(uint32_t)value;   // 初始的寄存器设置，初始了一个RegEdit实例
// 下面两个方法用于实现RegEdit对象的自定义下标
- (id) objectAtIndexedSubscript:(NSInteger)index; 
- (void) setObject:(id)newValue atIndexedSubscript:(NSInteger)index;

@end
