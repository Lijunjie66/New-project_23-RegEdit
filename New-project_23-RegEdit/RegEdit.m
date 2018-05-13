//
//  RegEdit.m
//  New-project_23-RegEdit
//
//  Created by Geraint on 2018/5/7.
//  Copyright © 2018年 kilolumen. All rights reserved.
//

#import "RegEdit.h"
#import "RegEditConstants.h"


@interface RegEdit()

@property (readwrite) uint32_t regSetting;

@end

@implementation RegEdit

- (id)initWithValue:(uint32_t)value {
    if (self = [super init]) {
        _regSetting = value;
        
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSInteger)index {
    NSUInteger byteNumber = index * 8;
    if ((1 << byteNumber) > self.regSetting) {
        [NSException raise:NSRangeException format:@"Byte selected (%ld) exceeds number value", index];
    }
    unsigned int byteValue = (self.regSetting & (kByteMultiplier << byteNumber)) >> byteNumber;
    return [NSNumber numberWithUnsignedInt:byteValue];
}

- (void)setObject:(id)newValue atIndexedSubscript:(NSInteger)index {
    if (newValue == nil) {
        [NSException raise:NSInvalidArgumentException format:@"New value is nil"];
    }
    NSUInteger byteNumber = index * 8;
    if ((1 << byteNumber) > self.regSetting) {
        [NSException raise:NSRangeException format:@"Byte selected (%ld) exceeds number value", index];
    }
    uint32_t mask = ~(kByteMultiplier << byteNumber);
    uint32_t tmpValue = self.regSetting & mask;
    unsigned char newByte = [newValue unsignedCharValue];
    self.regSetting = (newByte << byteNumber) | tmpValue;
}

@end
