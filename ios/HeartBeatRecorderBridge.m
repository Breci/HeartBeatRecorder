//
//  HeartBeatRecorderBridge.m
//  IRUS_V4
//
//  Created by CULAS Brice on 09/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>


@interface RCT_EXTERN_MODULE(HeartBeatRecorder, NSObject)


RCT_EXTERN_METHOD(startRecording)
RCT_EXTERN_METHOD(stopRecording)
RCT_EXTERN_METHOD(testEvent)

@end
