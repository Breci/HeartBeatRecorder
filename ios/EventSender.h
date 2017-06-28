//
//  EventSender.h
//  IRUS_V4
//
//  Created by CULAS Brice on 10/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
@interface EventSender : RCTEventEmitter <RCTBridgeModule>

- (void)notifyReact ;
- (void)setBridge ;


@end
