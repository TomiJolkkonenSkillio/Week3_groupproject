import React, { useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";

function App() {
  const [consultantName, setConsultantName] = useState("");
  const [customerName, setCustomerName] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [lunchBreak, setLunchBreak] = useState("");
  const [report, setReport] = useState(null);

  const handleAddHours = async () => {
    try {
      await axios.post("http://localhost:5000/time_management/", {
        consultant_name: consultantName,
        customer_name: customerName,
        start_time: startTime,
        end_time: endTime,
        lunch_break: lunchBreak,
      });
      alert("Hours added successfully!");
    } catch (error) {
      console.error("Error adding hours:", error);
      alert("Failed to add hours.");
    }
  };

  const handleGetDailyReport = async () => {
    try {
      const response = await axios.get("http://localhost:5000/generate_report/");
      setReport(response.data);
    } catch (error) {
      console.error("Error fetching daily report:", error);
      alert("Failed to fetch daily report.");
    }
  };

  /* const handleGetWeeklyReport = async () => {
    try {
      const response = await axios.get("http://localhost:5000/generate_report/weekly");
      setReport(response.data);
    } catch (error) {
      console.error("Error fetching weekly report:", error);
      alert("Failed to fetch weekly report.");
    }
  };
  */

  return (
    <div className="container py-5">
      <h1 className="text-center mb-4">Consultant Time Management</h1>

      <div className="row justify-content-center">
        <div className="col-md-6">
          <div className="mb-3">
            <label className="form-label">Consultant Name</label>
            <input
              type="text"
              value={consultantName}
              onChange={(e) => setConsultantName(e.target.value)}
              className="form-control"
            />
          </div>

          <div className="mb-3">
            <label className="form-label">Customer Name</label>
            <input
              type="text"
              value={customerName}
              onChange={(e) => setCustomerName(e.target.value)}
              className="form-control"
            />
          </div>

          <div className="mb-3">
            <label className="form-label">Start Time</label>
            <input
              type="datetime-local"
              value={startTime}
              onChange={(e) => setStartTime(e.target.value)}
              className="form-control"
            />
          </div>

          <div className="mb-3">
            <label className="form-label">End Time</label>
            <input
              type="datetime-local"
              value={endTime}
              onChange={(e) => setEndTime(e.target.value)}
              className="form-control"
            />
          </div>

          <div className="mb-3">
            <label className="form-label">Lunch Break (in minutes)</label>
            <input
              type="number"
              value={lunchBreak}
              onChange={(e) => setLunchBreak(e.target.value)}
              className="form-control"
            />
          </div>

          <div className="d-flex justify-content-between">
            <button className="btn btn-primary" onClick={handleAddHours}>
              Add Hours
            </button>
            <button className="btn btn-success" onClick={handleGetDailyReport}>
              Get Daily Report
            </button>
            <button className="btn btn-warning" onClick={handleGetWeeklyReport}>
              Get Weekly Report
            </button>
          </div>
        </div>
      </div>

      {report && (
        <div className="mt-4 p-3 border rounded bg-light">
          <h2 className="text-center">Report</h2>
          <pre className="bg-white p-2">{JSON.stringify(report, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;
