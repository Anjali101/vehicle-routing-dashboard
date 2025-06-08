using Visualization as service from '../../srv/processors-service';

annotate service.RouteTimeWindowSummary with @UI.SelectionFields : [ RouteID ];

annotate service.RouteTimeWindowSummary with @Aggregation.ApplySupported : {
  Transformations : ['aggregate', 'groupby'],
  GroupableProperties : [ RouteID ],
  AggregatableProperties : [
    { Property: CustomerCount },
    { Property: AvgTimeWindowLength },
    { Property: ConstraintCount }
  ]
};

annotate service.RouteTimeWindowSummary with @UI.Chart : {
  Title: 'Time Window Complexity & Constraint Count per Route',
  ChartType: #Column,
  Dimensions: [ RouteID ],
  Measures: [ CustomerCount, AvgTimeWindowLength, ConstraintCount ],
  MeasureAttributes: [
    { Measure: CustomerCount, Role: #Axis1 },
    { Measure: AvgTimeWindowLength, Role: #Axis1 },
    { Measure: ConstraintCount, Role: #Axis2 }
  ]
};

annotate service.RouteTimeWindowSummary with @UI.LineItem: [
  { Value: RouteID, Label: 'Route ID' },
  { Value: CustomerCount, Label: 'Number of Customers' },
  { Value: AvgTimeWindowLength, Label: 'Avg Time Window (min)' },
  { Value: ConstraintCount, Label: 'Number of Constraints' }
];
