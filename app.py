import streamlit as st
import pandas as pd
import plotly.express as px
import os

st.set_page_config(page_title="Tablespace Usage Dashboard", layout="wide")

st.title("📊 Oracle Tablespace Usage Dashboard")

CSV_FILE = "ts_usage.csv"   # CSV file expected in same folder

# Check if file exists
if not os.path.exists(CSV_FILE):
    st.error(f"CSV file '{CSV_FILE}' not found in the app directory!")
else:
    try:
        # Load CSV automatically
        df = pd.read_csv(CSV_FILE)

        st.subheader("📄 Raw Data")
        st.dataframe(df, use_container_width=True)

        # Validate required columns
        required_cols = {"TABLESPACE_NAME", "USED_MB"}
        
        if not required_cols.issubset(df.columns):
            st.error(f"CSV must contain columns: {', '.join(required_cols)}")
        else:
            st.subheader("🥧 Tablespace Used Space Pie Chart")
            fig = px.pie(
                df,
                names="TABLESPACE_NAME",
                values="USED_MB",
                title="Tablespace Used Space (MB)",
                hole=0.4
            )
            st.plotly_chart(fig, use_container_width=True)

    except Exception as e:
        st.error(f"Error loading CSV: {e}")
