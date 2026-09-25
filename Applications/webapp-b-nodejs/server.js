const express = require("express");
const client = require("prom-client");

const app = express();
const register = new client.Registry();

client.collectDefaultMetrics({ register });

const requestCounter = new client.Counter({
  name: "node_http_requests_total",
  help: "Total HTTP Requests"
});

register.registerMetric(requestCounter);

app.get("/", (req, res) => {
  requestCounter.inc();
  res.json({
    application: "WebApp-B",
    status: "Running",
    environment: process.env.ENV || "prod"
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.get("/ready", (req, res) => {
  res.status(200).json({ status: "ready" });
});

app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

app.listen(8080, () => {
  console.log("Server running on port 8080");
});
