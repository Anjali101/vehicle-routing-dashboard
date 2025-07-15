using insights as service from '../../srv/processors-service';



annotate service.ScenarioInsights with @UI.LineItem: [

    {Value: Route, Label: 'Route ID'},
    {Value: ChallengeLevel, Label: 'Challenge Intensity', Criticality: challengecrit},
    {Value: Issues, Label: 'Route Issues', ![@HTML5.CssDefaults] : {width : '40rem'}},
    {Value: dataclassifier, Label: 'Is full Data available?', Criticality: datacrit }




];

annotate service.ScenarioInsights with {

  SumWeight @Measures.Unit : 'kg';                   
  SumVolume @Measures.Unit : 'm^3';                   
  AverageServiceTime @Measures.Unit : 'min';                                        
  ActiveTime @Measures.Unit : 'min';                 
  DeliveryTime @Measures.Unit : 'min';              
  DrivingTime @Measures.Unit : 'min';              
  VehicleCost @Measures.Unit : '€/km';                                      
               
  AvgWeightUsage @Measures.Unit : '%';               
  AvgVolumeUsage @Measures.Unit : '%';        
  MaxCustomerDistanceKM @Measures.Unit : 'km';
  VehicleCapacityKG @Measures.Unit : 'kg'; 
  avg_customer_spread @Measures.Unit : 'kg';   
  avg_customer_spread_time @Measures.Unit : 'min';  
  VehicleVolumeM3 @Measures.Unit : 'm³';
  ReferenceValueVehicleCost @Measures.Unit : '€/km';  
  ReferenceValueCustDIst @Measures.Unit : 'km';
  AvgCustAvailability @Measures.Unit : 'min';

};


annotate service.ScenarioInsights with @UI.Facets: [
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Challenge Criticality',
    ID: 'ClassificationsTab',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Challenge Criticality',
        Target: '@UI.FieldGroup#Overview'},

    ]
  } ,
  {
    $Type: 'UI.CollectionFacet',
    Label: 'Issue Description',
    ID: 'Description',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Issue Description',
        Target: '@UI.FieldGroup#description'},

    ]
  } ,
    {
    $Type: 'UI.CollectionFacet',
    Label: 'Route Characteristics Summary',
    ID: 'Characteristics',
    Facets: [
      {
        $Type: 'UI.ReferenceFacet',
        Label: 'Issue Description',
        Target: '@UI.FieldGroup#characteristics'},

    ]
  } ,
];




annotate service.ScenarioInsights with @UI.HeaderFacets: [
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Average Customer Count',
    Target: '@UI.DataPoint#CustCount'
  },
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Average Constraint Count',
    Target: '@UI.DataPoint#ReferenceValueConstraintLevel'
  },
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Average Distance between Customers',
    Target: '@UI.DataPoint#ReferenceCustSpread'
  },
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Average Route Cost',
    Target: '@UI.DataPoint#ReferenceValueVehicleCost'
  },
  {
    $Type: 'UI.ReferenceFacet',
    Label: 'Average Customer Availability Timeframe',
    Target: '@UI.DataPoint#AvgCustAvailability'
  }
];




annotate service.ScenarioInsights with @UI.DataPoint#ReferenceValueConstraintLevel: {
  Title: 'Average Constraint Count',
  Value: ReferenceValueConstraintLevel,
    ValueFormat : {
        $Type : 'UI.NumberFormat',
        NumberOfFractionalDigits : 5
    }
};

annotate service.ScenarioInsights with @UI.DataPoint #ReferenceCustSpread: {
  Title: 'Average Distance between Customers',
  Value: ReferenceValueCustDIst,
  ValueFormat : {
        $Type : 'UI.NumberFormat',
        NumberOfFractionalDigits : 5
    }
};

annotate service.ScenarioInsights with @UI.DataPoint #ReferenceValueVehicleCost: {
  Title: 'Average Route Cost',
  Value: ReferenceValueVehicleCost,
   ValueFormat : {
        $Type : 'UI.NumberFormat',
        NumberOfFractionalDigits : 5
    }
};

annotate service.ScenarioInsights with @UI.DataPoint #AvgCustAvailability: {
  Title: 'Average Customer Availability Timeframe',
  Value: AvgCustAvailability,
   ValueFormat : {
        $Type : 'UI.NumberFormat',
        NumberOfFractionalDigits : 5
    }
};
annotate service.ScenarioInsights with @UI.DataPoint #CustCount: {
  Title: 'Average Customers per Route',
  Value: ReferenceCustCount,
   ValueFormat : {
        $Type : 'UI.NumberFormat',
        NumberOfFractionalDigits : 5
    }
};

annotate service.ScenarioInsights with @UI.FieldGroup#Overview: {
Data:
[
    {Value: ChallengeLevel , Label: 'Challenge Level', Criticality: challengecrit},
    {Value: Issues , Label: 'Issues'}

]};


annotate service.ScenarioInsights with @UI.FieldGroup#description: {
Data:
[
    {Value: short_description , Label: 'Short Description'},
    {Value: description , Label: 'Description'}

]};


annotate service.ScenarioInsights with @UI.FieldGroup#characteristics: {
Data:
[
    {Value: CustomerCount , Label: 'Customers'},
    {Value: ConstraintCount , Label: 'Constraints'},
    {Value:  avg_customer_spread, Label: 'Constraints'},
    {Value:  VehicleCost, Label: 'Route Cost'},
    {Value:  AvgCustAvailability, Label: 'Customer Availability'},

    



]};