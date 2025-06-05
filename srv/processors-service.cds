using { sap.capire.vrp as my } from '../db/schema';

service Visualization {

    @readonly
    entity Routelocations as select from my.Customer as Customer 
    left join my.Depots as Depot on Customer.route_id = Depot.route_id
    left join my.Route as Way on Customer.route_id = Way.route_id {

       
        @Common.ValueList: {
            CollectionPath: 'Routes',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: 'Route',
                    ValueListProperty: 'RouteID'
                }
            ]
        }



        @UI.Hidden: false
        key Customer.route_id as Route,
        @UI.Hidden: false
        sum(Customer.number_of_articles) as SumArticles: Decimal,
        sum(Customer.total_weight_kg) as SumWeight: Decimal,
        sum(Customer.total_volume_m3) as SumVolume: Decimal,
        
        @UI.Hidden: false
        max(Way.route_code) as RouteCode,
        @UI.Hidden: false
        max(Way.route_date) as RouteDate,
        @UI.Hidden: false
        Way.algorithm_number_of_iterations as Iterations,
        @UI.Hidden: false
        Way.result_total_cost_km as TotalDistance

        
    }group by Customer.route_id, ;

    entity Routes as select from my.Routes {
        key RouteID,
        
        
        };



    } 
     





