import streamlit as st
import joblib
import numpy as np

# Load your trained model and scaler
model = joblib.load("malpractice_model.pkl")  # Make sure this file exists
scaler = joblib.load("scaler.pkl")            # Make sure this file exists

st.title("🎓 Exam Malpractice Risk Predictor")

# Input fields
ca = st.number_input("CA Score", 0, 100)
mock = st.number_input("Mock Score", 0, 100)
final = st.number_input("Final Score", 0, 100)
external = st.number_input("External Score", 0, 100)

# Predict button
if st.button("Predict Malpractice Risk"):
    X = np.array([[ca, mock, final, external]])
    X_scaled = scaler.transform(X)

    pred = model.predict(X_scaled)[0]
    prob = model.predict_proba(X_scaled)[0][1]

    st.success(f"Prediction: {'Malpractice' if pred == 1 else 'Normal'}")
    st.info(f"Risk Score: {prob:.2%}")
