//
//  NSObject_Constants.h
//  BusLondon
//
//  Created by Rubén Albiach on 09/09/14.
//  Copyright (c) 2014 Rubén Albiach. All rights reserved.
//

#define NUM_SECTIONS        7

#define NUM_SECTION_1_ITEMS 2
#define NUM_SECTION_2_ITEMS 14
#define NUM_SECTION_3_ITEMS 5

#define URL_TFL_API                         @"http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1"

#define RATIO_DISTANCE                      @"250"
#define URL_FINAL_STOPS                     @"&StopPointState=0&ReturnList=StopID,StopPointName,Towards,StopPointIndicator,StopPointType,Latitude,Longitude"

#define URL_BUSES_STOP_ID                   @"?Stopid="
#define URL_BUSES_RETURN_LIST_JUST_NUMBERS  @"&ReturnList=LineName"
#define URL_BUSES_RETURN_LIST               @"&ReturnList=Stoppointname,VehicleID,RegistrationNumber,LineName,DestinationName,EstimatedTime,ExpireTime"