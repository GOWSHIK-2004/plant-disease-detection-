 AI-Powered Crop Health Monitoring System

**Project Overview**
This AI-based system helps farmers monitor crop health in real time, detect plant diseases, and provide actionable solutions via a mobile app. The system combines IoT sensors, machine learning, and AI-driven recommendations for proactive crop management.

 Key Features

#Real-Time Environmental Monitoring

* Uses **DHT11 sensor** for temperature and humidity
* Uses **soil moisture sensor**
* Sensors connected to **ESP32 microcontroller**
* Real-time sensor data is sent to the backend, which monitors environmental thresholds
* Alerts are generated automatically if any parameter exceeds critical limits (e.g., low soil moisture or high humidity)

#Disease Detection

* **YOLO model** trained on annotated plant leaf images
* Classifies leaves as healthy or diseased
* Backend sends disease label and environmental context to **Google Gemini API**
* Gemini generates detailed, farmer-friendly explanations including:

  * Disease causes and early symptoms
  * Eco-friendly pesticide suggestions
  * Preventive measures

#Mobile App

* Built using **Flutter**
* Communicates with Node.js backend through **REST APIs**
* Displays:

  * Live sensor data dashboard
  * Alerts and notifications
  * Disease detection results and recommendations
  * Historical data logs

# Tech Stack

* **Hardware:** DHT11, Soil Moisture Sensor, ESP32
* **Backend:** Node.js, Express
* **Frontend:** Flutter Mobile App
* **AI/ML:** YOLO for plant disease detection
* **LLM Integration:** Google Gemini API for generating actionable recommendations

# How It Works

1. Sensors monitor temperature, humidity, and soil moisture in real time.
2. Data is sent to the Node.js backend, which validates readings and triggers alerts if thresholds are exceeded.
3. Farmers can scan plant leaves via the app for disease detection.
4. YOLO model identifies whether the leaf is healthy or diseased.
5. Disease information, along with sensor context, is sent to Gemini API.
6. Gemini generates detailed solutions and preventive measures.
7. Recommendations are displayed in the app in an easy-to-understand format.

# Sensor Data Purpose

* Sensor readings do **not directly detect disease**
* They **support disease prediction** by monitoring conditions favorable for disease development:

  * High humidity → fungal infections
  * Low soil moisture → plant stress
  * High temperature + humidity → bacterial growth

# Learning Outcomes

* Integrated IoT sensors with a cloud backend for real-time monitoring
* Built a complete mobile app with Flutter
* Trained a YOLO model for plant disease classification
* Leveraged LLMs (Gemini API) to generate actionable, human-friendly recommendations



