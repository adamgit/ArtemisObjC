/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/EntityObserver.java
 */
#import <Foundation/Foundation.h>

@class ArtemisEntity;

@protocol ArtemisEntityObserver <NSObject>

-(void) added:(ArtemisEntity*) entity;
-(void) changed:(ArtemisEntity*) entity;
-(void) deleted:(ArtemisEntity*) entity;
-(void) disabled:(ArtemisEntity*) entity;
-(void) enabled:(ArtemisEntity*) entity;

@end
