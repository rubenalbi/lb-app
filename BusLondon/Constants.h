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

#define RATIO_DISTANCE  500
#define URL_FINAL_STOPS                     @"&StopPointState=0&ReturnList=StopID,StopPointName,Towards,Bearing,StopPointIndicator,StopPointType,Latitude,Longitude"

#define URL_BUSES_STOP_ID                   @"?Stopid="
#define URL_BUSES_RETURN_LIST_JUST_NUMBERS  @"&ReturnList=LineName"
#define URL_BUSES_RETURN_LIST               @"&ReturnList=Stoppointname,VehicleID,RegistrationNumber,LineName,DestinationName,EstimatedTime,ExpireTime"

#define METERS_PER_MILE 1609.344

#define NEW_URL_TFL_API @"https://api.tfl.gov.uk/"
#define TFL_STOP_POINT_PARAM @"StopPoint"
#define TFL_ARRAIVALS_PARAM @"Arrivals"
#define TFL_STOP_TYPE_PARAM @"stopTypes="
#define TFL_RADIUS_PARAM @"radius="
#define TFL_STOP_POINT_HIERARCHY_PARAM @"useStopPointHierarchy="
#define TFL_RETURN_LINES_PARAM @"returnLines="
#define TFL_STOP_TYPE_PUBLIC_BUS @"NaptanPublicBusCoachTram"
#define TFL_APP_CREDENTIALS @"app_id=b4cfdcd0&app_key=ee2d65d36b4f1881b46dd5d0d7c33c26"

// https://api.tfl.gov.uk/StopPoint?lat=51.509980&lon=-0.133700&stopTypes=NaptanPublicBusCoachTram&radius=500&useStopPointHierarchy=True&returnLines=True&app_id=b4cfdcd0&app_key=ee2d65d36b4f1881b46dd5d0d7c33c26