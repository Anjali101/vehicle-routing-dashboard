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
        
        round(sum(Customer.number_of_articles), 3) as SumArticles: Decimal,
        round(sum(Customer.total_weight_kg), 3)    as SumWeight: Decimal,
        round(sum(Customer.total_volume_m3), 3)    as SumVolume: Decimal,
        round(avg(customer_time_window_to_min - customer_time_window_from_min), 3) as AverageServiceTime: Decimal,
        Way.route_date as RouteDate: DateTime,
        Way.route_code as RouteCode: String

        
        

    
    }group by Customer.route_id;

    entity Routes as select from my.Routes {
        key RouteID,
        
        
        };



    } 
     





