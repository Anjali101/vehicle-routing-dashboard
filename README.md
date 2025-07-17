#This is our VRP-Scenario Project 

The structure of the projects are as follows:

In the app folder there are 4 folders corresponding to the 4 dashboards. Each Dashboard corresponds to the one of the task:


vrp-test: First Task,
classification: Second Task,
characteristics: Third Task,
insights: Foruth Task,


In the srv folder, the processor-service.cds file contains the according entitities for each of the service. The services in this file are 
ordered acccording to the tasks and the dashbaord order from above. 

The annotations for each dashboards are sperated into annotations.cds files in the respective app folders.



The functions for the 2 AI Buttons are done in the processors-service.js.

The evaluate AI button works via the doquery and on ai function similar to the step in the onboarding guide. 
The Diagramm Function from the query is different. The onDiagramm and doquerydiagramm function generate the AI Reponse for the graph and return a json of the AI response.
The rendersvg function then renders an svg diagramm from the json  to be outputted in the dashboard. 



Some csvs from the orioginal datasets were enriched with values like weightusage and volumeusage. This was done to be able to hardcode/hardcast average values of certain statistics across all routes for easier data providing. 
Also 2 csvs were extra added for the same reasons.