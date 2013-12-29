#import "ArtemisBitSet.h"

@interface ArtemisBitSet()
{
	CFMutableBitVectorRef bitVector;
}

@end

@implementation ArtemisBitSet

+(ArtemisBitSet *)bitSet
{
	ArtemisBitSet* newValue = [[[ArtemisBitSet alloc] initWithCapacity:32] autorelease];
	
	return newValue;
}

/** ObjC: dont let the default constructr exist; force use of the other one */
- (id)init
{
    return [self initWithCapacity:32];
}

- (id)initWithCapacity:(int) capacity
{
    self = [super init];
    if (self) {
        bitVector = CFBitVectorCreateMutable( kCFAllocatorDefault, capacity );
    }
    return self;
}

-(void)dealloc
{
	CFRelease( bitVector );
	
	[super dealloc];
}

-(void) clear
{
	CFBitVectorSetAllBits( bitVector, 0 );
	CFBitVectorSetCount(bitVector, 0);
}

-(void)clear:(CFIndex)index
{
	CFBitVectorSetBitAtIndex(bitVector, index, 0);
}

-(void)set:(CFIndex)index
{
	/** ObjC: Apple's class is insane. it will set and get bits, but fail to update the count */
	if( CFBitVectorGetCount(bitVector) <= index )
		CFBitVectorSetCount(bitVector, index+1);
	
	CFBitVectorSetBitAtIndex(bitVector, index, 1);
	
	NSLog(@"After setting bit at index = %li, bit at index %li = %i", index, index, (unsigned int)CFBitVectorGetBitAtIndex(bitVector, index));
}

-(BOOL)get:(CFIndex)index
{
	return 0 != CFBitVectorGetBitAtIndex(bitVector, index);
}

-(BOOL)isEmpty
{
	return ! ( CFBitVectorContainsBit( bitVector, CFRangeMake(0, CFBitVectorGetCount(bitVector)), 1) );
}

-(BOOL)intersects:(ArtemisBitSet *)otherBitSet
{
	/** Apple doesn't support this operation :( :( :( :(. Apple's Bit class is weak */
	
	CFIndex myLength = CFBitVectorGetCount(bitVector);
	CFIndex otherLength = CFBitVectorGetCount(otherBitSet->bitVector);
	
	for( int i=0; i<myLength; i++ )
	{
		if( i >= otherLength )
			return FALSE;
		
		if( [self get:i] )
			if( [otherBitSet get:i] )
				return TRUE;
	}
	
	return FALSE;
}

-(CFIndex)nextSetBit:(CFIndex)startIndex
{
	CFIndex firstIndexAfterStart = CFBitVectorGetFirstIndexOfBit(bitVector, CFRangeMake(startIndex, CFBitVectorGetCount(bitVector) - startIndex), 1);
	
	return firstIndexAfterStart == kCFNotFound? -1 : firstIndexAfterStart;
}

-(NSString *)description
{
	NSMutableString* s = [NSMutableString string];
	
	CFIndex l = CFBitVectorGetCount(bitVector);
	[s appendFormat:@"[BitSet(%li):", l];
	for( int i=0; i<l; i++ )
	{
		[s appendString: l == 0 ? @"0" : @"1" ];
	}
	[s appendString:@"]"];
	return s;
}

@end
