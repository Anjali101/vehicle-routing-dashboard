module.exports = class scenariocharacteristics extends cds.ApplicationService {
  init() {
    this.on("checkAI", (req) => this.onCheckAI(req));
    this.on("diagram", (req) => this.onDiagram(req));
    return super.init();
  }

  async onCheckAI(req) {
    const data = await SELECT.from(this.entities.characteristics);
    if (!data?.length) return req.error(400, "No data available.");

    const headers = Object.keys(data[0]).filter(h => h !== 'CustomerCode');
    let csv = headers.join(',') + '\n';
    data.forEach(row => {
      const line = headers.map(h => row[h]).join(',');
      csv += line + '\n';
    });

    const userInput = req.data.Query;
    const contextPrompt = `
Given this delivery logistics data (CSV below), answer the following question.
Columns include:
- Route: Route ID
- CustomerNumber: Number of Customers
- SumWeight: Total weight
- SumVolume: Total volume
- AverageServiceTime: Avg service time
- SumArticles: Total articles
- DrivingTime, DeliveryTime, ActiveTime: Time metrics
- VehicleCost: Cost associated

Question:
${userInput}`.trim();

    const token = await getToken();
    const response = await doQuery(token, contextPrompt, csv);
    const message = response?.choices?.[0]?.message?.content || "AI did not return a result.";

    console.log("🧠 AI Input:\n", userInput);
    console.log("📥 AI Output:\n", message);

    return message;
  }

  async onDiagram(req) {
    const { xField, yField, Query } = req.data;

    const allowedFields = [
      "CustomerNumber", "SumWeight", "SumVolume", "AverageServiceTime",
      "SumArticles", "DrivingTime", "DeliveryTime", "ActiveTime", "VehicleCost"
    ];

    if (!allowedFields.includes(xField) || !allowedFields.includes(yField)) {
      return req.error(400, `Invalid field(s): ${xField}, ${yField}`);
    }
    if (xField === yField) {
      return req.error(400, "xField and yField must be different.");
    }

    const rows = await SELECT.from(this.entities.characteristics).columns(xField, yField);
    const jsonData = JSON.stringify(rows, null, 2);

    const defaultPrompt = `
You are a helpful assistant that generates clean SVG scatter plots with regression lines.

Given a JSON array of objects with numeric fields "${xField}" and "${yField}", generate a complete and valid <svg> element that includes:

1. A scatter plot:
   - Plot each (${xField}, ${yField}) pair as a blue circle (radius 4–6).
   - Fit a red regression line to the data using linear regression.
   - Compute the regression function (e.g., "y = 1.25x + 34.6") and display it inside the plot, preferably top-right or top-left.

2. Axis styling:
   - Add numeric tick marks (with labels) on both X and Y axes.
   - Label the X-axis as "${xField}" and the Y-axis as "${yField}" using clear <text> elements.
   - Ensure axis labels are correctly positioned (X-axis centered below, Y-axis rotated left).

3. Layout and scale:
   - Set canvas size to at least width="600" and height="400".
   - Use padding/margins so no elements are clipped (at least 40px on each side).
   - Flip the Y-axis so values increase upwards (not inverted).
   - Keep font sizes small but readable (10–12px) for axis and tick labels.

Return only a raw <svg>...</svg> block with no HTML wrappers, markdown, or JavaScript.
`.trim();

    const finalQuery = Query || defaultPrompt;
    const token = await getToken();
    const response = await doDiagramQuery(token, finalQuery, jsonData);

    let svg = response?.choices?.[0]?.message?.content || "<p>AI failed to generate chart.</p>";
    if (svg.startsWith("```")) {
      svg = svg.replace(/```(?:html|svg)?/g, "").trim();
    }

    console.log("📈 Generated SVG for:", xField, yField);
    return svg;
  }
};


// --- 🔐 SAP AI Core Token Fetch ---
async function getToken() {
  const url = 'https://btplearning-w4kbx4of.authentication.us10.hana.ondemand.com/oauth/token?grant_type=client_credentials&response_type=token';
  const username = process.env.USERNAME;
  const password = process.env.PASSWORD;

  const headers = {
    'Authorization': 'Basic ' + Buffer.from(username + ':' + password).toString('base64'),
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  const response = await fetch(url, {
    method: 'POST',
    headers
  });

  const data = await response.json();
  return data.access_token;
}

// --- 🧠 SAP AI Core Diagram Generation ---
async function doDiagramQuery(token, query, inputJson) {
  const url = "https://api.ai.prod.us-east-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d85ed0c1b02d8a27/chat/completions?api-version=2023-05-15";

  const headers = {
    "Content-Type": "application/json",
    "AI-Resource-Group": "default",
    "Authorization": "Bearer " + token
  };

  const body = {
    
    messages: [
      {
        role: "system",
        content: "You are a helpful assistant that outputs HTML/SVG for visualizing data. Step 1: Repeat the CSV data you received exactly as it was given."
      },
      {
        role: "user",
        content: `Given the following JSON array:\n\n${inputJson}\n\n${query}`
      }
    ],
    max_tokens: 5000,
    temperature: 0.2
  };

  const response = await fetch(url, {
    method: "POST",
    headers,
    body: JSON.stringify(body)
  });

  return await response.json();
}

// --- 🧠 SAP AI Core Data Q&A ---
async function doQuery(token, query, csvData) {
  const url = "https://api.ai.prod.us-east-1.aws.ml.hana.ondemand.com/v2/inference/deployments/d85ed0c1b02d8a27/chat/completions?api-version=2023-05-15";

  const headers = {
    "Content-Type": "application/json",
    "AI-Resource-Group": "default",
    "Authorization": "Bearer " + token
  };

  const body = {
    messages: [
      {
        role: "system",
        content: "You are a helpful assistant that analyzes CSV data and answers questions."
      },
      {
        role: "user",
        content: `Given the following CSV:\n\n${csvData}\n\n${query}`
      }
    ],
    max_tokens: 1000,
    temperature: 0.0
  };

  const response = await fetch(url, {
    method: "POST",
    headers,
    body: JSON.stringify(body)
  });

  return await response.json();
}

