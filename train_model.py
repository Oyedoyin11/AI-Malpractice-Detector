import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import RandomForestClassifier
import joblib

# 📊 Simulate sample student score data
np.random.seed(42)
n = 200
data = pd.DataFrame({
    'CA_Score': np.random.randint(30, 80, n),
    'Mock_Score': np.random.randint(35, 85, n),
    'Final_Score': np.random.randint(40, 90, n),
    'External_Score': np.random.randint(60, 100, n),
})

# 🚨 Create a dummy target: label as 1 (malpractice) if External >> Final
data['Malpractice_Label'] = (data['External_Score'] - data['Final_Score']) > 20

# 🧪 Train-test split
X = data[['CA_Score', 'Mock_Score', 'Final_Score', 'External_Score']]
y = data['Malpractice_Label']

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_scaled, y)

# 💾 Save model and scaler
joblib.dump(model, 'malpractice_model.pkl')
joblib.dump(scaler, 'scaler.pkl')

print("✅ Model and scaler saved!")
