sap.ui.define([
    "sap/ui/core/mvc/Controller"
  ], function (Controller) {
    "use strict";
  
    return Controller.extend("vrptest.ext.controller.CustomerDepotMapSection", {
      onAfterRendering: function () {
        // Check if Leaflet is loaded
        if (!window.L) {
          console.error("Leaflet not loaded.");
          return;
        }
  
        // Prevent re-initialization
        if (this._mapInitialized) return;
  
        const map = L.map("map").setView([44.7866, 17.1856], 7); // Center: Bosnia
  
        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
          attribution: "© OpenStreetMap contributors"
        }).addTo(map);
  
        this._mapInitialized = true;
  
        // TEMP test marker
        L.marker([44.7866, 17.1856]).addTo(map)
          .bindPopup("Depot: Banja Luka").openPopup();
      }
    });
  });
  