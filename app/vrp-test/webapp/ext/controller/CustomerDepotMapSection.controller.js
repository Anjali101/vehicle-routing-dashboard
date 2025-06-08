sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
  "use strict";

  return Controller.extend("vrptest.ext.controller.CustomerDepotMapSection", {
    onAfterRendering: async function () {
      console.log("🔍 Controller active...");

      const view = this.getView();
      const model = view.getModel();
      const ctx = view.getBindingContext();

      if (!ctx || !model) {
        console.warn("⚠️ No binding context or model.");
        return;
      }

      const routeId = ctx.getProperty("Route");
      console.log("📦 Route ID:", routeId);

      try {
        const data = await model.request(`/Customers?$filter=ROUTE_ID eq ${routeId}`);
        console.log("📊 Raw Customer Data:", data);

        const chartData = data.value.map(c => ({
          CustomerCode: c.CUSTOMER_CODE,
          TotalWeight: c.TOTAL_WEIGHT_KG
        }));

        console.log("📊 Processed chart data:", chartData);

        const chart = view.byId("customerChart");
        if (!chart) {
          console.error("❌ Chart not found.");
          return;
        }

        const jsonModel = new JSONModel({ data: chartData });
        chart.setModel(jsonModel);
        chart.bindAggregation("data", "/data");

        console.log("✅ Chart data bound.");
      } catch (err) {
        console.error("❌ Error fetching customers:", err);
      }
    }
  });
});
