using Visualization as service from '../../srv/processors-service';

annotate service.RouteClassification with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Label : 'Route ID', Value : RouteID },
            { $Type : 'UI.DataField', Label : 'Customer Count', Value : CustomerCount },
            { $Type : 'UI.DataField', Label : 'Avg Time Window Length', Value : AvgTimeWindowLength },
            { $Type : 'UI.DataField', Label : 'Constraint Count', Value : ConstraintCount },
            { $Type : 'UI.DataField', Label : 'Time Window Complexity', Value : TimeWindowComplexity },
            { $Type : 'UI.DataField', Label : 'Constraint Level', Value : ConstraintLevel }
        ]
    },

    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneralInfo',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'AvgTimeChartFacet',
            Label : 'Avg Time Window per Route',
            Target : '@UI.Chart#AvgTimeChart'
        }
    ],

    UI.LineItem : [
        { $Type : 'UI.DataField', Label : 'Route ID', Value : RouteID },
        { $Type : 'UI.DataField', Label : 'Customer Count', Value : CustomerCount },
        { $Type : 'UI.DataField', Label : 'Avg Time Window Length', Value : AvgTimeWindowLength },
        { $Type : 'UI.DataField', Label : 'Constraint Count', Value : ConstraintCount },
        { $Type : 'UI.DataField', Label : 'Time Window Complexity', Value : TimeWindowComplexity },
        { $Type : 'UI.DataField', Label : 'Constraint Level', Value : ConstraintLevel }
    ]
);

annotate service.RouteClassification with @UI.Chart #AvgTimeChart : {
    Title : 'Average Time Window Length per Route',
    ChartType : #Line,
    Dimensions : [ RouteID ],
    Measures : [ AvgTimeWindowLength ],
    MeasureAttributes : [
        { Measure : AvgTimeWindowLength, Role : #Axis1 }
    ]
};

annotate service.RouteClassification with @Aggregation.ApplySupported : {
    Transformations : ['aggregate', 'groupby'],
    GroupableProperties : [ RouteID ],
    AggregatableProperties : [
        { Property: AvgTimeWindowLength }
    ]
};
