using { sap.capire.vrp as my } from '../db/schema';

service Visualization {

    @readonly
    entity RouteAggregated as select from my.Route {
        @UI.Hidden : false
        key route_code as RouteCode,
        @UI.Hidden : false
        route_id as Route  ,
        sum(result_total_cost_km) as TotalKilometers : Decimal(15,2),
        max(result_total_cost_km) as MaxKilometers : Decimal(15,2),
        count(route_id) as RouteCount : Integer
    } group by route_code, route_id;

}

