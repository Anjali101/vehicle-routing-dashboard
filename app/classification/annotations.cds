using RouteClassification as service from '../../srv/processors-service';



annotate service.CustomerArticleSummary with @Capabilities.SearchRestrictions.Searchable: false;

annotate service.CustomerArticleSummary with @UI.LineItem: [

    {Value: Route, Label: 'Route', @UI.Importance : #High,},
    {Value: TotalArticles, Label: 'Total Articles', Criticality: TotalArticleCriticality, @UI.Importance: #High},
    
    {
        $Type : 'UI.DataFieldForAnnotation',
        Label : 'Customer Availability',
        Target : '@UI.DataPoint#Rating'
    },
    



];





annotate service.CustomerArticleSummary with @(
  
  UI.DataPoint #Rating: {

    Value: AverageServiceStars,
    TargetValue: 5,
    Visualization: #Rating



  }
  
);
   









annotate service.CustomerArticleSummary with @UI.SelectionPresentationVariant: {
  SelectionVariant: {
    SelectOptions: []
  },
  PresentationVariant: {
    Visualizations: ['@UI.LineItem'],
    RequestAtLeast: ['Route', 'TotalArticles']
  }
};



annotate service.CustomerArticleSummary with @UI.SelectionFields: ['Route'];

annotate service.CustomerArticleSummary with @UI.HeaderInfo: {
  TypeName: 'Route Classification',
  TypeNamePlural: 'Route Classifications',
  Title: { Value: Route }
};

annotate service.CustomerArticleSummary.AverageServiceTime with @UI.DataPoint: {
  Title: 'Avg. Service Time',
  Value: AverageServiceTime,
  Visualization: #Rating,
  TargetValue: 5
};