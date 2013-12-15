/**
 http://code.google.com/p/artemis-framework/source/browse/src/com/artemis/utils/Bag.java
 
 Implements ImmutableBag protocol so that it CAN BE an immutable AS WELL AS a mutable
 */
#import <Foundation/Foundation.h>

#import "ArtemisImmutableBag.h"

@interface ArtemisBag : NSObject <ArtemisImmutableBag>


+(ArtemisBag*) bag;

-(id)initWithCapacity:(NSInteger) c;

-(NSObject*) remove:(NSInteger) index;
-(NSObject*) removeLast;
/** Have to rename method, Objc doesn't support overloading, it's too basic/weak a language */
-(BOOL) removeFirst:(id) item;

-(BOOL) contains:(id) item;

-(BOOL) removeAll:(ArtemisBag*) otherBag;

-(NSObject*) get:(NSInteger) index;

@property(nonatomic,readonly) NSInteger size, capacity;

-(BOOL) isIndexWithinBounds:(int) bounds;

@property(nonatomic,readonly) BOOL isEmpty;

-(void) add:(NSObject*) item;

/** Have to rename for objc */
-(void) setItem:(NSObject*) item atIndex:(int) index;

-(void) ensureCapacity:(NSInteger) index;

-(void) clear;

-(void) addAll:(ArtemisBag*) otherBag;

@end
